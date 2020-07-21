import 'package:flutter/material.dart';
import 'package:flutter_auth/onlinepayment.dart';
import 'package:http/http.dart' as http;
import 'note.dart';
import 'dart:convert';
import 'thankyou.dart';
import 'shoppingcart.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

SharedPreferences localStorage;
asyncFunc() async {
  localStorage = await SharedPreferences.getInstance();
}

class Paymentsys extends StatefulWidget {
  final FinalPayment payment;
  Paymentsys(this.payment);

  @override
  _PaymentsysState createState() => _PaymentsysState(payment);
}

class _PaymentsysState extends State<Paymentsys> {
  FinalPayment payment;
  Razorpay _razorpay;
  _PaymentsysState(this.payment);
  String returnstr;
  String payamount, unikey;

  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  Random random;

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asyncFunc();
    random = new Random();
    unikey = random.nextInt(100000000).toString();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlePaymentWallet);
  }

  @override
  Widget build(BuildContext context) {
    String discountdesc = "";
    payamount = double.parse(payment.netamt).roundToDouble().toStringAsFixed(0);

    if (double.parse(payment.discountamt) > 0) {
      discountdesc =
          "Discount (" + payment.discountper + "%) : \₹ " + payment.discountamt;
    } else {
      discountdesc = "";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment "),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.payment),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 20, 0, 100),
        brightness: Brightness.dark,
        textTheme:
            TextTheme(title: TextStyle(color: Colors.white, fontSize: 20)),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: ListView(),
      ),
      body: Container(
        key: _formKeyValue,
        color: Color(0xFFbdc3c7),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 20, 0, 100),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40))),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Bill Amount",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "INR",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "\₹ " + payment.netamt,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF2ecc71),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              child: Text(
                                "GST \₹ " + payment.gst,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              discountdesc,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(colors: [
                        Color(0xFFe67e22),
                        Color(0xFFf1c40f),
                      ])),
                )),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: RaisedButton.icon(
                      padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                      onPressed: () {
                        billpayment('Cash', 'Cash').toString();
                      },
                      icon: Icon(
                        Icons.account_balance_wallet,
                        color: Color(0xFF3498db),
                      ),
                      label: Text(
                        "Cash",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800]),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: RaisedButton.icon(
                      padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                      onPressed: () {
                        createAlertDialog(context).then((chequedetails) {
                          billpayment('Cheque', chequedetails.toString());
                        });
                      },
                      icon: Icon(
                        Icons.business,
                        color: Color(0xFF2ecc71),
                      ),
                      label: Text("Cheque",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800])),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              alignment: Alignment.topLeft,
              child: Text(
                "Online Payment",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                alignment: Alignment.topLeft,
                child: Column(
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) {
                          //     return OnlinePayment(payamount);
                          //   }),
                          // );
                          openCheckout();
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          leading: CircleAvatar(
                            backgroundColor: Color(0xFFecf0f1),
                            child: Icon(Icons.camera_front,
                                color: Color(0xFFf1c40f)),
                          ),
                          title: Text("Net Banking"),
                          trailing: Text(
                            "\₹ " + payment.netamt,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFFecf0f1),
                          child: Icon(Icons.chrome_reader_mode,
                              color: Color(0xFF2980b9)),
                        ),
                        title: Text("Debit Card"),
                        trailing: Text(
                          "\₹ " + payment.netamt,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFFecf0f1),
                          child:
                              Icon(Icons.credit_card, color: Color(0xFF2980b9)),
                        ),
                        title: Text("Credit Card"),
                        trailing: Text(
                          "\₹ " + payment.netamt,
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 100,
            ),
          ],
        )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            title: Text("BlueTooth"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            title: Text("Cart"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.party_mode),
            title: Text("Product"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            title: Text("Logout"),
          ),
        ],
        currentIndex: 0,
        onTap: (i) {
          switch (i) {
            case 0:
              break;
            case 1:
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ShoppingCart()));
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 20, 0, 100),
      ),
    );
  }

  Future<String> billpayment(String billtype, String billdesc) async {
    String listlist = "";

    cartlist.forEach((element) {
      listlist = listlist +
          element.code.toString() +
          "-" +
          element.qty.toString() +
          "~";
    });
    if (listlist.isNotEmpty)
      listlist = listlist.substring(0, listlist.length - 1);

    var url = webpath + "billpayment.php";
    User s2 = User.fromJson(json.decode(users));
    var response = await http.post(url, body: {
      "userid": s2.id,
      "cartlist": listlist,
      "payment_mode": billtype,
      "billdesc": billdesc,
      "totalitems": payment.totalitems,
      "grosstotal": payment.grosstotal,
      "discountper": payment.discountper,
      "discountamt": payment.discountamt,
      "gst": payment.gst,
      "netamt": payment.netamt,
      "screenid": unikey,
      "ratetable": localStorage.getString("ratetable"),
    });
    var resultans;

    if (response.statusCode == 200) {
      //resultans = json.decode(response.body);
      resultans = response.body;
    }

    setState(() {
      returnstr = resultans.toString();
      if (cartlist.length > 0) {
        for (var ii = 0; ii <= cartlist.length; ii++) {
          cartlist.removeAt(ii);
        }
      }
    });
    _ackAlert(context, company_name + " Order No ", returnstr);

    print(returnstr.toString());

    return resultans;
  }

  Future<String> createAlertDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Cheque Details"),
            content: TextField(
              autofocus: true,
              controller: customController,
              keyboardType: TextInputType.text,
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

  Future<void> _ackAlert(BuildContext context, String titlemsg, String msg) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titlemsg),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CharacterListingScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _errorPayment(
      BuildContext context, String titlemsg, String msg) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titlemsg),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ShoppingCart()));
              },
            ),
          ],
        );
      },
    );
  }

  void openCheckout() async {
    var options = {
      'key': paymentkey,
      'amount': (int.parse(payamount) * 100).toString(),
      'name': 'Xplora Shoppe',
      'description': 'Test Payment',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    billpayment('Online Payment', response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _errorPayment(context, "Error Payment",
        "Some Problem in Online Payment.\n Try Later");
  }

  void _handlePaymentWallet(ExternalWalletResponse response) {
    print("External Wallet : " + response.walletName);
  }
}
