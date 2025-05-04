import 'package:chit_chat/src/domain/types/enum_start_phone_verification.dart';
import 'package:chit_chat/src/domain/types/enum_user_auth_status.dart';
import 'package:chit_chat/src/domain/types/response_authentication.dart';

abstract class AuthenticationRepository {
  void killInstance();

  Future<UserAuthenticationStatus> get userAuthenticationStatus;

  Stream<StartPhoneVerificationEnum?> startPhoneVerification({
    required String phoneNumber,
    required bool resendToken,
    required bool forInit,
  });

  Future<AuthenticationResponse?> verifyPhoneCode({
    required String smsCode,
    required String phoneNumber,
  });

  Future<AuthenticationResponse?> authenticateWithGoogle();
}
