import 'package:flutter/widgets.dart';
import 'screen_controller.dart';
import 'screen_locator.dart';

class ScreenModule<
  P extends ScreenControllerParams,
  C extends ScreenController<P>,
  L extends ScreenLocator<C>
> {
  const ScreenModule({
    required this.createController,
    required this.createLocator,
    required this.screen,
  });

  final C Function({required P params}) createController;
  final L Function({required C controller, required Widget child, Key? key})
  createLocator;
  final Widget screen;
}
