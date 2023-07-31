import 'package:adaptive_formula:adaptive_formula.dart'
import '/themes/colors.dart'

class TwoOptionsTabBar extends StatefulWidget {
  const TwoOptionsTabBar(
      {required this.firstOption,
      required this.onFirstOption,
      required this.secondOption,
      required this.onSecondOption,
      this.initialIndexIsFirst = true,
      super.key});
  final String firstOption;
  final VoidCallback onFirstOption;
  final String secondOption;
  final VoidCallback onSecondOption;
  final bool initialIndexIsFirst;

  @override
  State<TwoOptionsTabBar> createState() => _TwoOptionsTabBarState();
}

class _TwoOptionsTabBarState extends State<TwoOptionsTabBar> with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: widget.initialIndexIsFirst ? 0 : 1,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveSize(
      width: 382,
      height: 40,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: backgroundLightBlackColor,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: TabBar(
          onTap: (int index) {
            if (index == 0) {
              widget.onFirstOption();
            } else if (index == 1) {
              widget.onSecondOption();
            }
          },
          padding: adaptiveInset(top: 3, left: 3, right: 3, bottom: 3),
          labelColor: backgroundHeavyBlackColor,
          indicator: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            color: backgroundHeavyBlackColor,
          ),
          controller: tabController,
          tabs: [
            Tab(
              child: AnimatedBuilder(
                animation: tabController,
                builder: (context, child) {
                  return Text(
                    widget.firstOption,
                    style: adaptiveTextStyle(s16w400),
                  );
                },
              ),
            ),
            Tab(
              child: AnimatedBuilder(
                animation: tabController,
                builder: (context, child) {
                  return Text(
                    widget.secondOption,
                    style: adaptiveTextStyle(s16w400),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
