import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/constants/texts.dart';
import 'package:chit_chat/src/app/pages/username/username_controller.dart';
import 'package:chit_chat/src/app/widgets/k_button.dart';
import 'package:chit_chat/src/app/widgets/k_textformfield.dart';
import 'package:chit_chat/src/data/helpers/validator_helper.dart';
import 'package:chit_chat/src/data/repositories/data_user_repository.dart';
import 'package:lottie/lottie.dart';

class UsernameView extends View {
  UsernameView({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _UsernameViewState(
        UsernameController(
          DataUserRepository(),
        ),
      );
}

class _UsernameViewState extends ViewState<UsernameView, UsernameController> {
  _UsernameViewState(UsernameController controller) : super(controller);

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      body: ControlledWidgetBuilder<UsernameController>(
          builder: (context, controller) {
        Size size = MediaQuery.of(context).size;
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
          child: Column(
            children: [
              const SizedBox(height: 60),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        DefaultTexts.typePersonalInfos,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Form(
                        key: controller.formkey,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: KTextFormField(
                                onChanged: controller.onfirstNameChanged,
                                mainText: DefaultTexts.yourFirstName,
                                mainTextColor: Colors.black,
                                contentTextColor: Colors.black,
                                hintText: DefaultTexts.typeYourFirstName,
                                maxLength: 30,
                                keyboardType: TextInputType.text,
                                validator: ValidatorHelper.kNameValidator,
                                nullAutoValidateMode:
                                    controller.autovalidateMode == null
                                        ? true
                                        : false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                isSecurityCode: false,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 0),
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              child: KTextFormField(
                                isSecurityCode: false,
                                onChanged: controller.onLastNameChanged,
                                mainText: DefaultTexts.yourLastName,
                                mainTextColor: Colors.black,
                                contentTextColor: Colors.black,
                                hintText: DefaultTexts.typeYourLastName,
                                maxLength: 30,
                                keyboardType: TextInputType.name,
                                nullAutoValidateMode:
                                    controller.autovalidateMode == null
                                        ? true
                                        : false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: ValidatorHelper.kNameValidator,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 0),
                              ),
                            ),
                            const SizedBox(height: 36),
                            ControlledWidgetBuilder<UsernameController>(
                                builder: (context, controller) {
                              return KButton(
                                mainText: DefaultTexts.signUp,
                                onPressed: controller.isButtonDisabled
                                    ? () {}
                                    : controller.onButtonPressed,
                                bgColor: controller.isButtonDisabled
                                    ? kDisabled
                                    : kPrimary,
                                borderRadiusTopLeft: 32,
                                borderRadiusTopRight: 32,
                                borderRadiusBottomLeft: 32,
                                borderRadiusBottomRight: 32,
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
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
