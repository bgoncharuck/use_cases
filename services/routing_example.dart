/// app

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    navigatorKey = GlobalKey<NavigatorState>();
    final routeHistoryObserver = RouteHistoryObserver();

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: PopScope(
        canPop: false,
        onPopInvokedWithResult: (_, __) {
          if (routeHistoryObserver.top?.settings.name == pathHomeScreen) {
            return;
          }

          navigatorKey.currentState!.pop();
        },
        child: Stack(
          children: [
            Center(
              child: Navigator(
                key: navigatorKey,
                observers: [routeHistoryObserver],
                onGenerateRoute: generateRoute,
                initialRoute: pathInitialization,
              ),
            ),
            const Position(child: Something()),
          ],
        ),
      ),
    );
  }
}

/// routes

late GlobalKey<NavigatorState> navigatorKey;

const String pathHomeScreen = '/home_screen';
const String pathDirectoryScreen = '/directory_screen';
const String pathSettingsScreen = '/settings_screen';

Route<dynamic> generateRoute(RouteSettings settings) {
  final arguments = settings.arguments;

  Widget path;
  switch (settings.name) {
    case pathHomeScreen:
    case '/':
      path = HomeLocator(
        controller: HomeController(),
        child: const HomeScreen(),
      );
    case pathDirectoryScreen:
      path = DirectoryScreenLocator(
        controller: DirectoryScreenController(
          params: arguments! as DirectoryParams,
        ),
        child: const DirectoryScreen(),
      );
    case pathSettingsScreen:
      path = SettingsLocator(
        controller: SettingsController(),
        child: const SettingsScreen(),
      );
    default:
      throw const RouteException('Route not found');
  }

return PageRouteBuilder(
    settings: settings,
    maintainState: false,
    opaque: false,
    transitionDuration: const Duration(milliseconds: 144),
    reverseTransitionDuration: const Duration(milliseconds: 144),
    pageBuilder: (context, animation, secondaryAnimation) => path,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1, 0);
      const end = Offset.zero;
      const curve = Curves.easeInSine;

      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

class RouteException implements Exception {
  const RouteException(this.message);
  final String message;
}

class RouteHistoryObserver extends NavigatorObserver {
  final List<Route<dynamic>> _history = [];

  List<Route<dynamic>> get history => List.unmodifiable(_history);

  Route<dynamic>? get top => _history.isNotEmpty ? _history.last : null;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _history.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _history.remove(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _history.remove(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final index = _history.indexOf(oldRoute!);
    if (index != -1 && newRoute != null) {
      _history[index] = newRoute;
    }
  }
}
