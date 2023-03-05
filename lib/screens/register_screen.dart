import 'package:chat_app/components.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  // const RegisterScreen({super.key});
  static String id = "register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? email;

  String? password;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: Colors.black,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: [
                Image.asset(kLogo,
                    width: 150, height: 150),
                const Text(
                  "Chat App By Yusuf",
                  style: TextStyle(fontFamily: 'Pacifico', fontSize: 20),
                ),
                const Text(
                  "Register",
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.start,
                ),
                // buildFormFieldText(
                //   labelText: "Name",
                // ),
                const SizedBox(
                  height: 10,
                ),
                buildFormFieldText(
                    labelText: "Email",
                    controller: emailController,
                    validate: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter email";
                      } else {
                        return null;
                      }
                    },
                    onSubmit: (value) {
                      if (_formKey.currentState!.validate()) {
                        value = emailController.text.toString();
                      }
                    },
                    onChange: (value) {
                      // emailController.text = value;
                      email = value;
                    }),
                const SizedBox(
                  height: 10,
                ),
                buildFormFieldText(
                  labelText: "Password",
                  controller: passwordController,
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter pass";
                    } else {
                      return null;
                    }
                  },
                  onSubmit: (value) {
                    if (_formKey.currentState!.validate()) {
                      value = passwordController.text.toString();
                    }
                  },
                  onChange: (value) {
                    // passwordController.text = value;
                    password = value;
                  },
                ),
                buildElevatedTextButton(
                  backgroundColor: Colors.black,
                  titleOfButton: "Register",
                  borderColor: Colors.black,
                  widthOfBorder: 0,
                  onPressedFunction: () async {
                    if (_formKey.currentState!.validate()) {
                      isLoading == true;
                      setState(() {});
                      try {
                        // var auth = FirebaseAuth.instance;
                        // UserCredential user =
                        //     await auth.createUserWithEmailAndPassword(
                        //   email: email!,
                        //   password: password!,
                        UserCredential user =
                            await buildRegisterUserWithEmailAndPassword(
                                email: email!, password: password!);

                        buildFlutterToast(
                          message: 'The account success register.',
                          state: ToastStates.SUCCESS,
                        );
                        navigateNamedTO(context, ChatScreen.id , arguments: email);
                        print(user.user!.email);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                          print('error22');
                          buildShowSnackBar(
                            context,
                            Text('The password provided is too weak.'),
                          );
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                          print('error2');
                          buildShowSnackBar(
                            context,
                            Text('The account already exists for that email..'),
                          );
                          buildFlutterToast(
                            message:
                                'The account already exists for that email.',
                            state: ToastStates.ERROR,
                          );
                        }
                      } catch (e) {
                        print('error3');
                        buildShowSnackBar(
                            context, Text("Error while register"));
                        print('error4');
                        print(e.toString());
                      }
                      isLoading = false;
                      setState(() {});
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Do you have an Account ? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
