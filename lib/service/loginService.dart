import 'package:chatting_app/screens/home.dart';
import 'package:chatting_app/screens/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _code = TextEditingController();
  String verificationCode;
  Future signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => Home()));
  }

  Future signInWithPhone(String phone, BuildContext context) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) async {
          var uid = (await _firebaseAuth.signInWithCredential(authCredential))
              .user
              .uid;

          if (uid.isNotEmpty) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignUp()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          }
          //     .then((value) => Navigator.pushReplacement(context,
          //         MaterialPageRoute(builder: (context) => InfoPage(phone))))
          //     .catchError((e) {
          //   return "error";
          // });
        },
        verificationFailed: (AuthException exception) {
          return "error";
        },
        codeSent: (String verificationCode, [int forceResendingToken]) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "Enter ",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                      text: "OTP",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))
                ]),
              ),
              content: TextField(
                controller: _code,
              ),
              backgroundColor: Colors.grey,
              actions: [
                FlatButton(
                  child: Text("Submit"),
                  onPressed: () async {
                    var _credential = PhoneAuthProvider.getCredential(
                        verificationId: verificationCode,
                        smsCode: _code.text.trim());
                    var uid =
                        (await _firebaseAuth.signInWithCredential(_credential))
                            .user
                            .uid;

                    if (uid.isNotEmpty) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    } else {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    }
                  },
                )
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationCode) {
          verificationCode = verificationCode;
        });
  }
}
