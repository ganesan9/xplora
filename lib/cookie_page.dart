import 'package:flutter/material.dart';
import 'package:flutter_auth/meditation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'note.dart';
import 'dart:convert';
import 'product_detail.dart';
import 'dart:math';

SharedPreferences localStorage;

// asyncFunc() async {
//   localStorage = await SharedPreferences.getInstance();
// }

class CookiePage extends StatefulWidget {
  @override
  _HomeCookiePage createState() => _HomeCookiePage();
}

class _HomeCookiePage extends State<CookiePage> {
  List<Note> _notes = List<Note>();
  User s2 = User.fromJson(json.decode(users));
  UserData userdata = new UserData();

  Future<List<Note>> fetchNotes() async {
    localStorage = await SharedPreferences.getInstance();

    var url = webpath + "productlist.php";
    var response = await http.post(url, body: {
      "category": "Hand Wash",
      "ratetable": localStorage.getString("ratetable"),
    });
    //var response2 = await http.get(url);

    var notes = List<Note>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      print(notesJson);
      for (var noteJson in notesJson) {
        notes.add(Note.fromJson(noteJson));
      }
    }
    return notes;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width / 2;
    double aa = ((_notes.length / 2) * 100);
    if (_notes.isNotEmpty) aa = aa - 50;
    if (aa < 410) aa = 410;

    //print(s2.ratetable.toString());
    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 15.0),
          Container(
              padding: EdgeInsets.only(right: 15.0),
              width: MediaQuery.of(context).size.width - 30.0,
              height: aa,
              child: GridView.count(
                crossAxisCount: 2,
                primary: false,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: screenWidth / 250,
                children: <Widget>[
                  for (var item in _notes)
                    _buildCard(
                        item.title,
                        item.price,
                        item.basePrice,
                        item.imgpath,
                        item.code,
                        item.description,
                        getqty(cartlist, item.code),
                        context)
                ],
              )),
          SizedBox(height: 15.0)
        ],
      ),
    );
  }

  Widget _buildCard(String name, String price, String basePrice, String imgPath,
      String code, String description, String curr_qty, context) {
    bool isFavorite = true;
    bool added = true;

    return Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                  // MaterialPageRoute(builder: (context) => CookieDetail(
                  //   assetPath: imgPath,
                  //   cookieprice:price,
                  //   cookiename: name
                  // )));
                  MaterialPageRoute(
                      builder: (context) => BurgerPage(
                            foodName: name,
                            pricePerItem: price,
                            imgPath: imgPath,
                            heroTag: name,
                            code: code,
                            description: description,
                            baseprice: basePrice,
                          )));
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3.0,
                          blurRadius: 5.0)
                    ],
                    color: Colors.white),
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            isFavorite
                                ? Icon(Icons.favorite_border,
                                    color: Color(0xFFEF7532))
                                : Icon(Icons.favorite_border,
                                    color: Color(0xFFEF7532))
                          ])),
                  Hero(
                      tag: name,
                      child: Container(
                          height: 75.0,
                          width: 75.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      webpath + 'product_img/' + imgPath),
                                  fit: BoxFit.contain)))),
                  SizedBox(height: 7.0),
                  Text("₹ " + price,
                      style: TextStyle(
                          color: Color(0xFFCC8053),
                          fontFamily: 'Varela',
                          fontSize: 14.0),
                      textAlign: TextAlign.center),
                  Text("[Base ₹ " + basePrice + "]",
                      style: TextStyle(
                          color: Color(0xFFCC8053),
                          fontFamily: 'Varela',
                          fontSize: 12.0),
                      textAlign: TextAlign.center),
                  Text(name,
                      style: TextStyle(
                          color: Color(0xFF575E67),
                          fontFamily: 'Varela',
                          fontSize: 10.0),
                      textAlign: TextAlign.center),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
                  Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            if (!added) ...[
                              Icon(Icons.shopping_basket,
                                  color: Color(0xFFD17E50), size: 20.0),
                              Text('Add to cart',
                                  style: TextStyle(
                                      fontFamily: 'Varela',
                                      color: Color(0xFFD17E50),
                                      fontSize: 17.0))
                            ],
                            if (added) ...[
                              Icon(Icons.remove_circle_outline,
                                  color: Color(0xFFD17E50), size: 20.0),
                              Text(curr_qty,
                                  style: TextStyle(
                                      fontFamily: 'Varela',
                                      color: Color(0xFFD17E50),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0)),
                              Icon(Icons.add_circle_outline,
                                  color: Color(0xFFD17E50), size: 20.0),
                            ]
                          ]))
                ]))));
  }

  String getqty(List<dynamic> alllist, codes) {
    if (alllist.isNotEmpty) {
      var qtyqty = "0";
      alllist.forEach((element) {
        if (element.code.toString() == codes.toString()) {
          qtyqty = element.qty;
        }
      });
      return qtyqty.toString();
    } else {
      return "0";
    }
  }
}
