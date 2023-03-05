import 'package:chat_app/components.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginScreen extends StatelessWidget {
  static String id = 'login';
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(kLogo, width: 150, height: 150),
            Text(
              "Chat App By Yusuf",
              style: TextStyle(fontFamily: 'Pacifico', fontSize: 20),
            ),
            Text(
              "Sing In",
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 20,
              ),
              textAlign: TextAlign.start,
            ),
            buildFormFieldText(
                labelText: "Email",
                keyboardType: TextInputType.emailAddress,
                onChange: (v) {
                  email = v;
                }),
            SizedBox(
              height: 10,
            ),
            buildFormFieldText(
                labelText: "Password",
                keyboardType: TextInputType.text,
                onChange: (v) {
                  password = v;
                }),
            buildElevatedTextButton(
                backgroundColor: Colors.white,
                titleOfButton: "Log in",
                titleOfButtonColor: Colors.black,
                borderColor: Colors.white,
                buttonWidth: double.infinity,
                widthOfBorder: 0,
                onPressedFunction: () async {
                  try {
                    buildLogInUserWithEmailAndPassword(
                        email: email!, password: password!);
                    buildFlutterToast(
                      message: 'GOOD JOB',
                      state: ToastStates.SUCCESS,
                    );
                    navigateNamedTO(context, ChatScreen.id, arguments: email);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      buildFlutterToast(
                        message: 'No user found for that email.',
                        state: ToastStates.ERROR,
                      );
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      buildFlutterToast(
                        message: 'Wrong password provided for that user.',
                        state: ToastStates.ERROR,
                      );
                      print('Wrong password provided for that user.');
                    }
                  }
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Dont have an Account ? "),
                TextButton(
                  onPressed: () {
                    navigateNamedTO(context, RegisterScreen.id);
                  },
                  child: Text(
                    "REGISTER NOW",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
