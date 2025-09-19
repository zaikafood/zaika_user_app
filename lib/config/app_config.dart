enum Environment { STAGING, PRODUCTION }

class AppConfig {
  final Environment environment;
  final String baseUrl;
  AppConfig({required this.environment, required this.baseUrl});

  static AppConfig? _instance;
  static void init(Environment env) {
    if (_instance == null) {
      String baseUrl;
      switch (env) {
        case Environment.STAGING:
          baseUrl = 'https://staging.zaika.ltd';
          break;
        case Environment.PRODUCTION:
          baseUrl = 'https://zaika.ltd';
          break;
      }
      _instance = AppConfig(environment: env, baseUrl: baseUrl);
    }
  }

  // Is getter se hum AppConfig ka instance poore app mein kahin bhi access kar sakte hain
  static AppConfig get instance {
    if (_instance == null) {
      throw Exception(
          "AppConfig has not been initialized. Call AppConfig.init() first.");
    }
    return _instance!;
  }
}
