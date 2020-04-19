import 'dart:async';

import 'package:clone_whats_app/utils/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

User cUser;

String _verificationId;

void sendCode({
  String phoneNumber,
  Function onCodeSent,
  Function codeTimeOut,
  Function onDone,
  Function(String) onFailed,
}) {
  FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: "+$phoneNumber",
    timeout: Duration(minutes: 2),
    verificationCompleted: (AuthCredential a) {
      FirebaseAuth.instance.signInWithCredential(a).then((result) async {
        cUser = await User.getUserData(result.user.uid);
        if (cUser.id == null) {
          // first time
          cUser = User(
            id: result.user.uid,
            phone: result.user.phoneNumber,
          );
          cUser.updateUserData();
        }
        onDone();
        onDone();
      });
    },
    verificationFailed: (AuthException err) => onFailed(err.message),
    codeSent: (String code, [i]) {
      _verificationId = code;
      onCodeSent();
    },
    codeAutoRetrievalTimeout: (s) {
      codeTimeOut();
    },
  );
}

void signInWithPhoneAndCode({
  String phone,
  String code,
  Function onDone,
  Function(String) onError,
}) {
  final credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId, smsCode: code);
  FirebaseAuth.instance.signInWithCredential(credential).then(
    (result) async {
      cUser = await User.getUserData(result.user.uid);
      if (cUser.id == null) {
        // first time
        cUser = User(
          id: result.user.uid,
          phone: result.user.phoneNumber,
        );
        cUser.updateUserData();
      }
      onDone();
    },
  ).catchError((err) {
    onError("wrong code");
  });
}

void onSignIn(Function f) async {
  StreamSubscription s;
  s = FirebaseAuth.instance.onAuthStateChanged.listen(
    (val) {
      if (val != null) {
        f();
        s.cancel();
      }
    },
  );
}

Future logOUt() {
  cUser = null;
  return FirebaseAuth.instance.signOut();
}
