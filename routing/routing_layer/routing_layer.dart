import 'package:flutter/widgets.dart';
import 'paths.dart';
import 'screen_controller.dart';
import 'screen_locator.dart';
import 'screen_module.dart';

class RoutingLayer<
  InitializationConfig extends ScreenModule<
    InitializationParams,
    InitializationController,
    InitializationLocator
  >,
  InitializationParams extends ScreenControllerParams,
  InitializationController extends ScreenController<InitializationParams>,
  InitializationLocator extends ScreenLocator<InitializationController>,

  HomeConfig extends ScreenModule<HomeParams, HomeController, HomeLocator>,
  HomeParams extends ScreenControllerParams,
  HomeController extends ScreenController<HomeParams>,
  HomeLocator extends ScreenLocator<HomeController>
> {
  const RoutingLayer({required this.initialization, required this.home});

  final InitializationConfig initialization;
  final HomeConfig home;

  Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    Widget path;

    switch (settings.name) {
      case pathInitialization:
      case '/':
        path = initialization.createLocator(
          controller: initialization.createController(
            params: arguments! as InitializationParams,
          ),
          child: initialization.screen,
        );

      case pathHome:
        path = home.createLocator(
          controller: home.createController(params: arguments! as HomeParams),
          child: home.screen,
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
}

class RouteException implements Exception {
  const RouteException(this.message);
  final String message;
}
