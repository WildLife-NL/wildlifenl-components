import '../models/visitation_response.dart';

abstract class VisitationReadApiInterface {
  Future<VisitationResponse> getVisitationForLivingLab({
    required String livingLabID,
    required DateTime start,
    required DateTime end,
    required double cellSize,
  });
}
