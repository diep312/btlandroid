import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/entities/user_profile.dart';
import 'package:chit_chat/src/app/widgets/k_button.dart';
import 'package:chit_chat/src/app/pages/profile/profile_controller.dart';
import 'package:chit_chat/src/data/repositories/data_user_repository.dart';
import 'package:chit_chat/src/data/repositories/data_post_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/src/app/constants/texts.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/navigator/navigator.dart';
import 'package:chit_chat/src/app/widgets/k_app_bar.dart';
import 'package:chit_chat/src/data/repositories/data_post_repository.dart';
import 'package:chit_chat/src/domain/entities/user.dart';

class ProfileView extends View {
  final String userId;
  final String currentUserId;

  const ProfileView({
    required this.userId,
    required this.currentUserId,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileViewState(
        ProfileController(
          userId: userId,
          currentUserId: currentUserId,
          userRepository: DataUserRepository(),
          postRepository: DataPostRepository(),
        ),
      );
}

class _ProfileViewState extends ViewState<ProfileView, ProfileController> {
  _ProfileViewState(ProfileController controller) : super(controller);

  @override
  Widget get view {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: globalKey,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: ControlledWidgetBuilder<ProfileController>(
          builder: (context, controller) {
            print('Building profile view');
            print('Is loading: ${controller.isLoading}');
            print('User: ${controller.user?.toJson()}');
            print('Profile: ${controller.userProfile?.toJson()}');
            print('Posts: ${controller.userPosts?.length}');
            print('Error: ${controller.error}');

            if (controller.isLoading) {
              return _buildLoadingState();
            }

            if (controller.error != null) {
              return Center(
                child: Text(
                  'Error: ${controller.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (controller.userProfile == null || controller.user == null) {
              return const Center(
                child: Text('No profile data available'),
              );
            }

            final user = controller.user!;
            final profile = controller.userProfile!;
            final isCurrentUser = controller.isCurrentUser;

            return Stack(
              children: [
                // Gradient background (fixed)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFC466B),
                        Color(0xFF9F52B3),
                        Color(0xFF3F5EFB),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                // White container with scrollable content
                Positioned.fill(
                  top: 200,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 60, bottom: 24),
                      child: Column(
                        children: [
                          // Stats row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${profile.followersCount}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(DefaultTexts.followers),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${profile.likesCount}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(DefaultTexts.likes),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // User's name
                          Text(
                            user.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          // Username
                          Text(
                            user.email!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Description
                          if (profile.description != null &&
                              profile.description!.isNotEmpty)
                            Text(
                              profile.description!,
                              textAlign: TextAlign.center,
                            )
                          else
                            Text(
                              DefaultTexts.noDescription,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          const SizedBox(height: 16),
                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!isCurrentUser)
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: KButton(
                                    mainText: DefaultTexts.message,
                                    onPressed: controller.onMessagePressed,
                                    bgColor: Colors.white,
                                    borderColor: const Color(0xFF6EC6FF),
                                    textStyle: const TextStyle(
                                        color: Color(0xFF6EC6FF)),
                                  ),
                                ),
                              if (isCurrentUser) ...[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: KButton(
                                    mainText: DefaultTexts.editProfile,
                                    onPressed: () => controller
                                        .onEditProfilePressed(context),
                                    bgColor: const Color(0xFF6EC6FF),
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 16),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: KButton(
                                    mainText: DefaultTexts.logout,
                                    onPressed: controller.onLogoutPressed,
                                    bgColor: Colors.redAccent,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 24),
                          if (controller.userPosts != null)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                              ),
                              itemCount: controller.userPosts!.length,
                              itemBuilder: (context, index) {
                                final post = controller.userPosts![index];
                                return GestureDetector(
                                  onTap: () {
                                    // TODO: Navigate to post detail
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(post.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Profile avatar (overlapping, fixed)
                Positioned(
                  top: 150,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: profile.avatarUrl != null &&
                                profile.avatarUrl!.isNotEmpty
                            ? CachedNetworkImageProvider(
                                profile.avatarUrl!,
                                errorListener: () =>
                                    print('Error loading image'),
                              )
                            : const AssetImage(
                                    'assets/icons/png/default_user.png')
                                as ImageProvider,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Stack(
      children: [
        // Gradient background (fixed)
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB16CEA), Color(0xFFFC466B)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        // White container with shimmer content
        Positioned.fill(
          top: 200,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 60, bottom: 24),
              child: Column(
                children: [
                  // Stats row shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShimmerColumn(),
                      _buildShimmerColumn(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Name shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 150,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Username shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 100,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Button shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Profile avatar shimmer
        Positioned(
          top: 150,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerColumn() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 40,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 60,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Reset to your app's default system UI style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    super.dispose();
  }
}
