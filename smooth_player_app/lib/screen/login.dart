import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:smooth_player_app/colors.dart';
import 'package:smooth_player_app/screen/authentication/login_http.dart';

import '../api/log_status.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String username = "", password = "";

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: sHeight,
            width: sWidth,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: sWidth * .05),
                height: 300,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: (value) {
                          username = value!;
                        },
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "Username or Email is required!"),
                        ]),
                        decoration: InputDecoration(
                          labelText: "Username/Email",
                          hintText: "Enter your username or email.....",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        key: Key("PasswordLogin"),
                        onSaved: (value) {
                          password = value!.trim();
                        },
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Password is required!"),
                        ]),
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password.....",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        key: Key("ButtonLogin"),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final resData =
                                await LoginHttp().login(username, password);
                            if (resData["statusCode"] == 202) {
                              LogStatus().setToken(resData["body"]["token"]);

                              Navigator.pushNamed(context, "/home");
                            } else {
                              // MotionToast.error(
                              //   position: MOTION_TOAST_POSITION.top,
                              //   animationType: ANIMATION.fromTop,
                              //   toastDuration: Duration(seconds: 2),
                              //   description: Text(resData["body"]["resM"]),
                              // ).show(context);
                            }
                          }
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primary,
                          elevation: 10,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
