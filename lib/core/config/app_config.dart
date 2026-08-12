/// Runtime configuration. The backend isn't deployed yet, so `mockMode` keeps
/// the app demoable: when true, every service returns in-memory demo data
/// instead of hitting the (placeholder) API. Flip to false once the API is
/// live — screens don't change.
class AppConfig {
  AppConfig._();

  static const bool mockMode = true;
}