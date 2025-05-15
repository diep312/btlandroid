import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/navigator/navigator.dart';
import 'package:chit_chat/src/app/pages/authentication/decider/auth_decider_controller.dart';
import 'package:chit_chat/src/app/widgets/k_button.dart';
import 'package:chit_chat/src/data/repositories/data_authentication_repository.dart';
import 'package:chit_chat/src/data/repositories/data_user_repository.dart';
import 'package:lottie/lottie.dart';
import 'package:chit_chat/src/app/constants/texts.dart';

class AuthDeciderView extends View {
  @override
  State<StatefulWidget> createState() => _AuthDeciderViewState(
        AuthDeciderController(
          DataAuthenticationRepository(),
          DataUserRepository(),
        ),
      );
}

class _AuthDeciderViewState
    extends ViewState<AuthDeciderView, AuthDeciderController> {
  _AuthDeciderViewState(super.controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: globalKey,
      body: ControlledWidgetBuilder<AuthDeciderController>(
        builder: (context, controller) {
          return Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFC466B), // Pinkish
                  Color(0xFF3F5EFB), // Bluish
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Logo Card

                  // Spacer for 1/3 of the screen
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/images/png/logo_transparent.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Bottom section: 2/3 of the screen
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 24,
                            offset: Offset(0, -8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DefaultTexts.welcomeTitle,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: -2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 56),
                          Text(
                            DefaultTexts.welcomeInstruction,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          KButton(
                            mainText: DefaultTexts.loginWithGoogle,
                            iconPath: 'assets/icons/png/google.png',
                            bgColor: const Color(0xFF648FD9),
                            borderColor: Colors.transparent,
                            onPressed: controller.authenticateWithGoogle,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            borderRadiusTopLeft: 100,
                            borderRadiusTopRight: 100,
                            borderRadiusBottomLeft: 100,
                            borderRadiusBottomRight: 100,
                          ),
                          const SizedBox(height: 16),
                          KButton(
                            mainText: DefaultTexts.loginWithPhone,
                            iconPath: 'assets/icons/png/phone.png',
                            bgColor: const Color(0xFF648FD9),
                            borderColor: Colors.transparent,
                            onPressed: () {
                              KNavigator.navigateToPhoneAuthenticationStart(
                                context: context,
                              );
                            },
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            borderRadiusTopLeft: 100,
                            borderRadiusTopRight: 100,
                            borderRadiusBottomLeft: 100,
                            borderRadiusBottomRight: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
