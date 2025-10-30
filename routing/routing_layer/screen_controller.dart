abstract class ScreenControllerParams {}

class ScreenController<T extends ScreenControllerParams> {
  ScreenController(this.params);
  final T params;
}
