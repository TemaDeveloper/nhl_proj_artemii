import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend_nhl/core/constants/firestore_constants.dart';
import 'package:frontend_nhl/core/utils/date_time_utils.dart';
import 'package:frontend_nhl/core/utils/logger.dart';
import 'package:frontend_nhl/data/models/game_model.dart';
import 'package:frontend_nhl/data/repositories/game_repository.dart';
import 'package:frontend_nhl/domain/entities/game.dart';

class FirestoreGameRepository implements GameRepository {
  final FirebaseFirestore _firestore;
  final String _collectionPath;

  FirestoreGameRepository({
    FirebaseFirestore? firestore,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _collectionPath = FirestoreConstants.gamesCollection;

  @override
  Stream<List<Game>> getTodayGames() {
    AppLogger.info('Fetching today\'s games', tag: 'GameRepository');
    final dateRange = DateTimeUtils.getTodayDateRange();
    return getGamesByDateRange(dateRange.start, dateRange.end);
  }

  @override
  Stream<List<Game>> getAllGames() {
    AppLogger.firestore('Query', _collectionPath, params: {'orderBy': 'startTime'});
    
    return _firestore
        .collection(_collectionPath)
        .orderBy('startTime', descending: false)
        .snapshots()
        .map(_mapSnapshotToGames);
  }

  Stream<List<Game>> getGamesByDateRange(DateTime start, DateTime end) {
    // Convert to UTC ISO strings for Firestore query
    final startString = start.toUtc().toIso8601String();
    final endString = end.toUtc().toIso8601String();

    AppLogger.firestore(
      'Query with date range',
      _collectionPath,
      params: {
        'start': start.toLocal().toString(),
        'end': end.toLocal().toString(),
      },
    );

    return _firestore
        .collection(_collectionPath)
        .where('startTime', isGreaterThanOrEqualTo: startString)
        .where('startTime', isLessThan: endString)
        .orderBy('startTime', descending: false)
        .snapshots()
        .map(_mapSnapshotToGames);
  }

  @override
  Future<Game?> getGameById(String gameId) async {
    try {
      AppLogger.info('Fetching game: $gameId', tag: 'GameRepository');
      
      final doc = await _firestore.collection(_collectionPath).doc(gameId).get();
      
      if (!doc.exists) {
        AppLogger.warning('Game not found: $gameId', tag: 'GameRepository');
        return null;
      }
      
      final model = GameModel.fromFirestore(doc);
      AppLogger.success('Game fetched successfully: $gameId', tag: 'GameRepository');
      return model.toEntity();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch game: $gameId',
        tag: 'GameRepository',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to fetch game: $e');
    }
  }

  @override
  Stream<List<Game>> getTeamGames(String teamId) {
    AppLogger.info('Fetching games for team: $teamId', tag: 'GameRepository');
    
    return _firestore
        .collection(_collectionPath)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snapshot) {
          // Get raw docs to debug status values
          AppLogger.debug(
            'Raw snapshot - ${snapshot.docs.length} documents received',
            tag: 'GameRepository',
          );
          
          if (snapshot.docs.isNotEmpty) {
            final statusCounts = <String, int>{};
            for (var doc in snapshot.docs) {
              final data = doc.data();
              final status = data['status'] ?? 'UNKNOWN';
              statusCounts[status.toString()] = (statusCounts[status.toString()] ?? 0) + 1;
            }
            AppLogger.debug(
              'Status distribution: $statusCounts',
              tag: 'GameRepository',
            );
          }
          
          return _mapSnapshotToGames(snapshot);
        })
        .map((allGames) {
          final uniqueTeamIds = <String>{};
          for (var game in allGames) {
            uniqueTeamIds.add(game.homeTeamId);
            uniqueTeamIds.add(game.awayTeamId);
          }
          AppLogger.debug(
            'All unique team IDs in games: $uniqueTeamIds',
            tag: 'GameRepository',
          );
          
          AppLogger.debug(
            'Looking for team ID: "$teamId" - exists: ${uniqueTeamIds.contains(teamId)}',
            tag: 'GameRepository',
          );
          
          final gamesForTeam = allGames
              .where((game) => game.homeTeamId == teamId || game.awayTeamId == teamId)
              .toList();
          
          AppLogger.info(
            'Found ${gamesForTeam.length} total games for team: $teamId',
            tag: 'GameRepository',
          );
          
          if (gamesForTeam.isNotEmpty) {
            final gameCounts = <String, int>{};
            for (var game in gamesForTeam) {
              final statusStr = game.status.toDisplayString();
              gameCounts[statusStr] = (gameCounts[statusStr] ?? 0) + 1;
            }
            AppLogger.debug(
              'Games for team status counts: $gameCounts',
              tag: 'GameRepository',
            );
          }
          
          final teamGames = gamesForTeam
              .where((game) => game.status.isFinal || game.status.isLive)
              .take(5) 
              .toList();
          
          AppLogger.info(
            'Found ${teamGames.length} played games for team: $teamId after status filter',
            tag: 'GameRepository',
          );
          
          return teamGames;
        });
  }

  List<Game> _mapSnapshotToGames(QuerySnapshot snapshot) {
    AppLogger.debug(
      'Received ${snapshot.docs.length} documents from Firestore',
      tag: 'GameRepository',
    );
    
    final games = snapshot.docs
        .map((doc) {
          try {
            final model = GameModel.fromFirestore(doc);
            return model.toEntity();
          } catch (e, stackTrace) {
            _logDeserializationError(doc.id, e, stackTrace, doc.data());
            return null;
          }
        })
        .whereType<Game>()
        .toList();
    
    AppLogger.success(
      'Successfully mapped ${games.length} games',
      tag: 'GameRepository',
    );
    
    return games;
  }

  void _logDeserializationError(
    String docId,
    dynamic error,
    StackTrace stackTrace,
    dynamic data,
  ) {
    AppLogger.error(
      'Failed to deserialize game document: $docId',
      tag: 'GameRepository',
      error: error,
      stackTrace: stackTrace,
    );
    AppLogger.debug('Document data: $data', tag: 'GameRepository');
  }
}