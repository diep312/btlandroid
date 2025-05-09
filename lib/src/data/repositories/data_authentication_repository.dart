import 'dart:async';
import 'dart:io' show PlatformException;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chit_chat/src/data/exceptions/invalid_phone_number_exception.dart';
import 'package:chit_chat/src/data/exceptions/invalid_verification_code_expcetion.dart';
import 'package:chit_chat/src/data/exceptions/too_many_requests_exception.dart';
import 'package:chit_chat/src/domain/repositories/authentication_repository.dart';
import 'package:chit_chat/src/domain/types/enum_start_phone_verification.dart';
import 'package:chit_chat/src/domain/types/enum_user_auth_status.dart';
import 'package:chit_chat/src/domain/types/response_authentication.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DataAuthenticationRepository implements AuthenticationRepository {
  static DataAuthenticationRepository? _instance;
  DataAuthenticationRepository._();
  factory DataAuthenticationRepository() {
    _instance ??= DataAuthenticationRepository._();

    return _instance!;
  }

  final StreamController<StartPhoneVerificationEnum?> _streamController =
      StreamController.broadcast();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String? _verificationId;
  int? _resendToken;

  @override
  void killInstance() {
    _instance = null;
  }

  @override
  Future<UserAuthenticationStatus> get userAuthenticationStatus async {
    try {
      if (_firebaseAuth.currentUser == null) {
        return UserAuthenticationStatus.NOT_AUTHENTICATED;
      }

      DocumentSnapshot<Map<String, dynamic>> _snapshot = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();

      if (!_snapshot.exists ||
          _snapshot.data() == null ||
          ((_snapshot.data()!['firstName'] == null ||
                  _snapshot.data()!['firstName'].length == 0) ||
              (_snapshot.data()!['lastName'] == null ||
                  _snapshot.data()!['lastName'].length == 0))) {
        return UserAuthenticationStatus.MISSING_USERNAME;
      }

      return UserAuthenticationStatus.AUTHENTICATED;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Stream<StartPhoneVerificationEnum?> startPhoneVerification({
    required String phoneNumber,
    required bool resendToken,
    required bool forInit,
  }) {
    if (!forInit) {
      Future.delayed(Duration.zero).then((value) {
        _startPhoneVerification(
          phoneNumber: phoneNumber,
          resend: resendToken,
        );
      });
    }
    return _streamController.stream;
  }

  Future<void> _startPhoneVerification({
    required String phoneNumber,
    required bool resend,
  }) async {
    try {
      if (!resend) {
        _verificationId = null;
        _resendToken = null;
      }

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 120),
        codeAutoRetrievalTimeout: (String verificationId) {
          _streamController.add(StartPhoneVerificationEnum.TIMED_OUT);
          print('timed out');
        },
        verificationCompleted: (PhoneAuthCredential credential) async {
          // await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            _streamController.addError(InvalidPhoneNumberException());
            throw InvalidPhoneNumberException();
          } else {
            print(e.message);
            print(e.code);
            _streamController.addError(e);
            throw Exception();
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          _verificationId = verificationId;
          _resendToken = resendToken;
          _streamController.add(StartPhoneVerificationEnum.CODE_SENT);
        },
        forceResendingToken: resend ? _resendToken : null,
      );
    } on FirebaseAuthException catch (e, st) {
      if (e.code == 'too-many-requests') {
        _streamController.addError(TooManyRequestsException(), st);
        throw TooManyRequestsException();
      } else {
        _streamController.addError(e, st);
        rethrow;
      }
    } catch (e, st) {
      _streamController.addError(e, st);
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<AuthenticationResponse?> verifyPhoneCode({
    required String smsCode,
    required String phoneNumber,
  }) async {
    try {
      print(phoneNumber);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: smsCode);

      await _firebaseAuth.signInWithCredential(credential);
      print('Signed in with credential. Authenticated uid: ' +
          _firebaseAuth.currentUser!.uid);
      return AuthenticationResponse(
        isSignUp: true,
        phoneNumber: phoneNumber,
      );
    } on FirebaseAuthException catch (error, st) {
      print(error.message);
      print(error.code);
      print(st);
      if (error.code == 'invalid-verification-code') {
        throw InvalidVerificationCodeException();
      } else {
        rethrow;
      }
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<AuthenticationResponse?> authenticateWithGoogle() async {
    try {
      // Initialize GoogleSignIn with specific scopes
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // Attempt to sign in
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('Google Sign In was canceled by user');
        return null;
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('Failed to get Google Auth tokens');
        throw Exception('Failed to get Google Auth tokens');
      }

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        print('Failed to get Firebase user after Google Sign In');
        throw Exception('Failed to get Firebase user after Google Sign In');
      }

      return AuthenticationResponse(
        email: googleUser.email,
        isSignUp: true,
      );
    } on FirebaseAuthException catch (error, st) {
      print('Firebase Auth Error: ${error.code} - ${error.message}');
      print('Stack trace: $st');
      rethrow;
    } on PlatformException catch (error, st) {
      print('Platform Error: ${error.code} - ${error.message}');
      print('Stack trace: $st');
      rethrow;
    } catch (error, st) {
      print('Unexpected Error: $error');
      print('Stack trace: $st');
      rethrow;
    }
  }
}
