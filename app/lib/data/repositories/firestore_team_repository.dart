import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend_nhl/data/repositories/team_repository.dart';
import 'package:frontend_nhl/core/constants/firestore_constants.dart';
import 'package:frontend_nhl/core/utils/logger.dart';
import 'package:frontend_nhl/data/models/team_model.dart';
import 'package:frontend_nhl/domain/entities/team.dart';

class FirestoreTeamRepository implements TeamRepository {
  final FirebaseFirestore _firestore;
  final String _collectionPath;

  FirestoreTeamRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _collectionPath = FirestoreConstants.teamsCollection;

  @override
  Future<Team> getTeamDetails(String teamId) async {
    AppLogger.firestore('Query', '$_collectionPath/$teamId');
    try {
      final doc = await _firestore.collection(_collectionPath).doc(teamId).get();

      if (!doc.exists || doc.data() == null) {
        AppLogger.error('Team document not found: $teamId', tag: 'TeamRepository');
        throw Exception('Team with ID $teamId not found.');
      }

      // ADD THIS LOG:
      AppLogger.info('Team data from Firestore: ${doc.data()}', tag: 'TeamRepository');

      final model = TeamModel.fromFirestore(doc);

      AppLogger.success('Team fetched successfully: ${model.toString()}', tag: 'TeamRepository');
      return model.toEntity();
    } catch (e, stackTrace) {
      // Use the helper for standardized error logging
      _logFetchError(teamId, e, stackTrace);
      throw Exception('Failed to fetch team details: $e');
    }
  }

  /// Centralized error logging for fetch failures.
  void _logFetchError(String docId, dynamic error, StackTrace stackTrace) {
    AppLogger.error(
      'Failed to fetch team document: $docId',
      tag: 'TeamRepository',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
