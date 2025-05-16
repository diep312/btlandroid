import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/constants/texts.dart';
import 'package:chit_chat/src/app/pages/authentication/start/start_phone_authentication_controller.dart';
import 'package:chit_chat/src/app/widgets/k_app_bar.dart';
import 'package:chit_chat/src/app/widgets/k_button.dart';
import 'package:chit_chat/src/app/widgets/k_textformfield.dart';
import 'package:chit_chat/src/data/helpers/validator_helper.dart';
import 'package:chit_chat/src/data/repositories/data_authentication_repository.dart';
import 'package:lottie/lottie.dart';

class PhoneAuthenticationStartView extends View {
  PhoneAuthenticationStartView({Key? key}) : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _PhoneAuthenticationStartViewState(
        PhoneAuthenticationStartController(
          DataAuthenticationRepository(),
        ),
      );
}

class _PhoneAuthenticationStartViewState extends ViewState<
    PhoneAuthenticationStartView, PhoneAuthenticationStartController> {
  _PhoneAuthenticationStartViewState(
      PhoneAuthenticationStartController controller)
      : super(controller);

  @override
  Widget get view {
    bool isKeyboardClosed = MediaQuery.of(context).viewInsets.bottom == 0.0;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomInset: false,
      body: ControlledWidgetBuilder<PhoneAuthenticationStartController>(
        builder: (context, controller) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.centerLeft,
                colors: [
                  Color(0xFFFA5C9C), // pink
                  Color(0xFF8B5CF6), // purple
                  Color(0xFF1976D2), // blue
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: size.width * 0.9,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DefaultTexts.phoneAuthTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DefaultTexts.phoneNumberLabel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Colors.black26, width: 1),
                        ),
                        child: Form(
                          key: controller.formkey,
                          child: TextFormField(
                            onChanged: controller.setPhoneNumber,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            decoration: InputDecoration(
                              hintText: DefaultTexts.phoneNumberHint,
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                            ),
                            validator: (value) =>
                                ValidatorHelper.kPhoneValidator(value ?? ''),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.isButtonDisabled
                                ? kDisabled
                                : Color(0xFF1976D2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 18),
                            elevation: 2,
                          ),
                          onPressed: controller.isButtonDisabled
                              ? null
                              : controller.startPhoneVerification,
                          child: Text(
                            DefaultTexts.continuee,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
