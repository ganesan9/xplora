import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/screens/details_screen.dart';
import 'package:flutter_auth/widgets/bottom_nav_bar.dart';
import 'package:flutter_auth/widgets/category_card.dart';
import 'package:flutter_auth/widgets/search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note.dart';
import 'productlist.dart';
import 'custom_dialog.dart';

class CategoryType extends StatefulWidget {
  final String userdetails;

  CategoryType({Key key, this.userdetails}) : super(key: key);

  @override
  _CategoryTypeState createState() => _CategoryTypeState();
}

class _CategoryTypeState extends State<CategoryType> {
  //static String users;

  SharedPreferences localStorage;
  asyncFunc() async {
    localStorage = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    users = widget.userdetails;
    asyncFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    User s2 = User.fromJson(json.decode(users));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Good " + greeting() + " " + s2.name,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFF5CEB8),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
                  Color(0xFFFFCEB8),
                  Color(0xFFF5CEB8),
                ]),
              ),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/main_top.png',
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "Flutter",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomListTile(Icons.person, 'Profile', () => {}),
            CustomListTile(Icons.notifications, 'Notifications', () => {}),
            CustomListTile(Icons.settings, 'Settings', () => {}),
            CustomListTile(Icons.lock, 'Logout', () => {}),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      body: Stack(
        children: <Widget>[
          Container(
            // Here the height of the container is 45% of our total height
            height: size.height * .45,
            decoration: BoxDecoration(
              color: Color(0xFFF5CEB8),
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        print("Ganesan");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: Color(0xFFF2BEA1),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset("assets/icons/menu.svg"),
                      ),
                    ),
                  ),
                  Text(
                    "Good " + greeting() + "\n" + s2.name,
                    style: Theme.of(context)
                        .textTheme
                        .display1
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                  SearchBar(),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        CategoryCard(
                          title: "COVID-19 Store",
                          svgSrc: "assets/icons/covid19.svg",
                          press: () {
                            s2.ratetable != "cus"
                                ? productview('COVID-19 Store', s2.ratetable)
                                : showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialog(
                                      title: "Xplora Shoppe Rate",
                                      description:
                                          "With an account, your data will be securely saved, allowing you to access it from multiple devices.",
                                      primaryButtonText: "MSP",
                                      primaryButtonRoute: "/signUp",
                                      secondaryButtonText: "MRP",
                                      secondaryButtonRoute: "/home",
                                      nextscreen: "COVID-19 Store",
                                    ),
                                  );
                          },
                        ),
                        CategoryCard(
                          title: "LAVO Products",
                          svgSrc: "assets/icons/lavo.svg",
                          press: () {
                            s2.ratetable != "cus"
                                ? productview('LAVO Products', s2.ratetable)
                                : showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialog(
                                      title: "Xplora Shoppe Rate",
                                      description:
                                          "With an account, your data will be securely saved, allowing you to access it from multiple devices.",
                                      primaryButtonText: "MSP",
                                      primaryButtonRoute: "/signUp",
                                      secondaryButtonText: "MRP",
                                      secondaryButtonRoute: "/home",
                                      nextscreen: "LAVO Products",
                                    ),
                                  );
                          },
                        ),
                        CategoryCard(
                          title: "Kitchen-Ware",
                          svgSrc: "assets/icons/kitcheware.svg",
                          press: () {},
                        ),
                        CategoryCard(
                          title: "HomeCare",
                          svgSrc: "assets/icons/homecare.svg",
                          press: () {},
                        ),
                        CategoryCard(
                          title: "Students Shoppe",
                          svgSrc: "assets/icons/yoga.svg",
                          press: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void productview(String category, String rate) {
    localStorage.setString('ratetable', rate);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return ProductList(category);
      }),
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }
}

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: InkWell(
          splashColor: Colors.orangeAccent,
          onTap: onTap,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
