import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'productlist.dart';
import 'note.dart';

class CustomDialog extends StatelessWidget {
  final primaryColor = const Color(0xFF75A2EA);
  final grayColor = const Color(0xFF939393);

  final String title,
      description,
      primaryButtonText,
      primaryButtonRoute,
      secondaryButtonText,
      secondaryButtonRoute,
      nextscreen;

  User s2 = User.fromJson(json.decode(users));
  UserData userdata = new UserData();

  CustomDialog(
      {@required this.title,
      @required this.description,
      @required this.primaryButtonText,
      @required this.primaryButtonRoute,
      this.secondaryButtonText,
      this.secondaryButtonRoute,
      this.nextscreen});

  static const double padding = 20.0;
  SharedPreferences localStorage;
  asyncFunc() async {
    localStorage = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    asyncFunc();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 24.0),
                AutoSizeText(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 24.0),
                AutoSizeText(
                  description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: grayColor,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 24.0),
                RaisedButton(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: AutoSizeText(
                      primaryButtonText,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    userdata.ratetable = "msp";
                    localStorage.setString('ratetable', 'msp');
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ProductList(nextscreen);
                      }),
                    );
                  },
                ),
                SizedBox(height: 10.0),
                showSecondaryButton(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  showSecondaryButton(BuildContext context) {
    if (secondaryButtonRoute != null && secondaryButtonText != null) {
      return RaisedButton(
        color: Colors.teal,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: AutoSizeText(
            secondaryButtonText,
            maxLines: 1,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () {
          userdata.ratetable = "mrp";
          localStorage.setString("ratetable", "mrp");
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return ProductList(nextscreen);
            }),
          );
        },
      );
    } else {
      return SizedBox(height: 10.0);
    }
  }
}
