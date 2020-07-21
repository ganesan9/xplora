import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_auth/meditation.dart';
import 'package:http/http.dart' as http;
import '../../../note.dart';

TextEditingController user = new TextEditingController();
TextEditingController pass = new TextEditingController();

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  Future<String> _submit(context) async {
    final response = await http.post(webpath + "loginsubmit.php", body: {
      "username": user.text,
      "password": pass.text,
    });

    var datauser = json.decode(response.body);
    //User s2 = User.fromJson(json.decode(datauser));
    //print(s2.name);
    return Future.value(datauser.toString());
  }

  msgbox(String msg, context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Login'),
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    ).then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "XPLORA SHOPPE",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Color(0xFF6F35A5)),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              txtControl: user,
              icon: Icons.person,
              hintText: "Login",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              txtControl: pass,
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                var datauser = await _submit(context);

                if (datauser.length == 0) {
                  msgbox("Wrong Login", context);
                } else if (datauser == "wronguser") {
                  msgbox("Wrong user name", context);
                } else if (datauser == "wrongpass") {
                  msgbox("Wrong password", context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        //print(datauser);
                        return CategoryType(userdetails: datauser);
                        //return MeditationScreen();
                      },
                    ),
                  );
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
