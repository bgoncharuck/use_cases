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
      path = DirectoryLocator(
        controller: DirectoryController(),
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

  return TransitionBuilder(
    route: path,
  );
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}

// ignore: strict_raw_type
class TransitionBuilder extends PageRouteBuilder {
  final Widget route;
  final Duration duration;
  final Duration reverseDuration;
  final Curve curve;

  TransitionBuilder({
    required this.route,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  }) : super(
          pageBuilder: (context, animate, _) => route,
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          transitionsBuilder: (context, animation, anim, child) {
            final animated = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve)).animate(animation);
            return FadeTransition(opacity: animated, child: child);
          },
        );
}
