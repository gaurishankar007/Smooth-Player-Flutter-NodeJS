import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:smooth_player_app/api/http/token_http.dart';
import 'package:smooth_player_app/screen/authentication/enter_token.dart';

import '../../resource/colors.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  String email = "", password = "", confirmPassword = "";

  bool p = true, conP = true;
  OutlineInputBorder formBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.form,
      width: 2,
      style: BorderStyle.solid,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: TextStyle(
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: sWidth * 0.04,
            right: sWidth * 0.04,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  key: ValueKey("email"),
                  onSaved: (value) {
                    email = value!;
                  },
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    MultiValidator([
                      RequiredValidator(errorText: "Email is required!"),
                    ]);
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.form,
                    hintText: "Enter your email.....",
                    enabledBorder: formBorder,
                    focusedBorder: formBorder,
                    errorBorder: formBorder,
                    focusedErrorBorder: formBorder,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.only(left: 0, right: 0, bottom: 10),
                  minLeadingWidth: 0,
                  title: TextFormField(
                    key: ValueKey("password"),
                    onChanged: (value) {
                      password = value;
                    },
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: "Current password is required!"),
                    ]),
                    obscureText: p,
                    style: TextStyle(
                      color: AppColors.text,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.form,
                      hintText: "Enter your current password.....",
                      enabledBorder: formBorder,
                      focusedBorder: formBorder,
                      errorBorder: formBorder,
                      focusedErrorBorder: formBorder,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        p = !p;
                      });
                    },
                    constraints: BoxConstraints(),
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.only(left: 0, right: 0, bottom: 10),
                  minLeadingWidth: 0,
                  title: TextFormField(
                    key: ValueKey("confirmPassword"),
                    onChanged: (value) {
                      confirmPassword = value;
                    },
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: "Confirm password is required!"),
                    ]),
                    obscureText: conP,
                    style: TextStyle(
                      color: AppColors.text,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.form,
                      hintText: "Confirm New Password......",
                      enabledBorder: formBorder,
                      focusedBorder: formBorder,
                      errorBorder: formBorder,
                      focusedErrorBorder: formBorder,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        conP = !conP;
                      });
                    },
                    constraints: BoxConstraints(),
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      if (password != confirmPassword) {
                        Fluttertoast.showToast(
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          msg: "Password and confirm password must be same",
                        );
                      }

                      final resData =
                          await TokenHttp().generateToken(email, password);

                      if (resData["statusCode"] == 201) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => VerifyToken(
                              userId: resData["body"]["userId"],
                            ),
                          ),
                        );
                        Fluttertoast.showToast(
                          msg: "Token generated. Check your email.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: resData["body"]["resM"],
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    }
                  },
                  child: Text(
                    "Submit",
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
    );
  }
}
