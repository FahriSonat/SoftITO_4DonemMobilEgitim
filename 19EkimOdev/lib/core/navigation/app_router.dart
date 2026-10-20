import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/appointments/appointments_screen.dart';
import '../../features/centers/centers_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/inventory/inventory_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return _ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardScreenWrapper(),
          ),
        ),
        GoRoute(
          path: '/appointments',
          name: 'appointments',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AppointmentsScreen(),
          ),
        ),
        GoRoute(
          path: '/inventory',
          name: 'inventory',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: InventoryScreen(),
          ),
        ),
        GoRoute(
          path: '/centers',
          name: 'centers',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CentersScreenWrapper(),
          ),
        ),
      ],
    ),
  ],
);

class DashboardScreenWrapper extends StatelessWidget {
  const DashboardScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardScreen(
      onNavigateToAppointments: () => context.go('/appointments'),
      onNavigateToInventory: () => context.go('/inventory'),
      onNavigateToCenters: () => context.go('/centers'),
    );
  }
}

class CentersScreenWrapper extends StatelessWidget {
  const CentersScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return CentersScreen(
      onNavigateToAppointments: () => context.go('/appointments'),
    );
  }
}

class _ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithNavBar({required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/appointments')) return 1;
    if (location.startsWith('/inventory')) return 2;
    if (location.startsWith('/centers')) return 3;
    return 0; // dashboard
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/appointments');
        break;
      case 2:
        context.go('/inventory');
        break;
      case 3:
        context.go('/centers');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (idx) => _onItemTapped(idx, context),
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.water_drop_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard_rounded),
                      label: Text('Ana Sayfa'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_today_outlined),
                      selectedIcon: Icon(Icons.calendar_today_rounded),
                      label: Text('Randevular'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.bloodtype_outlined),
                      selectedIcon: Icon(Icons.bloodtype_rounded),
                      label: Text('Stok'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.location_on_outlined),
                      selectedIcon: Icon(Icons.location_on_rounded),
                      label: Text('Merkezler'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: child),
              ],
            ),
          );
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (idx) => _onItemTapped(idx, context),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Ana Sayfa',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_today_rounded),
                label: 'Randevular',
              ),
              NavigationDestination(
                icon: Icon(Icons.bloodtype_outlined),
                selectedIcon: Icon(Icons.bloodtype_rounded),
                label: 'Stok',
              ),
              NavigationDestination(
                icon: Icon(Icons.location_on_outlined),
                selectedIcon: Icon(Icons.location_on_rounded),
                label: 'Merkezler',
              ),
            ],
          ),
        );
      },
    );
  }
}
