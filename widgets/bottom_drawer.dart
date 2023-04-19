import 'package:flutter/material.dart';
import 'adaptive_formula.dart';
import 'void_widget.dart';

class BottomDrawerIndicator extends StatelessWidget {
  const BottomDrawerIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveSize(
        width: 336,
        height: 40,
        child: Position(
          alignment: Alignment.topCenter,
          padding: adaptiveInset(top: 12),
          child: const AdaptiveSizeDecorated(
            width: 63,
            height: 5,
            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(100))),
            child: voidWidget,
          ),
        ));
  }
}

const _defaultHeight = 424.0;
const _defaultOffset = 0.475;
const _heightMultiplier = 2.0;
double _animationEndOffset(double height) =>
    _defaultOffset / (height / _defaultHeight * _defaultOffset * _heightMultiplier);

class BottomDrawerWrapper extends StatefulWidget {
  const BottomDrawerWrapper({
    super.key,
    required this.children,
    required this.onDragDown,
    this.onDragStart,
    this.height = _defaultHeight,
    this.animationTime = 600,
    this.backgroundColor = Colors.black,
  });
  final List<Widget> children;
  final Function() onDragDown;
  final Function()? onDragStart;
  final double height;
  final int animationTime;
  final Color backgroundColor;

  @override
  State<BottomDrawerWrapper> createState() => BottomDrawerWrapperState();
}

class BottomDrawerWrapperState extends State<BottomDrawerWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: widget.animationTime),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, 1.0),
    end: Offset(0.0, _animationEndOffset(widget.height)),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutExpo,
  ));

  @override
  void initState() {
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.down,
        onUpdate: (details) {
          if (widget.onDragStart != null) {
            widget.onDragStart!();
          }
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.down) {
            widget.onDragDown();
          }
        },
        child: AdaptiveHeightDecorated(
            height: widget.height * _heightMultiplier,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  const Position(child: BottomDrawerIndicator()),
                  ...widget.children,
                ],
              ),
            )),
      ),
    );
  }
}
