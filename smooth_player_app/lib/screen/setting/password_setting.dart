import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:smooth_player_app/api/http/user_http.dart';

import '../../resource/colors.dart';

class PasswordSetting extends StatefulWidget {
  const PasswordSetting({Key? key}) : super(key: key);

  @override
  _PasswordSettingState createState() => _PasswordSettingState();
}

class _PasswordSettingState extends State<PasswordSetting> {
  final _formKey = GlobalKey<FormState>();
  String currentPassword = "", newPassword = "", confirmPassword = "";
  bool curP = true, newP = true, conP = true;

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
          "Change Password",
          style: TextStyle(color: AppColors.text),
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
      body: SafeArea(
        child: SingleChildScrollView(
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
                  ListTile(
                    contentPadding:
                        EdgeInsets.only(left: 0, right: 0, bottom: 10),
                    minLeadingWidth: 0,
                    title: TextFormField(
                      key: Key("CurrentPassword"),
                      onChanged: (value) {
                        currentPassword = value;
                      },
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: "Currrent password is required!"),
                      ]),
                      obscureText: curP,
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
                          curP = !curP;
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
                      key: Key("NewPassword"),
                      onChanged: (value) {
                        newPassword = value;
                      },
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: "New password is required!"),
                      ]),
                      obscureText: newP,
                      style: TextStyle(
                        color: AppColors.text,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.form,
                        hintText: "Enter your New password.....",
                        enabledBorder: formBorder,
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          newP = !newP;
                        });
                      },
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  ListTile(
                    contentPadding:
                        EdgeInsets.only(left: 0, right: 0, bottom: 10),
                    minLeadingWidth: 0,
                    title: TextFormField(
                      key: Key("ConfirmPassword"),
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

                        if (confirmPassword != newPassword) {
                          Fluttertoast.showToast(
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            msg:
                                "Confirm password and new password muust be same",
                          );
                        }

                        final resData = await UserHttp()
                            .changePassword(currentPassword, newPassword);

                        if (resData["statusCode"] == 200) {
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            msg: "Your password has been changed.",
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
                      "Change Password",
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
    );
  }
}
