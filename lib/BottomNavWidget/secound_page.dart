// ignore_for_file: avoid_print
import 'package:badges/badges.dart';
import 'package:davinshi_app/dbhelper.dart';
import 'package:davinshi_app/elements/newtwork_image.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/screens/product_info/products.dart';
import 'package:provider/provider.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/products_cla.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/provider/fav_pro.dart';
import 'package:davinshi_app/screens/cart/cart.dart';

// ignore: use_key_in_widget_constructors
class SecPage extends StatefulWidget {
  @override
  _SecPageState createState() => _SecPageState();
}

class _SecPageState extends State<SecPage> {
  ScrollController controller = ScrollController();
  bool mask = false;
  bool f1 = true;
  bool fi1 = true, finish = false;
  void start(context) async {
    var of1 = Provider.of<FavItemProvider>(context, listen: true);
    controller.addListener(() {
      if (controller.position.atEdge) {
        if (controller.position.pixels != 0) {
          if (f1) {
            if (!of1.finish) {
              f1 = false;
              dialog(context);
              of1.getItems().then((value) {
                Navigator.pop(context);
                f1 = true;
              });
            }
          }
        }
      }
      if (controller.position.pixels > 400.0 && mask == false) {
        setState(() {
          mask = true;
        });
        // scroll.changeShow(1, true);
      }
      if (controller.position.pixels < 400.0 && mask == true) {
        setState(() {
          mask = false;
        });
        // scroll.changeShow(1, false);
      }
    });
  }

  DbHelper helper = DbHelper();

  List<int> att = [];
  List<String> des = [];
  int quantity = 0;

  var currency = (prefs.getString('language_code').toString() == 'en')
      ? prefs.getString('currencyEn').toString()
      : prefs.getString('currencyAr').toString();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    CartProvider cart = Provider.of<CartProvider>(context, listen: true);
    if (!finish) {
      start(context);
      finish = true;
    }
    Provider.of<FavItemProvider>(context, listen: true).getItems();
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Directionality(
        textDirection: getDirection(),
        child: DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                translate(context, 'page_two', 'title'),
                style: TextStyle(color: Colors.white, fontSize: w * 0.04),
              ),
              centerTitle: true,
              backgroundColor: mainColor,
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: w * 0.01),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Badge(
                      badgeColor: const Color(0xffFF0921),
                      child: IconButton(
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.zero,
                        focusColor: Colors.white,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Cart()));
                        },
                      ),
                      animationDuration: const Duration(
                        seconds: 2,
                      ),
                      badgeContent: Text(
                        cart.items.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.03,
                        ),
                      ),
                      position: BadgePosition.topStart(start: w * 0.007),
                    ),
                  ),
                ),
                if (login)
                  SizedBox(
                    width: w * 0.05,
                  ),
                // if (login)
                //   IconButton(
                //     icon: const Icon(Icons.location_on_outlined),
                //     iconSize: w * 0.06,
                //     color: Colors.white,
                //     padding: EdgeInsets.zero,
                //     onPressed: () {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (ctx) => Address()));
                //     },
                //   ),
              ],
            ),
            body: SizedBox(
              width: w,
              height: h,
              child: Stack(
                children: [
                  SizedBox(
                    width: w,
                    height: h,
                    child: Padding(
                      padding: EdgeInsets.all(w * 0.025),
                      child: SingleChildScrollView(
                        controller: controller,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Consumer<FavItemProvider>(
                              builder: (context, item, _) {
                                return DropdownButton<String>(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  iconEnabledColor: mainColor,
                                  iconDisabledColor: mainColor,
                                  iconSize: w * 0.08,
                                  hint: Text(
                                      translate(context, 'page_two', 'sort')),
                                  items:
                                      List.generate(item.sorts.length, (index) {
                                    return DropdownMenuItem(
                                      value: item.sorts[index],
                                      child: Column(
                                        children: [
                                          Text(
                                            (prefs.getString('language_code') ==
                                                    'en')
                                                ? item.sorts[index]
                                                : item.sortsAr[index],
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          Divider(
                                            color: mainColor,
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        item.sortList(index);
                                      },
                                    );
                                  }),
                                  onChanged: (val) {},
                                  value: item.sort,
                                );
                              },
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            SizedBox(
                              width: w,
                              child: Consumer<FavItemProvider>(
                                  builder: (context, item, _) {
                                if (item.items.isEmpty) {
                                  return SizedBox(
                                    width: w,
                                    height: h * 0.5,
                                    child: Center(
                                      child: Text(
                                        translate(
                                            context, 'empty', 'no_favorite'),
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: w * 0.05),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Wrap(
                                    children:
                                        List.generate(item.items.length, (i) {
                                      return InkWell(
                                        child: Padding(
                                          padding: isLeft()
                                              ? EdgeInsets.only(
                                                  right: w * 0.025,
                                                  bottom: h * 0.02)
                                              : EdgeInsets.only(
                                                  left: w * 0.025,
                                                  bottom: h * 0.02),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Stack(
                                                children: [
                                                  ImageeNetworkWidget(
                                                    fit: BoxFit.cover,
                                                    image: item.items[i].image
                                                        .toString(),
                                                    width: w * 0.45,
                                                    height: h * 0.28,
                                                  ),
                                                  // (item.items[i].isOrder == 1)
                                                  //     ? Container(
                                                  //         height: h * 0.04,
                                                  //         width: w * 0.22,
                                                  //         margin: EdgeInsets
                                                  //             .symmetric(
                                                  //                 horizontal:
                                                  //                     w * 0.01,
                                                  //                 vertical:
                                                  //                     h * 0.01),
                                                  //         decoration:
                                                  //             BoxDecoration(
                                                  //           color: mainColor,
                                                  //           borderRadius:
                                                  //               BorderRadius
                                                  //                   .circular(w *
                                                  //                       0.02),
                                                  //         ),
                                                  //         child: Center(
                                                  //           child: Text(
                                                  //             translateString(
                                                  //                 "Order",
                                                  //                 "علي الطلب"),
                                                  //             style: TextStyle(
                                                  //                 fontFamily:
                                                  //                     'Tajawal',
                                                  //                 fontSize:
                                                  //                     w * 0.04,
                                                  //                 color: Colors
                                                  //                     .white,
                                                  //                 fontWeight:
                                                  //                     FontWeight
                                                  //                         .w500),
                                                  //           ),
                                                  //         ),
                                                  //       )
                                                  //     : const SizedBox(),
                                                ],
                                              ),
                                              SizedBox(
                                                width: w * 0.45,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: h * 0.01,
                                                    ),
                                                    Container(
                                                        constraints:
                                                            BoxConstraints(
                                                          maxHeight: h * 0.07,
                                                        ),
                                                        child: Text(
                                                            translateString(
                                                                item.items[i]
                                                                    .nameEn
                                                                    .toString(),
                                                                item.items[i]
                                                                    .nameAr
                                                                    .toString()),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    w * 0.035),
                                                            overflow:
                                                                TextOverflow
                                                                    .fade)),
                                                    SizedBox(
                                                      height: h * 0.005,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              if (item.items[i]
                                                                  .isSale)
                                                                TextSpan(
                                                                    text: getProductprice(
                                                                        currency:
                                                                            currency,
                                                                        productPrice: item
                                                                            .items[
                                                                                i]
                                                                            .salePrice!),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Tajawal',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color:
                                                                            mainColor)),
                                                              if (!item.items[i]
                                                                  .isSale)
                                                                TextSpan(
                                                                    text: getProductprice(
                                                                        currency:
                                                                            currency,
                                                                        productPrice: item
                                                                            .items[
                                                                                i]
                                                                            .price),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Tajawal',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color:
                                                                            mainColor)),
                                                            ],
                                                          ),
                                                        ),
                                                        if (item
                                                            .items[i].isSale)
                                                          Text(
                                                            getProductprice(
                                                                currency:
                                                                    currency,
                                                                productPrice:
                                                                    item
                                                                        .items[
                                                                            i]
                                                                        .price),
                                                            style: TextStyle(
                                                              fontSize:
                                                                  w * 0.035,
                                                              decorationThickness:
                                                                  w * 0.1,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              decorationColor:
                                                                  mainColor,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () async {
                                          // await getItem(item.items[i].id);
                                          // Navigator.pushNamed(context, 'pro');
                                          navP(
                                              context,
                                              Products(
                                                fromFav: true,
                                                productId: item.items[i].id,
                                                brandId:
                                                    item.items[i].brands![i].id,
                                              ));
                                        },
                                      );
                                    }),
                                  );
                                }
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  mask
                      ? Positioned(
                          bottom: h * 0.03,
                          right: w * 0.08,
                          child: CircleAvatar(
                            radius: w * 0.06,
                            backgroundColor: mainColor.withOpacity(0.7),
                            child: InkWell(
                              child: const Center(
                                  child: Icon(
                                Icons.arrow_upward_outlined,
                                color: Colors.white,
                              )),
                              onTap: () {
                                controller.animateTo(0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(''),
            content: Text(translate(context, 'home', 'ok_mess')),
            actions: [
              // ignore: deprecated_member_use
              RaisedButton(
                color: mainColor,
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  translate(context, 'home', 'no'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                color: mainColor,
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  translate(context, 'home', 'yes'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
