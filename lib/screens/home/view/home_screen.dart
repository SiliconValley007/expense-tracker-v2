import '../../../core/core.dart';
import '../../screens.dart';
import '../../../widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const HomeScreen());

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _xOffset;
  late final Animation<double> _yOffset;
  late final Animation<double> _sizeFactor;
  late final Animation<double> _borderRadius;

  late final ValueNotifier<DrawerItem> _currentSelectedNavItem;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _xOffset = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    _yOffset = Tween<double>(begin: 0.0, end: 0.2).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    _sizeFactor = Tween<double>(begin: 1.0, end: 0.6).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    _borderRadius = Tween<double>(begin: 0.0, end: 20.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    _currentSelectedNavItem =
        ValueNotifier<DrawerItem>(DrawerItems.expenseList);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _currentSelectedNavItem.dispose();
    super.dispose();
  }

  void openDrawer() => _animationController.forward();

  void closeDrawer() => _animationController.reverse();

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple, Colors.orange],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            DrawerScreen(
              onSelectedItem: (item) {
                _currentSelectedNavItem.value = item;
                closeDrawer();
              },
              onPressedClose: () => closeDrawer(),
            ),
            WillPopScope(
              onWillPop: () async {
                if (_animationController.status == AnimationStatus.completed) {
                  closeDrawer();
                  return false;
                }
                return true;
              },
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return GestureDetector(
                    onTap: () {
                      if (_animationController.status ==
                          AnimationStatus.completed) {
                        closeDrawer();
                      }
                    },
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx > 1) {
                        if (_animationController.status ==
                            AnimationStatus.dismissed) {
                          openDrawer();
                        }
                      } else if (details.delta.dx < -1) {
                        if (_animationController.status ==
                            AnimationStatus.completed) {
                          closeDrawer();
                        }
                      }
                    },
                    child: Transform(
                      transform: Matrix4.translationValues(
                          (_size.width * _xOffset.value),
                          (_size.height * _yOffset.value),
                          0)
                        ..scale(_sizeFactor.value),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(_borderRadius.value),
                        child: AbsorbPointer(
                          absorbing: _animationController.status ==
                              AnimationStatus.completed,
                          child: ValueListenableBuilder<DrawerItem>(
                            valueListenable: _currentSelectedNavItem,
                            builder: (context, value, child) => _GetDrawerPage(
                              drawerItem: value,
                              onPressed: () {
                                if (_animationController.status ==
                                    AnimationStatus.dismissed) {
                                  openDrawer();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        /*floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(
            context,
            edit,
            arguments: _tabController.index == 0
                ? EditScreenArguments()
                : EditScreenArguments(isExpense: false),
          ),
          child: const Icon(Icons.add),
        ),*/
      ),
    );
  }
}

class _GetDrawerPage extends StatelessWidget {
  const _GetDrawerPage({
    Key? key,
    required this.drawerItem,
    required this.onPressed,
  }) : super(key: key);

  final DrawerItem drawerItem;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    switch (drawerItem) {
      case DrawerItems.expenseList:
        return ExpenseListScreen(onPressed: onPressed);
      case DrawerItems.incomeList:
        return IncomeListScreen(onPressed: onPressed);
      case DrawerItems.settings:
        return SettingsScreen(onPressed: onPressed);
      case DrawerItems.categories:
        return CategoryListScreen(onPressed: onPressed,);
      default:
        return ExpenseListScreen(onPressed: onPressed);
    }
  }
}
