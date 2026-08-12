import 'package:flutter/material.dart';

enum AppRole {
  contractor('contractor', 'Contractor'),
  subContractor('sub_contractor', 'Sub Contractor'),
  siteSupervisor('site_supervisor', 'Site Supervisor');

  const AppRole(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static AppRole? fromString(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'contractor':
        return AppRole.contractor;
      case 'sub_contractor':
      case 'subcontractor':
        return AppRole.subContractor;
      case 'site_supervisor':
      case 'site-supervisor':
      case 'supervisor':
        return AppRole.siteSupervisor;
      default:
        return null;
    }
  }

  /// Roles fall back to the full main-app feature set.
  static AppRole fromStringOr(String? value, AppRole fallback) =>
      fromString(value) ?? fallback;

  /// Modules visible to this role. Contractor owns the full recruitment
  /// pipeline; Sub-Contractor works the assigned workforce and site ops.
  Set<AppModule> get modules => switch (this) {
        AppRole.contractor => {
            AppModule.dashboard,
            AppModule.company,
            AppModule.projects,
            AppModule.recruitment,
            AppModule.workforce,
            AppModule.materials,
            AppModule.financial,
            AppModule.reports,
            AppModule.notifications,
            // AppModule.profile,
          },
        AppRole.subContractor => {
            AppModule.dashboard,
            AppModule.company,
            AppModule.projects,
            AppModule.workforce,
            AppModule.materials,
            AppModule.financial,
            AppModule.reports,
            AppModule.notifications,
            // AppModule.profile,
          },
        AppRole.siteSupervisor => {
            AppModule.dashboard,
            AppModule.projects,
            AppModule.workforce,
            AppModule.attendance,
            AppModule.reports,
            AppModule.notifications,
            // AppModule.profile,
          },
      };
}

enum AppModule {
  dashboard('Dashboard', Icons.space_dashboard_outlined, Icons.space_dashboard),
  company('Company', Icons.business_outlined, Icons.business),
  projects('Projects', Icons.construction_outlined, Icons.construction),
  recruitment('Recruitment', Icons.person_search_outlined, Icons.person_search),
  workforce('Workforce', Icons.groups_outlined, Icons.groups),
  attendance('Attendance', Icons.fact_check_outlined, Icons.fact_check),
  materials('Materials', Icons.inventory_2_outlined, Icons.inventory_2),
  financial('Financial', Icons.account_balance_wallet_outlined, Icons.account_balance_wallet),
  reports('Reports', Icons.insert_chart_outlined, Icons.insert_chart),
  notifications('Notifications', Icons.notifications_outlined, Icons.notifications);
  // profile('Profile', Icons.person_outline, Icons.person);

  const AppModule(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}