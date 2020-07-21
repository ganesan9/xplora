import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'note.dart';

class BurgerPage extends StatefulWidget {
  final imgPath, foodName, pricePerItem, heroTag, code, description, baseprice;

  BurgerPage(
      {this.imgPath,
      this.foodName,
      this.pricePerItem,
      this.heroTag,
      this.code,
      this.description,
      this.baseprice});

  @override
  _BurgerPageState createState() => _BurgerPageState();
}

class _BurgerPageState extends State<BurgerPage> {
  var netPrice = 0.0;
  var quantity = 1;

  var cartitem_count = "0";

  @override
  void initState() {
    cartlist.forEach((element) {
      if (element.code.toString() == widget.code.toString()) {
        quantity = int.parse(element.qty.toString());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      cartitem_count = cartlist.length.toString();
    });

    return Scaffold(
        body: ListView(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                Stack(children: [
                  Container(
                      height: 45.0, width: 45.0, color: Colors.transparent),
                  Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Color(0xFFFE7D6A).withOpacity(0.3),
                            blurRadius: 6.0,
                            spreadRadius: 4.0,
                            offset: Offset(0.0, 4.0))
                      ], color: Color(0xFFFE7D6A), shape: BoxShape.circle),
                      child: Center(
                          child:
                              Icon(Icons.shopping_cart, color: Colors.white))),
                  Positioned(
                      top: 1.0,
                      right: 4.0,
                      child: Container(
                          height: 12.0,
                          width: 12.0,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Center(
                            child: Text(cartitem_count,
                                style: GoogleFonts.notoSans(
                                    fontSize: 7.0,
                                    textStyle: TextStyle(color: Colors.red))),
                          )))
                ])
              ],
            )),
        SizedBox(height: 5.0),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'SUPER ',
            style: GoogleFonts.notoSans(
                fontWeight: FontWeight.w800, fontSize: 27.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            widget.foodName.toString().toUpperCase(),
            style: GoogleFonts.notoSans(
                fontWeight: FontWeight.w800, fontSize: 27.0),
          ),
        ),
        SizedBox(height: 40.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Hero(
                tag: widget.heroTag,
                child: Container(
                    height: 200.0,
                    width: 180.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                webpath + 'product_img/' + widget.imgPath),
                            fit: BoxFit.contain)))),
            SizedBox(width: 0.0),
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 1.0,
                                spreadRadius: 1.0,
                                offset: Offset(5.0, 6.0))
                          ]),
                    ),
                    Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white),
                      child: Center(
                        child: Icon(Icons.favorite_border,
                            color: Color(0xFFFE7D6A), size: 25.0),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 35.0),
                Stack(children: <Widget>[
                  Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 1.0,
                            spreadRadius: 1.0,
                            offset: Offset(5.0, 6.0)),
                      ],
                    ),
                  ),
                  Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Icon(Icons.restore,
                          color: Color(0xFFFE7D6A), size: 25.0),
                    ),
                  ),
                ])
              ],
            )
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            Stack(children: [
              Container(
                height: 50.0,
                width: 190.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                          offset: Offset(5.0, 6.0))
                    ]),
              ),
              Container(
                  height: 50.0,
                  width: 190.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white),
                  child: Center(
                      child: Text(
                    '₹ ' +
                        (double.parse(widget.pricePerItem) * quantity)
                            .toString(),
                    style: GoogleFonts.notoSans(
                        fontSize: 35.0,
                        color: Color(0xFF5E6166),
                        fontWeight: FontWeight.w500),
                  )))
            ])
          ],
        ),
        SizedBox(height: 15.0),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
              height: 60.0,
              width: 300.0,
              decoration: BoxDecoration(
                  color: Color(0xFFFE7D6A),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      height: 40.0,
                      width: 125.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              iconSize: 17.0,
                              icon:
                                  Icon(Icons.remove, color: Color(0xFFFE7D6A)),
                              onPressed: () {
                                adjustQuantity('MINUS');
                              }),
                          Text(
                            quantity.toString(),
                            style: GoogleFonts.notoSans(
                                fontSize: 17.0,
                                color: Color(0xFFFE7D6A),
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              iconSize: 17.0,
                              icon: Icon(Icons.add, color: Color(0xFFFE7D6A)),
                              onPressed: () {
                                adjustQuantity('PLUS');
                              }),
                        ],
                      )),
                  FlatButton(
                    onPressed: () {
                      itemaddcart(
                          widget.code.toString(),
                          widget.foodName,
                          widget.imgPath,
                          widget.pricePerItem,
                          quantity.toString(),
                          widget.baseprice);
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      'Add to cart',
                      style: GoogleFonts.notoSans(
                          fontSize: 17.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ))
        ]),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'FEATURED',
            style: GoogleFonts.notoSans(
                fontSize: 16.0, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
            height: 225.0,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[_buildListItem('1'), _buildListItem('2')],
            ))
      ],
    ));
  }

  _buildListItem(String columnNumber) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            //Don't do this in a real app.

            if (columnNumber == '1')
              _buildColumnItem('assets/cookiechoco.jpg', 'Sweet cheese', '11',
                  Color(0xFFFBD6F5)),
            if (columnNumber == '1')
              SizedBox(height: 15.0),
            if (columnNumber == '1')
              _buildColumnItem('assets/cookieclassic.jpg', 'Sweet popcorn',
                  '11', Color(0xFFFBD6F5)),
            if (columnNumber == '2')
              _buildColumnItem(
                  'assets/cookiecream.jpg', 'Tacos', '6', Color(0xFFC2E3FE)),
            if (columnNumber == '2')
              SizedBox(height: 15.0),
            if (columnNumber == '2')
              _buildColumnItem(
                  'assets/cookievan.jpg', 'Sandwich', '6', Color(0xFFD7FADA)),
          ],
        ));
  }

  _buildColumnItem(
      String imgPath, String foodName, String price, Color bgColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            width: 210.0,
            child: Row(children: [
              Container(
                  height: 75.0,
                  width: 75.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0), color: bgColor),
                  child: Center(
                      child: Image.asset(imgPath, height: 50.0, width: 50.0))),
              SizedBox(width: 20.0),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(foodName,
                    style: GoogleFonts.notoSans(
                        fontSize: 14.0, fontWeight: FontWeight.w400)),
                Text(
                  '\$' + price,
                  style: GoogleFonts.lato(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      textStyle: TextStyle(color: Color(0xFFF68D7F))),
                ),
              ])
            ]))
      ],
    );
  }

  adjustQuantity(pressed) {
    switch (pressed) {
      case 'PLUS':
        setState(() {
          if (quantity != 999) {
            quantity += 1;
          }
        });
        return;
      case 'MINUS':
        setState(() {
          if (quantity != 0) {
            quantity -= 1;
          }
        });
        return;
    }
  }

  itemaddcart(code, name, imagepath, price, qty, baseprice) {
    bool flag = true;
    cartlist.forEach((element) {
      if (element.code.toString() == code.toString()) {
        element.qty = qty;
        flag = false;
      }
    });

    if (flag) {
      cartlist.add(Cart(code, name, imagepath, price, qty, baseprice));
    }

    cartlist.forEach((element) {
      //print(element.code+" - "+element.qty);
    });
  }
}
