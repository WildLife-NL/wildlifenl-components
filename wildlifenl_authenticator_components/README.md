# wildlifenl_authenticator_components

Token- en rolvalidatie voor WildLife NL-apps. Gebruik samen met **wildlifenl_login_components** (die de token en scopes wegschrijft bij inloggen).

## Gebruik

### Dependency (Git)

```yaml
dependencies:
  wildlifenl_authenticator_components:
    git:
      url: https://github.com/WildLife-NL/wildlifenl-components.git
      ref: Wildlife-rapport-Components
      path: wildlifenl_authenticator_components
```

### API

- **WildLifeNLAuthenticator** – configureer met optionele keys en toegestane scopes.
- **hasValidToken()** – `true` als er een niet-lege `bearer_token` staat.
- **hasAccess()** – `true` als de opgeslagen scopes minstens één toegestane rol bevatten (standaard: land-user, nature-area-manager, wildlife-manager).
- **getStoredScopes()** – leest de opgeslagen scopes.
- **clearSession()** – verwijdert token en scopes (logout).

### Voorbeeld

```dart
import 'package:wildlifenl_authenticator_components/wildlifenl_authenticator_components.dart';

final auth = WildLifeNLAuthenticator(
  // Optioneel andere keys of rollen:
  // keys: AuthenticatorKeys(tokenKey: 'bearer_token', scopesKey: 'scopes'),
  // allowedScopes: ['land-user', 'wildlife-manager'],
);

final hasToken = await auth.hasValidToken();
final hasAccess = await auth.hasAccess();
if (!hasToken) { /* toon login */ }
else if (!hasAccess) { /* toon access denied */ }
else { /* toon hoofdscherm */ }

// Bij uitloggen:
await auth.clearSession();
```

De login-package schrijft `bearer_token` en `scopes` naar SharedPreferences; deze package leest en valideert ze.
