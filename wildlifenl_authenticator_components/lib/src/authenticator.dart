import 'package:shared_preferences/shared_preferences.dart';

/// Standaard keys zoals de login-package ze wegschrijft.
class AuthenticatorKeys {
  const AuthenticatorKeys({
    this.tokenKey = 'bearer_token',
    this.scopesKey = 'scopes',
  });
  final String tokenKey;
  final String scopesKey;
}

/// Default toegestane rollen (scopes) voor WildLife NL-apps.
const List<String> defaultAllowedScopes = [
  'land-user',
  'nature-area-manager',
  'wildlife-manager',
];

/// Authenticator: token check, rol/scope check, session clearen.
/// Gebruik dezelfde keys als de login-package (bearer_token, scopes).
class WildLifeNLAuthenticator {
  WildLifeNLAuthenticator({
    AuthenticatorKeys keys = const AuthenticatorKeys(),
    List<String> allowedScopes = defaultAllowedScopes,
  })  : _keys = keys,
        _allowedScopes = allowedScopes.map((s) => s.toLowerCase().trim()).toSet();

  final AuthenticatorKeys _keys;
  final Set<String> _allowedScopes;

  /// Of er een niet-lege token in SharedPreferences staat.
  Future<bool> hasValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keys.tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Of de opgeslagen scopes minstens één toegestane rol bevatten.
  Future<bool> hasAccess() async {
    final prefs = await SharedPreferences.getInstance();
    final scopes = prefs.getStringList(_keys.scopesKey) ?? const [];
    if (scopes.isEmpty) return false;
    final normalized = scopes.map((s) => s.toLowerCase().trim()).toSet();
    return normalized.intersection(_allowedScopes).isNotEmpty;
  }

  /// Haalt de opgeslagen scopes op (alleen lezen).
  Future<List<String>> getStoredScopes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keys.scopesKey) ?? const [];
  }

  /// Verwijdert token en scopes (logout / access denied).
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keys.tokenKey);
    await prefs.remove(_keys.scopesKey);
  }
}
