import 'package:flutter/material.dart';
import 'package:flutter_auth/AppTheme.dart';
import 'package:flutter_auth/note.dart';
import 'package:flutter_svg/svg.dart';
import 'meditation.dart';
import 'note.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
//import 'AppTheme.dart';

class CharacterListingScreen extends StatefulWidget {
  @override
  _CharacterListingScreenState createState() => _CharacterListingScreenState();
}

class _CharacterListingScreenState extends State<CharacterListingScreen> {
  int _currentindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 32.0, top: 8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Thank you", style: AppTheme.display1),
                      TextSpan(text: "\n"),
                      TextSpan(
                          text: "for payments",
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            color: Colors.grey,
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1.1,
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: CharacterWidget(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text("Contine Shopping"),
            backgroundColor: Colors.blueGrey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            backgroundColor: Colors.blueGrey,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
          switch (index) {
            case 0:
              if (cartlist.length > 0) {
                for (var ii = 0; ii <= cartlist.length; ii++) {
                  cartlist.removeAt(ii);
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CategoryType(userdetails: users);
                  },
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class CharacterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     PageRouteBuilder(
        //         transitionDuration: const Duration(milliseconds: 350),
        //         pageBuilder: (context, _, __) =>
        //             CharacterDetailScreen(character: characters[0])));
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              //clipper: CharacterCardBackgroundClipper(),
              child: Hero(
                tag: "background1",
                child: Container(
                  height: 0.54 * screenHeight,
                  width: 0.9 * screenWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade200,
                        Colors.deepOrange.shade400
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -0.5),
            child: Hero(
              tag: "background2",
              child: SvgPicture.asset("assets/icons/thankyou.svg"),
            ),
          ),
        ],
      ),
    );
  }
}
