import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/navigator/navigator.dart';
import 'package:chit_chat/src/app/pages/stories/stories_controller.dart';
import 'package:chit_chat/src/app/widgets/story_container.dart';
import 'package:chit_chat/src/data/repositories/data_story_repository.dart';
import 'package:chit_chat/src/data/repositories/data_user_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:chit_chat/src/app/constants/texts.dart';

class StoriesViewHolder extends StatefulWidget {
  final Stream<bool?> refresh;
  const StoriesViewHolder({Key? key, required this.refresh}) : super(key: key);

  @override
  State<StoriesViewHolder> createState() => _StoriesViewHolderState();
}

class _StoriesViewHolderState extends State<StoriesViewHolder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoriesView(widget.refresh);
  }

  @override
  bool get wantKeepAlive => true;
}

class StoriesView extends View {
  final Stream<bool?> refresh;

  StoriesView(this.refresh);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _StoryViewState(
      StoriesController(
        DataStoryRepository(),
        DataUserRepository(),
        refresh,
      ),
    );
  }
}

class _StoryViewState extends ViewState<StoriesView, StoriesController> {
  _StoryViewState(StoriesController controller) : super(controller);

  @override
  Widget get view {
    return ControlledWidgetBuilder<StoriesController>(
      builder: (context, controller) {
        Size size = MediaQuery.of(context).size;
        return controller.stories == null
            ? Container(
                width: size.width,
                height: 120,
                padding: EdgeInsets.only(left: 18),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 6; i++) _ShimmeredStory(),
                    ],
                  ),
                ),
              )
            : Scaffold(
                key: globalKey,
                body: Container(
                  width: size.width,
                  height: 120,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    // controller: controller.storiesScrollController,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                behavior: hitTestBehavior,
                                onTap: () {
                                  KNavigator.navigateToAddStory();
                                },
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFFC466B),
                                        Color(0xFF9F52B3),
                                        Color(0xFF3F5EFB),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black
                                                      .withOpacity(0.55),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFFFC466B),
                                                    Color(0xFF9F52B3),
                                                    Color(0xFF3F5EFB),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                              ),
                                              padding: EdgeInsets.all(2),
                                              child: Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 28),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(DefaultTexts.addStory,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10)),
                            ],
                          ),
                          SizedBox(width: 18),
                          for (int i = 0; i < controller.stories!.length; i++)
                            StoryContainer(
                                controller.stories![i],
                                controller.stories!,
                                controller.isStoryLoading,
                                controller.changeLoadingStatus),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class _ShimmeredStory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        margin: EdgeInsets.only(right: 10),
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: kGrey,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: 30,
              height: 10,
              decoration: BoxDecoration(
                color: kGrey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
      gradient: kLinearGradient,
    );
  }
}
