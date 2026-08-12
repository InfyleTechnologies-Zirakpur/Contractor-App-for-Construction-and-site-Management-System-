import 'package:contractor_app/core/roles/app_role.dart';
import 'package:contractor_app/features/auth/data/services/auth_session_store.dart';
import 'package:flutter/material.dart';
import 'home_nav.dart';
import 'screen_registry.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  AppRole get _role => AuthSessionStore.instance.role;

  late final List<AppModule> _tabs;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabs = _buildTabs(_role);
  }

  List<AppModule> _buildTabs(AppRole role) {
    final allowed = role.modules;
    final tabs = kHomeTabModules.where(allowed.contains).toList();
    if (!tabs.contains(AppModule.dashboard)) {
      tabs.insert(0, AppModule.dashboard);
    }
    // if (!tabs.contains(AppModule.profile)) {
    //   tabs.add(AppModule.profile);
    // }
    return tabs;
  }

  Widget _screenFor(AppModule module) => screenFor(module);

  @override
  Widget build(BuildContext context) {
    final tabs = _tabs;
    return Scaffold(
      body: IndexedStack(
        index: _tabIndex,
        children: [for (final tab in tabs) _screenFor(tab)],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (index) => setState(() => _tabIndex = index),
        destinations: [
          for (final tab in tabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}