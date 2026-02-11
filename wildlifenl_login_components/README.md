# wildlifenl_login_components

Herbruikbare login-UI en interface voor e-mail/verificatiecode. Bedoeld voor Wild Rapport, WildManager en andere WildLife NL-apps.

## Gebruik

### 1. Dependency (Git of path)

In je app `pubspec.yaml`:

```yaml
dependencies:
  wildlifenl_login_components:
    git:
      url: https://github.com/WildLife-NL/wildlifenl-components.git
      ref: main  # of jouw branch
      path: wildlifenl_login_components
```

Of lokaal tijdens ontwikkelen:

```yaml
  wildlifenl_login_components:
    path: ../wildlifenl-components/wildlifenl_login_components
```

### 2a. Standaard: API in de package (aanbevolen als je dezelfde backend gebruikt)

Als je de **zelfde** WildLife NL auth-backend gebruikt (POST/PUT `auth/`), hoef je geen eigen implementatie te schrijven. De package levert de API-calls:

```dart
import 'package:wildlifenl_login_components/wildlifenl_login_components.dart';

// Eén keer opzetten (bijv. in main of bij app-start)
final baseUrl = 'https://jouw-api.example.com';  // of uit .env
final apiClient = HttpLoginApiClient(
  baseUrl: baseUrl,
  displayNameApp: 'Wild Rapport',  // of 'WildManager', etc.
);
final loginService = DefaultLoginService(apiClient, displayNameApp: 'Wild Rapport');

// Provider
runApp(
  MultiProvider(
    providers: [
      Provider<LoginInterface>.value(value: loginService),
      // ...
    ],
    child: MyApp(),
  ),
);
```

`HttpLoginApiClient` doet de HTTP-calls (POST auth/ voor code, PUT auth/ voor verifiëren) en slaat de token + scopes op in SharedPreferences. `DefaultLoginService` implementeert `LoginInterface` en gebruikt die client. In `onLoginSuccess(context, user)` krijg je `user` als `Map<String, dynamic>` (de response van de backend, o.a. `userID`, `email`, `reportAppTerms`, `scopes`).

### 2b. Eigen interface implementeren (andere backend of extra logica)

Wil je een andere backend of eigen logica (bijv. eigen ApiClient), implementeer dan zelf `LoginInterface`:

```dart
// Je eigen LoginManager die met jouw AuthApi praat
class MyLoginManager implements LoginInterface {
  final AuthApiInterface authApi;
  MyLoginManager(this.authApi);

  @override
  String? validateEmail(String? email) { ... }

  @override
  Future<bool> sendLoginCode(String email) async { ... }

  @override
  Future<dynamic> verifyCode(String email, String code) async {
    // retourneer jouw User-model (of wat de app nodig heeft)
    return await authApi.authorize(email, code);
  }

  @override
  Future<bool> resendCode(String email) async { ... }

  @override
  void setVerificationVisible(bool visible) { ... }

  @override
  void setError(bool isError, [String message = '']) { ... }

  @override
  void addListener(VoidCallback listener) { ... }

  @override
  void removeListener(VoidCallback listener) { ... }
}
```

### 3. Provider + LoginScreen tonen

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginInterface>.value(value: myLoginManager),
        // ...
      ],
      child: MyApp(),
    ),
  );
}

// Waar je de loginpagina toont:
WildLifeNLLoginScreen(
  config: WildLifeNLLoginConfig(
    logoAssetPath: 'assets/app_logo.png',
    appName: 'Wild Rapport',
    theme: LoginTheme(
      primaryColor: AppColors.darkGreen,
      accentColor: AppColors.brown,
    ),
    onLoginSuccess: (context, user) {
      // user is Map<String, dynamic> bij DefaultLoginService, of jouw User-type bij eigen implementatie
      // Jouw navigatie: profile ophalen, rol check, doorsturen naar Overzicht/Terms/AccessDenied
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => OverzichtScreen()),
        (_) => false,
      );
    },
    registrationInfoWidget: LoginOverlay(),  // optioneel: "Hoe werkt de registratie?"
    showErrorDialog: (context, messages) {
      showDialog(
        context: context,
        builder: (ctx) => ErrorOverlay(messages: messages),
      );
    },
  ),
)
```

### 4. Assets

De app declareert zelf de assets (logo, eventueel loader). Voor een custom loader bij verificatie:

- Geef in `VerificationCodeInput` (of via config) een `loadingWidget` mee (bijv. Lottie).
- Anders gebruikt de package een standaard `CircularProgressIndicator`.

## Wat zit in de package

- **LoginInterface** – abstracte interface voor login-logica.
- **LoginApiClient** + **HttpLoginApiClient** – interface en standaardimplementatie voor de auth-API (code versturen/verifiëren, token opslaan).
- **DefaultLoginService** – standaardimplementatie van `LoginInterface` die `LoginApiClient` gebruikt; geschikt voor alle apps met dezelfde backend.
- **WildLifeNLLoginScreen** – volledige pagina (branding + e-mail of code).
- **LoginBranding**, **LoginEmailForm**, **VerificationCodeInput** – herbruikbare widgets.
- **LoginTheme** – kleuren/stijl (overschrijfbaar per app).

Je kunt dus kiezen: ofwel gebruik je de standaard API + service (zelfde backend op elke app), ofwel implementeer je zelf `LoginInterface` voor een andere backend of extra logica.
