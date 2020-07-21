const String company_name = "Xplora Shoppe";
const String paymentkey = "rzp_test_ju6jPlCHrx8nnj";
const String webpath = "http://www.neomaxgroup.com/shoppe/";

class UserData {
  String ratetable;
}

class User {
  String id;
  String userid;
  String username;
  String name;
  String mobileno;
  String region;
  String thfrancode;
  String refcode;
  String entrydate;
  String password;
  String imgpath;
  String permission;
  String ratetable;

  User(
      this.id,
      this.userid,
      this.username,
      this.name,
      this.mobileno,
      this.region,
      this.thfrancode,
      this.refcode,
      this.entrydate,
      this.password,
      this.imgpath,
      this.permission,
      this.ratetable);

  User.fromJson(Map json)
      : id = json['id'],
        userid = json['user_id'],
        username = json['user_name'],
        name = json['name'],
        mobileno = json['mobile_no'],
        region = json['region_name'],
        thfrancode = json['th_franchies_code'],
        refcode = json['ref_code'],
        entrydate = json['entry_date'],
        password = json['password'],
        imgpath = json['imgpath'],
        permission = json['permission'],
        ratetable = json['rate_table'];

  Map toJson() => {
        'id': id,
        'userid': userid,
        'username': username,
        'name': name,
        'mobileno': mobileno,
        'region': region,
        'thfrancode': thfrancode,
        'refcode': refcode,
        'entrydate': entrydate,
        'password': password,
        'imgpath': imgpath,
        'permission': permission,
        'ratetable': ratetable
      };
}

class Note {
  String code;
  String title;
  String description;
  String price;
  String imgpath;
  String basePrice;

  Note(this.title, this.price, this.imgpath, this.code, this.description,
      this.basePrice);

  Note.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['product'];
    description = json['second_title'];
    price = json['price'];
    imgpath = json['img_file'];
    basePrice = json['basePrice'];
  }
}

class Cart {
  String code, name, imgpath, price, qty, baseprice;

  Cart(
      this.code, this.name, this.imgpath, this.price, this.qty, this.baseprice);
}

List cartlist = [];
String users;
FinalPayment ff;

class FinalPayment {
  String totalitems, grosstotal, discountper, discountamt, gst, netamt;

  FinalPayment(
      {this.totalitems,
      this.grosstotal,
      this.discountper,
      this.discountamt,
      this.gst,
      this.netamt});
}
