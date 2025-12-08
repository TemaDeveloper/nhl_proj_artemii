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

  @override
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

  /// Helper method to map Firestore snapshot to list of Game entities.
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

  /// Centralized error logging for deserialization failures.
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