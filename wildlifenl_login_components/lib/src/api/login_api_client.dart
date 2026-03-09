/// Interface voor de auth-API: code versturen en verifiëren.
/// De package levert [HttpLoginApiClient]; een app kan een eigen implementatie geven.
abstract class LoginApiClient {
  /// Verstuurt een login/verificatiecode naar het opgegeven e-mailadres.
  Future<void> sendLoginCode(String displayNameApp, String email);

  /// Verifieert de code, slaat token (en scopes) op en retourneert de response-body (o.a. token, userID, email).
  Future<Map<String, dynamic>> verifyCode(String email, String code);
}
