import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'note.dart';
import 'shoppingcart.dart';

//Not Use this Program. Code Marge in shoppingcart.dart
class OrderCard extends StatefulWidget {
  final productname, price, qty, imgpath;

  OrderCard(this.productname, this.price, this.qty, this.imgpath);

  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  int quantity;

  var totprice;

  @override
  Widget build(BuildContext context) {
    //quantity = int.parse(widget.qty);

    if (quantity == null) {
      quantity = int.parse(widget.qty);
    }

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
                          adjustQuantity('MINUS');
                        },
                        child: Icon(Icons.remove, color: Color(0xFFD3D3D3))),
                    Text(
                      quantity.toString(),
                      style: TextStyle(fontSize: 18.0, color: Colors.grey),
                    ),
                    InkWell(
                        onTap: () {
                          adjustQuantity('PLUS');
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
                          'http://www.neomaxgroup.com/shoppe/product_img/' +
                              widget.imgpath),
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
                AutoSizeText(
                  widget.productname.toString(),
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.0),
                Text(
                  "₹ " + (quantity * double.parse(widget.price)).toString(),
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
                          Text("Chicken",
                              style: TextStyle(
                                  color: Color(0xFFD3D3D3),
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 5.0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "x",
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
                print("ganesan");
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

  calsubtotal() {
    double sumtotal = 0.0;
    cartlist.forEach((element) {
      sumtotal += int.parse(element.qty) * double.parse(element.price);
    });
    setState(() {
      //subtotal = sumtotal.toString();
    });
  }

  adjustQuantity(pressed) {
    switch (pressed) {
      case 'PLUS':
        setState(() {
          if (quantity != 999) {
            quantity += 1;
            totprice = quantity * double.parse(widget.price);
          }
        });
        return;
      case 'MINUS':
        setState(() {
          if (quantity != 0) {
            quantity -= 1;
            totprice = quantity * double.parse(widget.price);
          }
        });
        return;
    }
  }
}
