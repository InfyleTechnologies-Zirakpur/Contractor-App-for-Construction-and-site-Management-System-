import 'package:contractor_app/core/roles/app_role.dart';
import 'package:contractor_app/features/company/presentation/company_screen.dart';
import 'package:contractor_app/features/materials/presentation/materials_screen.dart';
import 'package:contractor_app/features/projects/presentation/projects_screen.dart';
import 'package:contractor_app/features/recruitment/presentation/recruitment_screen.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'module_placeholder_screen.dart';

/// Single mapping from module to its real screen. `HomeShell` uses it for
/// tabs, dashboard quick-actions push it as a route, and new screens register
/// here the moment a feature lands.
Widget screenFor(AppModule module) {
  switch (module) {
    case AppModule.dashboard:
      return const DashboardScreen();
    case AppModule.company:
      return const CompanyScreen();
    case AppModule.projects:
      return const ProjectsScreen();
    case AppModule.materials:
      return const MaterialsScreen();
    case AppModule.recruitment:
      return const RecruitmentScreen();
    default:
      return ModulePlaceholderScreen(module: module);
  }
}