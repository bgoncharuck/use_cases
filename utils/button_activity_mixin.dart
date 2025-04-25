mixin ButtonActivityMixin<T extends StatefulWidget> on State<T> {
  bool buttonsAreInactive = false;

  void handleButtonClick(dynamic Function() action) {
    if (buttonsAreInactive) {
      return;
    }

    setState(() {
      buttonsAreInactive = true;
    });

    final result = action();

    if (result is Future<void>) {
      result.then((_) {
        if (mounted) {
          setState(() {
            buttonsAreInactive = false;
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          buttonsAreInactive = false;
        });
      }
    }
  }
}
