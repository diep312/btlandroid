import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/navigator/navigator.dart';
import 'package:chit_chat/src/app/pages/core/core_controller.dart';
import 'package:chit_chat/src/app/widgets/navigation_bar_item_button.dart';
import 'package:lottie/lottie.dart';
import 'package:chit_chat/src/app/widgets/k_draggable_bottom_sheet.dart';

class CoreViewHolder extends View {
  @override
  _CoreViewHolderState createState() =>
      _CoreViewHolderState(CoreViewHolderController());
}

class _CoreViewHolderState
    extends ViewState<CoreViewHolder, CoreViewHolderController> {
  _CoreViewHolderState(CoreViewHolderController controller) : super(controller);

  final coreKey = GlobalKey<NavigatorState>();

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        final response = await coreKey.currentState!.maybePop();
        if (!response) {
          try {
            await CoreController().handleOnWillPop();
          } catch (e) {}
        }
        return false;
      },
      child: Stack(
        key: globalKey,
        children: [
          Container(
            height: size.height,
            width: size.width,
            child: Navigator(
              key: coreKey,
              pages: [MaterialPage(child: _CoreView())],
              onPopPage: (route, result) => route.didPop(result),
            ),
          ),
          ControlledWidgetBuilder<CoreViewHolderController>(
            builder: (context, controller) => !controller.isLoading
                ? Container()
                : SizedBox(
                    height: size.height,
                    width: size.width,
                    child: Container(
                      height: size.height,
                      width: size.width,
                      padding: EdgeInsets.only(bottom: size.height * 0.05),
                      color: kBlack.withOpacity(0.6),
                      child: Center(
                        child: Lottie.asset(
                          'assets/animations/loading.json',
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class CoreViewHolderController extends Controller {
  static CoreViewHolderController? _instance;

  CoreViewHolderController._() {
    //Init
  }

  void killInstance() {
    _instance = null;
  }

  factory CoreViewHolderController() {
    // ignore: prefer_conditional_assignment
    if (_instance == null) {
      _instance = CoreViewHolderController._();
    }
    // since you are sure you will return non-null value, add '!' operator
    return _instance!;
  }

  /// This controller is singleton to ease navigations.
  /// Use wisely.
  BuildContext get coreViewHolderContext {
    return getContext();
  }

  bool isLoading = false;

  void changeLoadingStatus(bool value) {
    isLoading = value;
    refreshUI();
  }

  @override
  void initListeners() {
    // TODO: implement initListeners
  }
}

class _CoreView extends View {
  @override
  State<StatefulWidget> createState() {
    return _CoreViewState(
      CoreController(),
    );
  }
}

class _CoreViewState extends ViewState<_CoreView, CoreController> {
  _CoreViewState(CoreController controller) : super(controller);

  bool changedPageIndex = false;

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;
    return ControlledWidgetBuilder<CoreController>(
      builder: (context, controller) {
        if (!changedPageIndex) {
          changedPageIndex = true;
          Future.delayed(Duration.zero).then((_) {
            controller.onNavigationItemTap(controller.selectedIndex);
          });
        }
        return WillPopScope(
          onWillPop: () async {
            return controller.handleOnWillPop();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: globalKey,
            floatingActionButton:
                _AddPostButton(padding.bottom > 0 ? padding.bottom - 3 : 30),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      for (Widget page in controller.pages) page,
                    ],
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: KDraggableBottomSheet.isSheetOpen,
                  builder: (context, isSheetOpen, child) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: isSheetOpen ? 0 : 75 + padding.bottom,
                      child: isSheetOpen ? null : _NavigationBar(size, padding),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AddPostButton extends StatelessWidget {
  final double padding;

  _AddPostButton(this.padding);

  @override
  Widget build(BuildContext context) {
    return ControlledWidgetBuilder<CoreController>(
      builder: (context, controller) => Container(
        margin: EdgeInsets.only(bottom: padding),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFC466B),
              Color(0xFF9F52B3),
              Color(0xFF3F5EFB),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 12,
              color: Colors.black26,
            ),
          ],
        ),
        child: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: KNavigator.navigateToPostAdd,
          icon: Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  final EdgeInsets padding;
  final Size size;

  const _NavigationBar(
    this.size,
    this.padding,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75 + padding.bottom,
      width: size.width,
      padding: EdgeInsets.only(
        bottom: padding.bottom,
        left: 5,
        right: 5,
      ),
      decoration: BoxDecoration(
        color: kWhite,
        boxShadow: kBoxShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int index = 0; index < 5; index++)
            index == 2
                ? SizedBox(width: size.width / 5 - 10)
                : ControlledWidgetBuilder<CoreController>(
                    builder: (context, controller) => NavigationBarItemButton(
                      iconPath: controller.navigationItems[index]['iconPath'],
                      text: controller.navigationItems[index]['text'],
                      onPressed: controller.onNavigationItemTap,
                      index: index,
                      width: size.width / 5,
                      isSelected: controller.selectedIndex == index,
                    ),
                  ),
        ],
      ),
    );
  }
}
