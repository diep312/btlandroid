import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/entities/user_profile.dart';
import 'package:chit_chat/src/app/widgets/k_button.dart';
import 'package:chit_chat/src/domain/usecases/get_user_profile.dart';
import 'package:chit_chat/src/app/pages/profile/profile_controller.dart';
import 'package:chit_chat/src/data/repositories/data_user_repository.dart';

class ProfileView extends View {
  final String userId;
  final String currentUserId;
  const ProfileView(
      {required this.userId, required this.currentUserId, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileViewState(
        ProfileController(
          userId: userId,
          currentUserId: currentUserId,
          userRepository: DataUserRepository(),
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
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: ControlledWidgetBuilder<ProfileController>(
          builder: (context, controller) {
            final user = controller.user;
            final profile = controller.userProfile;
            final isCurrentUser = controller.isCurrentUser;

            if (profile == null) {
              return Center(child: CircularProgressIndicator());
            }

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
                                  Text('${profile.followersCount}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  const Text('Followers'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('${profile.likesCount}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  const Text('Likes'),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // User's name
                          Text(
                            user?.displayName ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          // Username
                          Text(
                            '@${user?.id ?? ''}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          // Description
                          Text(profile.description ?? '',
                              textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!isCurrentUser)
                                KButton(
                                  mainText: 'Follow',
                                  onPressed: controller.onFollowPressed,
                                  bgColor: const Color(0xFF6EC6FF),
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                ),
                              if (!isCurrentUser) const SizedBox(width: 12),
                              if (!isCurrentUser)
                                KButton(
                                  mainText: 'Nhắn tin',
                                  onPressed: controller.onMessagePressed,
                                  bgColor: Colors.white,
                                  borderColor: const Color(0xFF6EC6FF),
                                  textStyle:
                                      const TextStyle(color: Color(0xFF6EC6FF)),
                                ),
                              if (isCurrentUser)
                                KButton(
                                  mainText: 'Edit Profile',
                                  onPressed: controller.onEditProfilePressed,
                                  bgColor: const Color(0xFF6EC6FF),
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // TODO: Add post grid here in the future
                          // Example placeholder:
                          // Container(height: 200, color: Colors.grey[200]),
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
                            ? NetworkImage(profile.avatarUrl!)
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
