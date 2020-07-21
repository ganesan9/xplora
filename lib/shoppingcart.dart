import 'dart:convert';

import 'package:flutter/material.dart';
import 'note.dart';
import 'payment.dart';
import 'dart:math';

class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  String subtotal;
  double sumtotal = 0.0;
  double basetotal = 0.0;
  double discount2 = 0.0;
  double gst = 0.0;
  double nettotal = 0.0;
  String qty;
  int discount_per = 0;

  @override
  Widget build(BuildContext context) {
    sumtotal = 0.0;

    return Container(
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            "Shopping Cart",
            style: (TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
          ),
          leading: IconButton(
              icon: Icon(Icons.close),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ListView.builder(
          itemCount: cartlist.length,
          itemBuilder: (BuildContext context, int index) {
            //return OrderCard(cartlist[index].name, cartlist[index].price,
            //    cartlist[index].qty, cartlist[index].imgpath);

            return itemcard(index);
          },
        ),
        bottomNavigationBar: _buildTotalContainer(),
      ),
    );
  }

  // ListView(
  //   padding: EdgeInsets.symmetric(horizontal: 10.0),
  //   scrollDirection: Axis.vertical,
  //   children: <Widget>[
  //     OrderCard(
  //         "Grilled Chicken", "25", "2", "assets/images/login_bottom.png"),
  //     OrderCard("Noodles", "10.50", "7", "assets/images/main_top.png"),
  //   ],
  // ),

  Widget itemcard(index) {
    qty = cartlist[index].qty;
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD3D3D3), width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: 55.0,
              height: 73.0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Column(
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          adjustQuantity('MINUS', index);
                        },
                        child: Icon(Icons.remove, color: Color(0xFFD3D3D3))),
                    Text(
                      qty,
                      style: TextStyle(fontSize: 18.0, color: Colors.grey),
                    ),
                    InkWell(
                        onTap: () {
                          adjustQuantity('PLUS', index);
                        },
                        child: Icon(Icons.add, color: Color(0xFFD3D3D3))),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              height: 70.0,
              width: 70.0,
              padding: const EdgeInsets.all(50.0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          webpath + 'product_img/' + cartlist[index].imgpath),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 4.0,
                        offset: Offset(2.0, 0.5))
                  ]),
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  cartlist[index].name,
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.0),
                Text(
                  "₹ " +
                      (int.parse(cartlist[index].qty) *
                              double.parse(cartlist[index].price))
                          .toString(),
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Container(
                  height: 25.0,
                  width: 120.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("",
                              style: TextStyle(
                                  color: Color(0xFFD3D3D3),
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 5.0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "* Base ₹ " +
                                  (int.parse(cartlist[index].qty) *
                                          double.parse(
                                              cartlist[index].baseprice))
                                      .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  cartlist.removeAt(index);
                });
                final snackbar = SnackBar(content: Text("Item Deleted"));
                _scaffoldkey.currentState.showSnackBar(snackbar);
              },
              child: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  adjustQuantity(pressed, index) {
    int quantity = int.parse(cartlist[index].qty);
    switch (pressed) {
      case 'PLUS':
        if (quantity != 999) {
          quantity += 1;
          cartlist[index].qty = quantity.toString();
          setState(() {
            qty = quantity.toString();
          });
          //totprice = quantity * double.parse(cartlist[index].price);
        }
        return;
      case 'MINUS':
        if (quantity != 0) {
          quantity -= 1;
          cartlist[index].qty = quantity.toString();
          setState(() {
            qty = quantity.toString();
          });
          //totprice = quantity * double.parse(cartlist[index].price);
        }
        return;
    }
  }

  //var sumtotal;
  calsubtotal() {
    sumtotal = 0.0;
    basetotal = 0.0;
    cartlist.forEach((element) {
      sumtotal += int.parse(element.qty) * double.parse(element.price);
      basetotal += int.parse(element.qty) * double.parse(element.baseprice);
    });
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Widget _buildTotalContainer() {
    double discount2 = 0.0;
    double discount3 = 0.0;

    sumtotal = 0.0;
    basetotal = 0.0;

    cartlist.forEach((element) {
      sumtotal += int.parse(element.qty) * double.parse(element.price);
      basetotal += int.parse(element.qty) * double.parse(element.baseprice);
    });
    sumtotal = roundDouble(sumtotal, 2);
    basetotal = roundDouble(basetotal, 2);

    discount2 = sumtotal * (discount_per / 100);
    discount2 = roundDouble(discount2, 2);

    discount3 = basetotal * (discount_per / 100);
    discount3 = roundDouble(discount3, 2);

    sumtotal = sumtotal - discount2;
    basetotal = basetotal - discount3;

    //gst = (sumtotal - discount) * (18 / 100);
    gst = sumtotal - basetotal;
    gst = roundDouble(gst, 2);
    //gst = double.parse(gst.toStringAsFixed(2));
    nettotal = basetotal + gst;
    nettotal = roundDouble(nettotal, 2);

    User s2 = User.fromJson(json.decode(users));

    return Container(
      height: 220.0,
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Gross Total  (" + cartlist.length.toString() + ")",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                basetotal.toString(),
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Discount " + discount_per.toString() + " %",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: 20.0,
                width: 120.0,
                color: Colors.amber,
                child: FlatButton(
                  //padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    createAlertDialog(context).then((onValue) {
                      setState(() {
                        discount_per = int.parse(onValue);
                      });
                    });
                  },
                  child: Text(
                    "Discount",
                    style: TextStyle(fontSize: 20.0, color: Colors.red),
                  ),
                ),
              ),
              Text(
                discount3.toString(),
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "GST",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                gst.toString(),
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Divider(
            height: 2.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Cart Total",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                nettotal.toString(),
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          s2.ratetable != "cus"
              ? cartlist.length > 0
                  ? GestureDetector(
                      onTap: () {
                        var ss = FinalPayment(
                            totalitems: cartlist.length.toString(),
                            grosstotal: basetotal.toString(),
                            discountper: discount_per.toString(),
                            discountamt: discount3.toString(),
                            gst: gst.toString(),
                            netamt: nettotal.toString());

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => Paymentsys(ss)));
                        // print(sumtotal.toString() +
                        //     "~" +
                        //     discount.toString() +
                        //     "~" +
                        //     gst.toString() +
                        //     "~" +
                        //     nettotal.toString());
                        //cartlist.forEach((element) {
                        //print(element.code + " - " + element.qty);
                        //sumtotal += int.parse(element.qty) * double.parse(element.price);
                        //});
                      },
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        child: Center(
                          child: Text(
                            "Proceed To Checkout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Text(
                      "Card Empty",
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    )
              : GestureDetector(
                  onTap: () {
                    final snackbar = SnackBar(content: Text("Order Placed"));
                    _scaffoldkey.currentState.showSnackBar(snackbar);
                  },
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Center(
                      child: Text(
                        "Order Place",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  Future<String> createAlertDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Discount %"),
            content: TextField(
              autofocus: true,
              controller: customController,
              keyboardType: TextInputType.number,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(customController.text.toString());
                },
                elevation: 5.0,
                child: Text("Okay"),
              )
            ],
          );
        });
  }
}
