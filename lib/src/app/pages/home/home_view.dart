import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/navigator/navigator.dart';
import 'package:chit_chat/src/app/pages/home/home_controller.dart';
import 'package:chit_chat/src/app/pages/stories/stories_view.dart';

import 'package:chit_chat/src/app/widgets/k_app_bar.dart';
import 'package:chit_chat/src/app/widgets/k_post.dart';
import 'package:chit_chat/src/data/repositories/data_post_repository.dart';
import 'package:chit_chat/src/data/repositories/data_user_repository.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:chit_chat/src/app/constants/texts.dart';

class HomeViewHolder extends StatefulWidget {
  const HomeViewHolder({Key? key}) : super(key: key);

  @override
  State<HomeViewHolder> createState() => _HomeViewHolderState();
}

class _HomeViewHolderState extends State<HomeViewHolder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _HomeView();
  }

  @override
  bool get wantKeepAlive => true;
}

// ignore: use_key_in_widget_constructors
class _HomeView extends View {
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _HomeViewState(
        HomeController(
          DataPostRepository(),
          DataUserRepository(),
        ),
      );
}

class _HomeViewState extends ViewState<_HomeView, HomeController> {
  _HomeViewState(super.controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: globalKey,
      body: ControlledWidgetBuilder<HomeController>(
          builder: (context, controller) {
        return Container(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  controller.scrollController.animateTo(
                    0,
                    duration: KNavigator.DURATION,
                    curve: KNavigator.CURVE,
                  );
                },
                child: KAppBar(
                  header: DefaultTexts.explore,
                  showNotification: true,
                  onNotificationPressed: () {/* ... */},
                ),
              ),
              Expanded(
                child: LiquidPullToRefresh(
                  showChildOpacityTransition: false,
                  backgroundColor: kWhite,
                  color: Color(0xFF6EC6FF),
                  onRefresh: () async {
                    controller.refreshStreamController.add(true);
                    controller.getPosts();
                  },
                  child: ListView(
                    controller: controller.scrollController,
                    addRepaintBoundaries: false,
                    shrinkWrap: true,
                    physics: kPhysics,
                    addAutomaticKeepAlives: true,
                    children: [
                      Container(
                        width: size.width,
                        height: 120,
                        child: StoriesViewHolder(
                          refresh: controller.refreshStreamController.stream,
                        ),
                      ),
                      SizedBox(height: 10),
                      !controller.postsInitialized
                          ? Column(
                              children: [
                                ShimmeredPost(),
                                ShimmeredPost(),
                              ],
                            )
                          : Column(
                              children: [
                                for (int i = 0;
                                    i < controller.posts.length;
                                    i++)
                                  Column(
                                    children: [
                                      KPost(
                                        index: i,
                                        post: controller.posts[i],
                                        changePostLike:
                                            controller.changePostLike,
                                        navigateToComments: (a, b) {
                                          KNavigator.navigateToComments(
                                            context,
                                            controller.posts[i].id,
                                          );
                                        },
                                        onAvatarTap: controller.onAvatarTap,
                                        toggleFavoriteState:
                                            controller.togglePostFavoriteState,
                                        onEdit: controller.editPost,
                                        onDelete: controller.deletePost,
                                        showAnimation:
                                            controller.lastLikedPost ==
                                                controller.posts[i].id,
                                      ),
                                      if (!controller.isAllPostsFetched &&
                                          i == controller.posts.length - 1)
                                        VisibilityDetector(
                                            key: ValueKey('1'),
                                            onVisibilityChanged: (a) {
                                              if (a.visibleFraction > 0.7) {
                                                controller.getNextPosts();
                                              }
                                            },
                                            child: kCircularProgressIndicator(
                                                color: kPrimary))
                                    ],
                                  ),
                                SizedBox(height: 135),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
