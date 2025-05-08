import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/pages/add_post/add_post_controller.dart';
import 'package:chit_chat/src/app/widgets/k_app_bar.dart';
import 'package:chit_chat/src/app/widgets/k_button.dart';
import 'package:chit_chat/src/app/widgets/k_textformfield.dart';
import 'package:chit_chat/src/data/helpers/validator_helper.dart';
import 'package:chit_chat/src/data/repositories/data_post_repository.dart';
import 'package:chit_chat/src/data/repositories/data_user_repository.dart';
import 'package:chit_chat/src/app/constants/texts.dart';
import 'package:chit_chat/src/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AddPostView extends View {
  @override
  State<StatefulWidget> createState() => _AddPostViewState(
        AddPostController(
          DataPostRepository(),
          DataUserRepository(),
        ),
      );
}

class _AddPostViewState extends ViewState<AddPostView, AddPostController> {
  _AddPostViewState(super.controller);

  final FocusNode _descFocusNode = FocusNode();
  bool _isDescFocused = false;

  @override
  void initState() {
    super.initState();
    _descFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isDescFocused = _descFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _descFocusNode.removeListener(_onFocusChange);
    _descFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      key: globalKey,
      backgroundColor: kBackground,
      body: ControlledWidgetBuilder<AddPostController>(
        builder: (context, controller) {
          return Stack(
            children: [
              Column(
                children: [
                  // Custom AppBar with user info and 'Đăng' button
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 16, top: 24, bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Avatar and user info
                          CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage('assets/icons/png/current_user.png'),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  controller.currentUser?.displayName ??
                                      'Đang tải...',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(
                                  '@${controller.currentUser?.displayName ?? 'username'}',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: controller.onAddButtonPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6EC6FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 8),
                            ),
                            child: Text(DefaultTexts.post,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // White card for post input
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Expanded(
                              child: TextFormField(
                                focusNode: _descFocusNode,
                                onChanged: controller.onDescriptionTyped,
                                maxLength: 250,
                                keyboardType: TextInputType.text,
                                minLines: 8,
                                maxLines: 16,
                                style: TextStyle(fontSize: 18, color: kBlack),
                                decoration: InputDecoration(
                                  hintText: DefaultTexts.writeYourThoughts,
                                  hintStyle: TextStyle(
                                    color: kBlack.withOpacity(0.3),
                                    fontSize: 18,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Image preview and bottom buttons
              if (!isKeyboardOpen)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                        bottom: 16, left: 18, right: 18, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (controller.image != null)
                          Container(
                            margin: EdgeInsets.only(bottom: 12),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(File(controller.image!.path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        // Align text and buttons to the left
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              KButton(
                                mainText: DefaultTexts.pickFromGallery,
                                onPressed: () {
                                  controller.pickImage(true, size.width - 34);
                                },
                                height: 48,
                                bgColor: Colors.white,
                                borderColor: Colors.transparent,
                                textStyle: k14w600ProxWhiteButtonText(
                                    color: kSecondary),
                                width: double.infinity,
                              ),
                              Divider(height: 1, color: Colors.grey.shade200),
                              KButton(
                                mainText: DefaultTexts.pickFromCamera,
                                onPressed: () {
                                  controller.pickImage(false, size.width - 34);
                                },
                                height: 48,
                                bgColor: Colors.white,
                                borderColor: Colors.transparent,
                                textStyle: k14w600ProxWhiteButtonText(
                                    color: kSecondary),
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
