import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dialog_gallery_photo_grid_controller.dart';

const _dialogNavigationButtonCount = 2.0;

class SelectPhotoHome extends StatefulWidget {
  const SelectPhotoHome({required this.onPhotoSelected, super.key});
  final Future Function(String? filePath) onPhotoSelected;

  @override
  State<SelectPhotoHome> createState() => _SelectPhotoHomeState();
}

class _SelectPhotoHomeState extends State<SelectPhotoHome> {
  @override
  void initState() {
    Get.put<DialogGalleryGridController>(DialogGalleryGridController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<DialogGalleryGridController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => OnPhotoSelected(
        action: widget.onPhotoSelected,
        child: DialogWrapper(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: SizedBox(
              width: adaptiveWidth(dialogNavigationButtonWidth),
              height: dialogNavigationButtonHeight * _dialogNavigationButtonCount +
                  dialogNavigationButtonSpacing * (_dialogNavigationButtonCount - 1),
              child: Stack(
                children: const [
                  Align(alignment: Alignment.topCenter, child: SelectFromGalleryButton()),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: EdgeInsets.only(top: dialogNavigationButtonHeight + dialogNavigationButtonSpacing),
                          child: CancelButton())),
                ],
              ),
            ),
          ),
        ),
      );
}

class DialogWrapper extends StatelessWidget {
  const DialogWrapper({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: child,
      ),
    );
  }
}

class OnPhotoSelected extends InheritedWidget {
  const OnPhotoSelected({
    super.key,
    required this.action,
    required super.child,
  });

  final Future Function(String? filePath) action;

  static OnPhotoSelected? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<OnPhotoSelected>();
  }

  static OnPhotoSelected of(BuildContext context) {
    final OnPhotoSelected? result = maybeOf(context);
    assert(result != null, 'No OnPhotoSelected found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(OnPhotoSelected oldWidget) => action != oldWidget.action;
}
