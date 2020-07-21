import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';

//https://www.youtube.com/watch?v=jExrphsQlbc
class OnlinePayment extends StatefulWidget {
  final String amount;
  OnlinePayment(this.amount);

  @override
  _OnlinePaymentState createState() => _OnlinePaymentState(amount);
}

class _OnlinePaymentState extends State<OnlinePayment> {
  String totalamount;
  Razorpay _razorpay;
  _OnlinePaymentState(this.totalamount);

  var localresponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlePaymentWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_ju6jPlCHrx8nnj',
      'amount': (int.parse(totalamount) * 100).toString(),
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
    print("Ganesan : " + response.paymentId);
    setState(() {
      localresponse = response;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Error : " + response.code.toString() + " - " + response.message);
    setState(() {
      localresponse = response;
    });
  }

  void _handlePaymentWallet(ExternalWalletResponse response) {
    print("External Wallet : " + response.walletName);
    setState(() {
      localresponse = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    openCheckout();
    return MaterialApp(
        home: Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(totalamount),
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 10.0,
        leading: Icon(Icons.arrow_back),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: 150.0,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Enter amount",
                    labelText: double.parse(totalamount)
                        .roundToDouble()
                        .toStringAsFixed(0)),
                onChanged: (value) {
                  setState(() {
                    totalamount = value;
                  });
                },
              ),
            ),
            SizedBox(height: 15.0),
            RaisedButton(
                color: Colors.teal,
                onPressed: () {
                  openCheckout();
                },
                child: Text(
                  "Make Payment",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    ));
  }
}
