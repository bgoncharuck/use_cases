import 'package:flutter/widgets.dart';
import 'screen_controller.dart';

abstract class ScreenLocator<T extends ScreenController>
    extends InheritedWidget {
  const ScreenLocator({
    required this.controller,
    required super.child,
    super.key,
  });

  final T controller;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

/// example
// class TestController extends ScreenController {}

// class TestLocator extends ScreenLocator<TestController> {
//   const TestLocator({
//     required super.controller,
//     required super.child,
//     super.key,
//   });

//   static TestController of(BuildContext context) {
//     final widget = context.dependOnInheritedWidgetOfExactType<TestLocator>();
//     if (widget == null) {
//       throw FlutterError('TestLocator not found in context.');
//     }
//     return widget.controller;
//   }
// }
