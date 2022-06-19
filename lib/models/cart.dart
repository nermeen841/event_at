// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:convert';
import '../dbhelper.dart';

DbHelper dbHelper = DbHelper();

class CartProducts {
  int? id;
  int idp;
  int idc;
  int productquantity;
  int studentId;
  // int isOrder;
  String image;
  String catSVG;
  String titleAr;
  String titleEn;
  String catNameAr;
  String catNameEn;
  num price;
  int quantity;
  List<int> att;
  List<int> productOptions;
  List<String> des;
  CartProducts(
      {required this.catSVG,
      // required this.isOrder,
      required this.productquantity,
      required this.idc,
      required this.productOptions,
      required this.catNameAr,
      required this.catNameEn,
      required this.id,
      required this.studentId,
      required this.image,
      required this.titleAr,
      required this.titleEn,
      required this.price,
      required this.quantity,
      required this.att,
      required this.des,
      required this.idp});
  Map<String, dynamic> toMap() => {
        'id': id,
        'idp': idp,
        'productquantity': productquantity,
        // 'isOrder': isOrder,
        'studentId': studentId,
        'image': image,
        'titleAr': titleAr,
        'titleEn': titleEn,
        'price': price,
        'quantity': quantity,
        'att': jsonEncode(att),
        'des': jsonEncode(des),
        'product_options': jsonEncode(productOptions),
        'idc': idc,
        'svg': catSVG,
        'catNameAr': catNameAr,
        'catNameEn': catNameEn
      };
  CartProducts fromMap(Map<String, dynamic> map) {
    return CartProducts(
      id: map['id'],
      productquantity: map['productquantity'],
      studentId: map['studentId'],
      image: map['image'],
      titleAr: map['titleAr'],
      titleEn: map['titleEn'],
      price: map['price'],
      quantity: map['quantity'],
      att: map['att'],
      des: map['des'],
      productOptions: map['product_options'],
      idp: map['idp'],
      idc: map['idc'],
      catNameAr: map['catNameAr'],
      catNameEn: map['catNameEn'],
      catSVG: map['svg'],
      // isOrder: map['isOrder'],
    );
  }

  static List<CartProducts> listFromMap(List<Map<String, dynamic>> list) {
    List<CartProducts> _list = [];
    list.forEach((map) {
      List<int> _int = [];
      List<int> _options = [];
      jsonDecode(map['att']).forEach((e) {
        _int.add(e);
      });
      jsonDecode(map['product_options']).forEach((e) {
        _options.add(e);
      });
      List<String> _string = [];
      jsonDecode(map['des']).forEach((e) {
        _string.add(e);
      });
      _list.add(CartProducts(
        id: map['id'],
        productquantity: map['productquantity'],
        studentId: map['studentId'],
        image: map['image'],
        titleAr: map['titleAr'],
        titleEn: map['titleEn'],
        price: map['price'],
        quantity: map['quantity'],
        productOptions: _options,
        att: _int,
        des: _string,
        idp: map['idp'],
        idc: map['idc'],
        catNameAr: map['catNameAr'],
        catNameEn: map['catNameEn'],
        catSVG: map['svg'],
        // isOrder: map['isOrder'],
      ));
    });
    return _list;
  }
}

int? cartId;

class CartClass {
  String nameAr;
  String nameEn;
  String svg;
  List<CartProducts> cartPro;
  CartClass(
      {required this.nameAr,
      required this.nameEn,
      required this.svg,
      required this.cartPro});
}
