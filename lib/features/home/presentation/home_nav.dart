import 'package:contractor_app/core/roles/app_role.dart';

/// Primary modules surfaced as bottom-nav tabs (in preferred order). Anything
/// in a role's allowed set that isn't listed here becomes a dashboard
/// quick-action instead.
const List<AppModule> kHomeTabModules = [
  AppModule.dashboard,
  AppModule.projects,
  AppModule.workforce,
  AppModule.materials,
  AppModule.company,
];