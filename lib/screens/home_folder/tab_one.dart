// ignore_for_file: unnecessary_string_interpolations, avoid_print, use_key_in_widget_constructors

import 'package:davinshi_app/dbhelper.dart';
import 'package:davinshi_app/elements/newtwork_image.dart';
import 'package:davinshi_app/models/rate.dart';
import 'package:davinshi_app/screens/home_folder/more/more.dart';
import 'package:davinshi_app/screens/student/view_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/cat.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/home_item.dart';
import 'package:davinshi_app/models/products_cla.dart';
import 'package:davinshi_app/provider/CatProvider.dart';
import 'package:davinshi_app/provider/package_provider.dart';
import 'package:davinshi_app/screens/multiple_packages.dart';
import 'package:davinshi_app/screens/student/student_info.dart';
import 'package:davinshi_app/screens/sub_categories_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../BottomNavWidget/third_page.dart';
import '../../provider/student_product.dart';
import '../../provider/student_provider.dart';
import '../product_info/products.dart';

class TabOne extends StatefulWidget {
  @override
  _TabOneState createState() => _TabOneState();
}

class _TabOneState extends State<TabOne> with SingleTickerProviderStateMixin {
  DbHelper helper = DbHelper();
  List<Rate> rate = [];
  List<int> att = [];
  List<String> des = [];
  double stars = 5.0;
  String rating = '';
  bool check = false, error = false;
  bool finish = false;
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var currency = (prefs.getString('language_code').toString() == 'en')
        ? prefs.getString('currencyEn').toString()
        : prefs.getString('currencyAr').toString();
    CatProvider catProvider = Provider.of<CatProvider>(context, listen: false);
    return Consumer<HomeProvider>(builder: ((context, value, child) {
      return WillPopScope(
        onWillPop: showExitPopup,
        child: Container(
          width: w,
          height: h,
          color: Colors.white,
          child: Stack(
            children: [
              SizedBox(
                width: w,
                height: h,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (slider.isNotEmpty)
                        SizedBox(
                          width: w,
                          height: h * 0.3,
                          child: Swiper(
                            pagination: SwiperPagination(
                                builder: DotSwiperPaginationBuilder(
                                    color: mainColor.withOpacity(0.3),
                                    activeColor: mainColor),
                                alignment: Alignment.bottomCenter),
                            itemBuilder: (BuildContext context, int i) {
                              return InkWell(
                                child: ImageeNetworkWidget(
                                  fit: BoxFit.cover,
                                  image: slider[i].image,
                                  width: w,
                                  height: h * 0.3,
                                ),
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                // overlayColor: ,
                                onTap: () async {
                                  if (slider[i].inApp) {
                                    if (slider[i].type) {
                                      navP(
                                          context,
                                          Products(
                                            fromFav: false,
                                            productId:
                                                int.parse(slider[i].link),
                                          ));
                                    } else {
                                      dialog(context);
                                      Provider.of<NewPackageItemProvider>(
                                              context,
                                              listen: false)
                                          .clearList();
                                      Provider.of<RePackageItemProvider>(
                                              context,
                                              listen: false)
                                          .clearList();
                                      Provider.of<BestPackageItemProvider>(
                                              context,
                                              listen: false)
                                          .clearList();
                                      await Provider.of<RePackageItemProvider>(
                                              context,
                                              listen: false)
                                          .getItems(int.parse(slider[i].link));
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  MultiplePackages(
                                                    id: int.parse(
                                                        slider[i].link),
                                                  )));
                                    }
                                  } else {
                                    await canLaunch(slider[i].link)
                                        ? await launch(slider[i].link)
                                        : throw 'Could not launch ${slider[i].link}';
                                  }
                                },
                              );
                            },
                            itemCount: slider.length,
                            autoplay: true,
                            autoplayDelay: 5000,
                          ),
                        ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      if (getAds(1).isNotEmpty)
                        SizedBox(
                          height: h * 0.08,
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: w * 0.025),
                            child: Swiper(
                              itemCount: getAds(1).length,
                              itemBuilder: (BuildContext context, int i) {
                                Ads _ads = getAds(1)[i];
                                return InkWell(
                                  child: ImageeNetworkWidget(
                                    fit: BoxFit.cover,
                                    width: w * 0.95,
                                    height: h * 0.08,
                                    image: _ads.image,
                                  ),
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (_ads.inApp) {
                                      if (_ads.type) {
                                        navP(
                                            context,
                                            Products(
                                              fromFav: false,
                                              productId: int.parse(_ads.link),
                                            ));
                                      } else {
                                        dialog(context);
                                        Provider.of<NewPackageItemProvider>(
                                                context,
                                                listen: false)
                                            .clearList();
                                        Provider.of<RePackageItemProvider>(
                                                context,
                                                listen: false)
                                            .clearList();
                                        Provider.of<BestPackageItemProvider>(
                                                context,
                                                listen: false)
                                            .clearList();
                                        await Provider.of<
                                                    RePackageItemProvider>(
                                                context,
                                                listen: false)
                                            .getItems(int.parse(_ads.link));
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    MultiplePackages(
                                                      id: int.parse(_ads.link),
                                                    )));
                                      }
                                    } else {
                                      await canLaunch(_ads.link)
                                          ? await launch(_ads.link)
                                          : throw 'Could not launch ${_ads.link}';
                                    }
                                  },
                                );
                              },
                              autoplay: true,
                              autoplayDelay: 5000,
                            ),
                          ),
                        ),
                      (getAds(1).isNotEmpty)
                          ? SizedBox(
                              height: h * 0.03,
                            )
                          : const SizedBox(),
SizedBox(
                        height: h * 0.015,
                      ),
  Container(
                        width: w,
                        color: Colors.white,
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: w * 0.025),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      width: w * 0.6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            translate(context, 'home', 'brand'),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.05,
                                                fontFamily: 'Tajawal',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // Divider(
                                          //   color: mainColor,
                                          //   thickness: 3,
                                          //   endIndent:
                                          //       (language == 'ar') ? 50 : 90,
                                          // ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: w * 0.01,
                                    ),
                                    InkWell(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(w * 0.025),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: w * 0.2,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            w * 0.02),
                                                    color: mainColor),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: w * 0.02,
                                                    vertical: h * 0.01),
                                                child: Center(
                                                  child: Text(
                                                    translate(
                                                        context, 'home', 'see'),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: w * 0.05,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        dialog(context);
                                        Provider.of<StudentProvider>(context,
                                                listen: false)
                                            .clearList();
                                        // Provider.of<StudentProvider>(context,
                                        //         listen: false)
                                        // .getStudents()
                                        // .whenComplete(() {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ViewAll()));
                                        // });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: h * 0.03,
                              ),
                              SizedBox(
                                width: w,
                                height: h * 0.2,
                                child: ListView.builder(
                                  itemCount: stu.length,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) {
                                    return InkWell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: w * 0.01),
                                        child: Container(
                                          width: w * 0.3,
                                          height: h * 0.09,
                                          margin: EdgeInsets.only(top:h*0.02, bottom: h*0.01),
                                          decoration: BoxDecoration(   
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      stu[i].image ?? ''),
                                                  fit: BoxFit.cover),
                                             
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 3,
                                                    spreadRadius: 3,
                                                    offset: const Offset(0, 3),
                                                    color: Colors.grey
                                                        .withOpacity(0.1))
                                              ]),
                                        ),
                                      ),
                                      onTap: () async {
                                        Provider.of<StudentItemProvider>(
                                                context,
                                                listen: false)
                                            .clearList();

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StudentInfo(
                                                      studentClass: stu[i],
                                                      studentId: stu[i].id,
                                                    )));
                                        // });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      





                      Container(
                        width: w,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: h * 0.01,
                              bottom: h * 0.01,
                              right: w * 0.02,
                              left: w * 0.02),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: Colors.white,
                                    width: w * 0.7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          translate(context, 'home', 'cat'),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.05,
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // Divider(
                                        //   color: mainColor,
                                        //   thickness: 3,
                                        //   endIndent:
                                        //       (language == 'ar') ? 100 : 150,
                                        // )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(w * 0.025),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: w * 0.2,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          w * 0.02),
                                                  color: mainColor),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: w * 0.02,
                                                  vertical: h * 0.01),
                                              child: Center(
                                                child: Text(
                                                  translate(
                                                      context, 'home', 'see'),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: w * 0.045,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      dialog(context);
                                      // await catProvider
                                      //     .getParentCat()
                                      //     .then((value) {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ThirdPage(),
                                          ));
                                      // });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: h * 0.02,
                              ),
                              catProvider.categories.isNotEmpty
                                  ? SizedBox(
                                      width: w,
                                      // height: h * 0.3,
                                      child: GridView.builder(
                                          gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: h * 0.03,
                                        mainAxisSpacing: w * 0.01,
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.9),
                                      primary: false,
                                       shrinkWrap: true,
                                        itemCount:
                                            catProvider.categories.length,
                                        // scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.grey
                                                        .withOpacity(0.2)),
                                                alignment: Alignment.center,
                                                child: InkWell(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width: w * 0.9,
                                                        height: h * 0.25,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          // image: DecorationImage(
                                                          //     image: NetworkImage(
                                                          //       "${catProvider.categories[index].image}",
                                                          //     ),
                                                          //     fit: BoxFit.cover),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child:
                                                              ImageeNetworkWidget(
                                                            fit: BoxFit.cover,
                                                            image: catProvider
                                                                .categories[
                                                                    index]
                                                                .image,
                                                            width: w * 0.9,
                                                            height: h * 0.25,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: w * 0.9,
                                                        height: h * 0.25,
                                                        decoration:
                                                            BoxDecoration(
                                                         gradient: const LinearGradient(
                                                           end: Alignment.topCenter,
                                                           begin: Alignment.bottomCenter,
                                                          colors: [
                                                           Colors.black,
                                                          //  Colors.black.withOpacity(0.5),
                                                          //  Colors.black.withOpacity(0.3),
                                                          //  Colors.black.withOpacity(0.2),
                                                          //  Colors.black.withOpacity(0.1),
                                                           Colors.transparent,
                                                           Colors.transparent,

                                                         ],
                                                         ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .only(
                                                            bottomLeft: Radius
                                                                .circular(
                                                                    w * 0.04),
                                                            bottomRight: Radius
                                                                .circular(
                                                                    w * 0.04),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:  EdgeInsets.only(top: h*0.18),
                                                          child: Center(
                                                            child: Text(
                                                              prefs
                                                                          .getString(
                                                                              'language_code')
                                                                          .toString() ==
                                                                      'en'
                                                                  ? catProvider
                                                                      .categories[
                                                                          index]
                                                                      .nameEn
                                                                  : catProvider
                                                                      .categories[
                                                                          index]
                                                                      .nameAr,
                                                              maxLines: 3,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: w *
                                                                      0.045),
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    print(catProvider
                                                        .categories[index]
                                                        .subCategories
                                                        .length);
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            SubCategoriesScreen(
                                                                subcategoriesList:
                                                                    catProvider
                                                                        .categories[
                                                                            index]
                                                                        .subCategories)));
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        // separatorBuilder: (context, index) =>
                                        //     SizedBox(
                                        //   width: w * 0.03,
                                        // ),
                                      ),
                                    )
                                  : FutureBuilder(
                                      future: catProvider.getParentCat(),
                                      builder: (context,
                                          AsyncSnapshot<List<Category>>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          return SizedBox(
                                            width: w,
                                            // height: h * 0.3,
                                            child: GridView.builder(
                                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: h * 0.03,
                                        mainAxisSpacing: w * 0.01,
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.9),
                                      primary: false,
                                       shrinkWrap: true,
                                              itemCount:
                                                  catProvider.categories.length,
                              
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.2)),
                                                      alignment:
                                                          Alignment.center,
                                                      child: InkWell(
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              width: w * 0.9,
                                                    height: h * 0.25,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                // image:
                                                                //     DecorationImage(
                                                                //         image:
                                                                //             NetworkImage(
                                                                //           "${catProvider.categories[index].image}",
                                                                //         ),
                                                                //         fit: BoxFit
                                                                //             .cover),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child:
                                                                    ImageeNetworkWidget(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: catProvider
                                                                      .categories[
                                                                          index]
                                                                      .image,
                                                                  width:
                                                                      w * 0.9,
                                                                  height:
                                                                      h * 0.25,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                               width: w * 0.9,
                                                   
                                                              height:
                                                                  h * 0.25,
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient: const LinearGradient(
                                                           end: Alignment.topCenter,
                                                           begin: Alignment.bottomCenter,
                                                          colors: [
                                                           Colors.black,
                                                          //  Colors.black.withOpacity(0.5),
                                                          //  Colors.black.withOpacity(0.3),
                                                          //  Colors.black.withOpacity(0.2),
                                                          //  Colors.black.withOpacity(0.1),
                                                           Colors.transparent,
                                                           Colors.transparent,

                                                         ],
                                                         ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft:
                                                                      Radius.circular(w *
                                                                          0.04),
                                                                  bottomRight:
                                                                      Radius.circular(w *
                                                                          0.04),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:  EdgeInsets.only(top: h*0.17),
                                                                child: Center(
                                                                  child: Text(
                                                                    prefs.getString('language_code').toString() ==
                                                                            'en'
                                                                        ? catProvider
                                                                            .categories[
                                                                                index]
                                                                            .nameEn
                                                                        : catProvider
                                                                            .categories[index]
                                                                            .nameAr,
                                                                    maxLines: 3,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            w * 0.045),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        onTap: () async {
                                                          print(catProvider
                                                              .categories[index]
                                                              .subCategories
                                                              .length);
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => SubCategoriesScreen(
                                                                  subcategoriesList: catProvider
                                                                      .categories[
                                                                          index]
                                                                      .subCategories)));
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              // separatorBuilder:
                                              //     (context, index) => SizedBox(
                                              //   width: w * 0.03,
                                              // ),
                                            ),
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator(
                                              color: mainColor,
                                              backgroundColor: mainColor2,
                                            ),
                                          );
                                        } else {
                                          return const Text(
                                            "",
                                            style: TextStyle(color: Colors.red),
                                          );
                                        }
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ),
                      // if (subCat.isNotEmpty)
                      //   SizedBox(
                      //     height: h * 0.01,
                      //   ),
                      // if (offerEnd.isNotEmpty)
                      //   Column(
                      //     children: [
                      //       Padding(
                      //         padding:
                      //             EdgeInsets.symmetric(horizontal: w * 0.025),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text(
                      //               translate(context, 'home', 'title1'),
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: w * 0.045,
                      //                   fontFamily: 'Tajawal'),
                      //             ),
                      //             InkWell(
                      //               onTap: () => Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           const MoreScreen(
                      //                               endPoint:
                      //                                   "get-offer-products"))),
                      //               child: Container(
                      //                 width: w * 0.2,
                      //                 decoration: BoxDecoration(
                      //                     borderRadius:
                      //                         BorderRadius.circular(w * 0.02),
                      //                     color: mainColor),
                      //                 padding: EdgeInsets.symmetric(
                      //                     horizontal: w * 0.02,
                      //                     vertical: h * 0.01),
                      //                 child: Center(
                      //                   child: Text(
                      //                     translate(context, 'home', 'see'),
                      //                     style: TextStyle(
                      //                         color: Colors.white,
                      //                         fontSize: w * 0.05,
                      //                         fontWeight: FontWeight.bold),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: h * 0.01,
                      //       ),
                      //       SizedBox(
                      //         width: w,
                      //         // height: h * 0.9,
                      //         child: GridView.builder(
                      //           itemCount: offerEnd.length,
                      //           primary: false,
                      //           shrinkWrap: true,
                      //           // scrollDirection: Axis.horizontal,
                      //           itemBuilder: (ctx, i) {
                      //             return InkWell(
                      //               child: Padding(
                      //                 padding: isLeft()
                      //                     ? EdgeInsets.only(left: w * 0.025)
                      //                     : EdgeInsets.only(right: w * 0.025),
                      //                 child: Column(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: [
                      //                     Container(
                      //                       width: w * 0.4,
                      //                       height: h * 0.25,
                      //                       decoration: BoxDecoration(
                      //                           color: Colors.white,
                      //                           image: DecorationImage(
                      //                             image: NetworkImage(
                      //                                 offerEnd[i].image),
                      //                             fit: BoxFit.fitHeight,
                      //                           )),
                      //                       child: Padding(
                      //                         padding: EdgeInsets.all(w * 0.015),
                      //                         child: Align(
                      //                           alignment: isLeft()
                      //                               ? Alignment.bottomLeft
                      //                               : Alignment.bottomRight,
                      //                           child: InkWell(
                      //                             onTap: () async {
                      //                               if (cartId == null ||
                      //                                   cartId == studentId) {
                      //                                 try {
                      //                                   if (!cart.idp.contains(
                      //                                       offerEnd[i].id)) {
                      //                                     await helper.createCar(
                      //                                         CartProducts(
                      //                                             id: null,
                      //                                             studentId:
                      //                                                 studentId,
                      //                                             image:
                      //                                                 offerEnd[i]
                      //                                                     .image,
                      //                                             titleAr:
                      //                                                 offerEnd[i]
                      //                                                     .nameAr,
                      //                                             titleEn:
                      //                                                 offerEnd[i]
                      //                                                     .nameEn,
                      //                                             price: offerEnd[
                      //                                                     i]
                      //                                                 .finalPrice
                      //                                                 .toDouble(),
                      //                                             quantity: 1,
                      //                                             att: att,
                      //                                             des: des,
                      //                                             idp: offerEnd[i]
                      //                                                 .id,
                      //                                             idc: 0,
                      //                                             catNameEn: "",
                      //                                             catNameAr: "",
                      //                                             catSVG: ""));
                      //                                   } else {
                      //                                     int quantity = cart
                      //                                         .items
                      //                                         .firstWhere(
                      //                                             (element) =>
                      //                                                 element
                      //                                                     .idp ==
                      //                                                 offerEnd[i]
                      //                                                     .id)
                      //                                         .quantity;
                      //                                     await helper
                      //                                         .updateProduct(
                      //                                             1 + quantity,
                      //                                             offerEnd[i].id,
                      //                                             offerEnd[i]
                      //                                                 .finalPrice
                      //                                                 .toDouble(),
                      //                                             jsonEncode(att),
                      //                                             jsonEncode(
                      //                                                 des));
                      //                                   }
                      //                                   await cart.setItems();
                      //                                 } catch (e) {
                      //                                   // error(context);
                      //                                   print('e');
                      //                                   print(e);
                      //                                 }
                      //                               } else {
                      //                                 if (cartId == null ||
                      //                                     cartId == studentId) {
                      //                                   try {
                      //                                     if (!cart.idp.contains(
                      //                                         offerEnd[i].id)) {
                      //                                       await helper.createCar(CartProducts(
                      //                                           id: null,
                      //                                           studentId:
                      //                                               offerEnd[i]
                      //                                                   .brands![
                      //                                                       i]
                      //                                                   .id,
                      //                                           image: offerEnd[i]
                      //                                               .image,
                      //                                           titleAr: offerEnd[
                      //                                                   i]
                      //                                               .nameAr,
                      //                                           titleEn:
                      //                                               offerEnd[i]
                      //                                                   .nameEn,
                      //                                           price: offerEnd[i]
                      //                                               .price
                      //                                               .toDouble(),
                      //                                           quantity: 1,
                      //                                           att: att,
                      //                                           des: des,
                      //                                           idp: offerEnd[i]
                      //                                               .id,
                      //                                           idc: offerEnd[i]
                      //                                               .id,
                      //                                           catNameEn: "",
                      //                                           catNameAr: "",
                      //                                           catSVG: ""));
                      //                                     } else {
                      //                                       int quantity = cart
                      //                                           .items
                      //                                           .firstWhere(
                      //                                               (element) =>
                      //                                                   element
                      //                                                       .idp ==
                      //                                                   offerEnd[
                      //                                                           i]
                      //                                                       .id)
                      //                                           .quantity;
                      //                                       await helper
                      //                                           .updateProduct(
                      //                                               1 + quantity,
                      //                                               offerEnd[i]
                      //                                                   .id,
                      //                                               offerEnd[i]
                      //                                                   .finalPrice
                      //                                                   .toDouble(),
                      //                                               jsonEncode(
                      //                                                   att),
                      //                                               jsonEncode(
                      //                                                   des));
                      //                                     }
                      //                                     await cart.setItems();
                      //                                   } catch (e) {
                      //                                     print('e');
                      //                                     print(e);
                      //                                   }
                      //                                 } else {}
                      //                               }
                      //                             },
                      //                             child: CircleAvatar(
                      //                               backgroundColor: mainColor,
                      //                               radius: w * .05,
                      //                               child: Center(
                      //                                 child: Icon(
                      //                                   Icons
                      //                                       .shopping_cart_outlined,
                      //                                   color: Colors.white,
                      //                                   size: w * 0.05,
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: w * 0.4,
                      //                       child: Column(
                      //                         mainAxisSize: MainAxisSize.min,
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           SizedBox(
                      //                             height: h * 0.01,
                      //                           ),
                      //                           Row(
                      //                             children: [
                      //                               Container(
                      //                                   constraints:
                      //                                       BoxConstraints(
                      //                                           maxHeight:
                      //                                               h * 0.07,
                      //                                           maxWidth:
                      //                                               w * 0.35),
                      //                                   child: Text(
                      //                                       translateString(
                      //                                           offerEnd[i]
                      //                                               .nameEn,
                      //                                           offerEnd[i]
                      //                                               .nameAr),
                      //                                       maxLines: 2,
                      //                                       style: TextStyle(
                      //                                           fontSize:
                      //                                               w * 0.035),
                      //                                       overflow: TextOverflow
                      //                                           .fade)),
                      //                               // const SizedBox(
                      //                               //   width: 7,
                      //                               // ),
                      //                               // if (offerEnd[i].isSale &&
                      //                               //     offerEnd[i].disPer !=
                      //                               //         null)
                      //                               //   Text(
                      //                               //       offerEnd[i].disPer! +
                      //                               //           '%',
                      //                               //       style: const TextStyle(
                      //                               //           fontWeight:
                      //                               //               FontWeight.bold,
                      //                               //           color: Colors.red)),
                      //                             ],
                      //                           ),
                      //                           SizedBox(
                      //                             height: h * 0.005,
                      //                           ),
                      //                           Row(
                      //                             crossAxisAlignment:
                      //                                 CrossAxisAlignment.start,
                      //                             mainAxisAlignment:
                      //                                 MainAxisAlignment
                      //                                     .spaceBetween,
                      //                             children: [
                      //                               RichText(
                      //                                 text: TextSpan(
                      //                                   children: [
                      //                                     if (offerEnd[i].isSale)
                      //                                       TextSpan(
                      //                                           text:
                      //                                               '${offerEnd[i].salePrice} $currency',
                      //                                           style: const TextStyle(
                      //                                               fontFamily:
                      //                                                   'Tajawal',
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               color: Colors
                      //                                                   .black)),
                      //                                     if (!offerEnd[i].isSale)
                      //                                       TextSpan(
                      //                                           text:
                      //                                               '${offerEnd[i].price} $currency',
                      //                                           style: const TextStyle(
                      //                                               fontFamily:
                      //                                                   'Tajawal',
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               color: Colors
                      //                                                   .black)),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                               if (offerEnd[i].isSale)
                      //                                 Text(
                      //                                   '${offerEnd[i].price} $currency',
                      //                                   style: TextStyle(
                      //                                     fontSize: w * 0.035,
                      //                                     decorationColor:
                      //                                         mainColor,
                      //                                     decorationThickness:
                      //                                         w * 0.1,
                      //                                     decoration:
                      //                                         TextDecoration
                      //                                             .lineThrough,
                      //                                     color: Colors.grey,
                      //                                   ),
                      //                                 ),
                      //                             ],
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               onTap: () async {
                      //                 dialog(context);
                      //                 await getItem(offerEnd[i].id);
                      //                 Navigator.pushReplacementNamed(
                      //                     context, 'pro');
                      //               },
                      //             );
                      //           },
                      //           gridDelegate:
                      //               SliverGridDelegateWithFixedCrossAxisCount(
                      //                   crossAxisSpacing: h * 0.01,
                      //                   mainAxisSpacing: w * 0.01,
                      //                   crossAxisCount: 2,
                      //                   childAspectRatio: 0.7),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // if (checkPosition(1))
                      //   SizedBox(
                      //     height: h * 0.01,
                      //   ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      // if (newItem.isNotEmpty)
                      //   Column(
                      //     children: [
                      //       Padding(
                      //         padding:
                      //             EdgeInsets.symmetric(horizontal: w * 0.025),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Container(
                      //               width: w * 0.6,
                      //               color: Colors.white,
                      //               child: Column(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   Text(
                      //                     translate(context, 'home', 'title2'),
                      //                     style: TextStyle(
                      //                         fontWeight: FontWeight.bold,
                      //                         fontSize: w * 0.05,
                      //                         fontFamily: 'Tajawal'),
                      //                   ),
                      //                   Divider(
                      //                     color: mainColor,
                      //                     thickness: 3,
                      //                     endIndent:
                      //                         (language == 'ar') ? 30 : 100,
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //             SizedBox(
                      //               width: w * 0.03,
                      //             ),
                      //             InkWell(
                      //               child: Container(
                      //                 decoration: const BoxDecoration(
                      //                   color: Colors.transparent,
                      //                 ),
                      //                 child: Padding(
                      //                   padding: EdgeInsets.all(w * 0.025),
                      //                   child: Row(
                      //                     children: [
                      //                       InkWell(
                      //                         onTap: () {
                      //                           Navigator.push(
                      //                               context,
                      //                               MaterialPageRoute(
                      //                                   builder: (context) =>
                      //                                       const MoreScreen(
                      //                                         endPoint:
                      //                                             "get-new-products",
                      //                                       )));
                      //                         },
                      //                         child: Container(
                      //                           width: w * 0.2,
                      //                           decoration: BoxDecoration(
                      //                               borderRadius:
                      //                                   BorderRadius.circular(
                      //                                       w * 0.02),
                      //                               color: mainColor),
                      //                           padding: EdgeInsets.symmetric(
                      //                               horizontal: w * 0.02,
                      //                               vertical: h * 0.01),
                      //                           child: Center(
                      //                             child: Text(
                      //                               translate(
                      //                                   context, 'home', 'see'),
                      //                               style: TextStyle(
                      //                                   color: Colors.white,
                      //                                   fontSize: w * 0.05,
                      //                                   fontWeight:
                      //                                       FontWeight.bold),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //               onTap: () {},
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: h * 0.03,
                      //       ),
                      //       SizedBox(
                      //         width: w,
                      //         child: GridView.builder(
                      //           itemCount: newItem.length,
                      //           itemBuilder: (ctx, i) {
                      //             return InkWell(
                      //               child: Padding(
                      //                 padding: isLeft()
                      //                     ? EdgeInsets.only(left: w * 0.025)
                      //                     : EdgeInsets.only(right: w * 0.025),
                      //                 child: Column(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: [
                      //                     Expanded(
                      //                       child: Container(
                      //                         width: w * 0.5,
                      //                         height: h * 0.25,
                      //                         decoration: BoxDecoration(
                      //                           color: Colors.grey[200],
                      //                         ),
                      //                         child: Stack(
                      //                           children: [
                      //                             ImageeNetworkWidget(
                      //                               fit: BoxFit.cover,
                      //                               image: newItem[i].image,
                      //                               width: w * 0.5,
                      //                               height: h * 0.25,
                      //                             ),
                      //                             (newItem[i].isOrder == 1)
                      //                                 ? Container(
                      //                                     height: h * 0.04,
                      //                                     width: w * 0.22,
                      //                                     margin: EdgeInsets
                      //                                         .symmetric(
                      //                                             horizontal:
                      //                                                 w * 0.01,
                      //                                             vertical:
                      //                                                 h * 0.01),
                      //                                     decoration:
                      //                                         BoxDecoration(
                      //                                       color: mainColor,
                      //                                       borderRadius:
                      //                                           BorderRadius
                      //                                               .circular(w *
                      //                                                   0.02),
                      //                                     ),
                      //                                     child: Center(
                      //                                       child: Text(
                      //                                         translateString(
                      //                                             "Order",
                      //                                             "علي الطلب"),
                      //                                         style: TextStyle(
                      //                                             fontFamily:
                      //                                                 'Tajawal',
                      //                                             fontSize:
                      //                                                 w * 0.04,
                      //                                             color: Colors
                      //                                                 .white,
                      //                                             fontWeight:
                      //                                                 FontWeight
                      //                                                     .w500),
                      //                                       ),
                      //                                     ),
                      //                                   )
                      //                                 : const SizedBox(),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: w * 0.4,
                      //                       child: Column(
                      //                         mainAxisSize: MainAxisSize.min,
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           SizedBox(
                      //                             height: h * 0.01,
                      //                           ),
                      //                           Container(
                      //                               width: w * 0.45,
                      //                               constraints: BoxConstraints(
                      //                                 maxHeight: h * 0.07,
                      //                               ),
                      //                               child: Text(
                      //                                   translateString(
                      //                                       newItem[i].nameEn,
                      //                                       newItem[i].nameAr),
                      //                                   maxLines: 2,
                      //                                   style: TextStyle(
                      //                                       fontSize:
                      //                                           w * 0.035),
                      //                                   overflow: TextOverflow
                      //                                       .ellipsis)),
                      //                           SizedBox(
                      //                             height: h * 0.005,
                      //                           ),
                      //                           Row(
                      //                             crossAxisAlignment:
                      //                                 CrossAxisAlignment.start,
                      //                             mainAxisAlignment:
                      //                                 MainAxisAlignment
                      //                                     .spaceBetween,
                      //                             children: [
                      //                               RichText(
                      //                                 text: TextSpan(
                      //                                   children: [
                      //                                     if (newItem[i].isSale)
                      //                                       TextSpan(
                      //                                           text: getProductprice(
                      //                                               currency:
                      //                                                   currency,
                      //                                               productPrice:
                      //                                                   newItem[i]
                      //                                                       .salePrice!),
                      //                                           style: TextStyle(
                      //                                               fontFamily:
                      //                                                   'Tajawal',
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               color:
                      //                                                   mainColor)),
                      //                                     if (!newItem[i]
                      //                                         .isSale)
                      //                                       TextSpan(
                      //                                           text: getProductprice(
                      //                                               currency:
                      //                                                   currency,
                      //                                               productPrice:
                      //                                                   newItem[
                      //                                                           i]
                      //                                                       .price),
                      //                                           style: TextStyle(
                      //                                               fontFamily:
                      //                                                   'Tajawal',
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               color:
                      //                                                   mainColor)),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                               // if (newItem[i].isSale &&
                      //                               //     newItem[i].disPer != null)
                      //                               //   Text(newItem[i].disPer! + '%',
                      //                               //       style: const TextStyle(
                      //                               //           fontWeight:
                      //                               //               FontWeight.bold,
                      //                               //           color: Colors.red)),
                      //                               if (newItem[i].isSale)
                      //                                 Text(
                      //                                   getProductprice(
                      //                                       currency: currency,
                      //                                       productPrice:
                      //                                           newItem[i]
                      //                                               .price),
                      //                                   style: TextStyle(
                      //                                     fontSize: w * 0.035,
                      //                                     decorationThickness:
                      //                                         w * 0.1,
                      //                                     decorationColor:
                      //                                         mainColor,
                      //                                     decoration:
                      //                                         TextDecoration
                      //                                             .lineThrough,
                      //                                     color: Colors.grey,
                      //                                   ),
                      //                                 ),
                      //                             ],
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               onTap: () {
                      //                 navP(
                      //                     context,
                      //                     Products(
                      //                       fromFav: false,
                      //                       productId: newItem[i].id,
                      //                     ));
                      //                 // Navigator.pushNamed(
                      //                 //   context,
                      //                 //   'pro',
                      //                 // );
                      //               },
                      //             );
                      //           },
                      //           primary: false,
                      //           shrinkWrap: true,
                      //           gridDelegate:
                      //               SliverGridDelegateWithFixedCrossAxisCount(
                      //                   crossAxisSpacing: h * 0.001,
                      //                   mainAxisSpacing: w * 0.05,
                      //                   crossAxisCount: 2,
                      //                   childAspectRatio: 0.8),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // SizedBox(
                      //   height: h * 0.03,
                      // ),
                      // if (getAds(2).isNotEmpty)
                      //   SizedBox(
                      //     height: h * 0.2,
                      //     child: Padding(
                      //       padding:
                      //           EdgeInsets.symmetric(horizontal: w * 0.025),
                      //       child: Swiper(
                      //         itemCount: getAds(2).length,
                      //         itemBuilder: (BuildContext context, int i) {
                      //           Ads _ads = getAds(2)[i];
                      //           return InkWell(
                      //             child: ImageeNetworkWidget(
                      //               fit: BoxFit.cover,
                      //               width: w * 0.95,
                      //               height: h * 0.2,
                      //               image: _ads.image,
                      //             ),
                      //             focusColor: Colors.transparent,
                      //             splashColor: Colors.transparent,
                      //             highlightColor: Colors.transparent,
                      //             onTap: () async {
                      //               if (_ads.inApp) {
                      //                 if (_ads.type) {
                      //                   navP(
                      //                       context,
                      //                       Products(
                      //                         fromFav: false,
                      //                         productId: int.parse(_ads.link),
                      //                       ));
                      //                 } else {
                      //                   dialog(context);
                      //                   Provider.of<NewPackageItemProvider>(
                      //                           context,
                      //                           listen: false)
                      //                       .clearList();
                      //                   Provider.of<RePackageItemProvider>(
                      //                           context,
                      //                           listen: false)
                      //                       .clearList();
                      //                   Provider.of<BestPackageItemProvider>(
                      //                           context,
                      //                           listen: false)
                      //                       .clearList();
                      //                   await Provider.of<
                      //                               RePackageItemProvider>(
                      //                           context,
                      //                           listen: false)
                      //                       .getItems(int.parse(_ads.link));
                      //                   Navigator.pushReplacement(
                      //                       context,
                      //                       MaterialPageRoute(
                      //                           builder: (ctx) =>
                      //                               MultiplePackages(
                      //                                 id: int.parse(_ads.link),
                      //                               )));
                      //                 }
                      //               } else {
                      //                 await canLaunch(_ads.link)
                      //                     ? await launch(_ads.link)
                      //                     : throw 'Could not launch ${_ads.link}';
                      //               }
                      //             },
                      //           );
                      //         },
                      //         autoplay: true,
                      //         autoplayDelay: 5000,
                      //       ),
                      //     ),
                      //   ),

                      // (getAds(2).isNotEmpty)
                      //     ? SizedBox(
                      //         height: h * 0.03,
                      //       )
                      //     : Container(),
                    if (bestDis.isNotEmpty)
                        Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 0.025),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: Colors.white,
                                    width: w * 0.6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          translate(context, 'home', 'title5'),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: w * 0.05,
                                              fontFamily: 'Tajawal'),
                                        ),
                                        // Divider(
                                        //   color: mainColor,
                                        //   thickness: 3,
                                        //   endIndent: 80,
                                        // )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: w * 0.03,
                                  ),
                                  InkWell(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(w * 0.025),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MoreScreen(
                                                              endPoint:
                                                                  "get-offer-products",
                                                            )));
                                              },
                                              child: Container(
                                                width: w * 0.2,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            w * 0.02),
                                                    color: mainColor),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: w * 0.02,
                                                    vertical: h * 0.01),
                                                child: Center(
                                                  child: Text(
                                                    translate(
                                                        context, 'home', 'see'),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: w * 0.05,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: w * 0.01,
                                            // ),
                                            // Container(
                                            //   padding: EdgeInsets.symmetric(
                                            //       horizontal: w * 0.01),
                                            //   color: Colors.grey[200],
                                            //   child: Center(
                                            //     child: (prefs
                                            //                 .getString(
                                            //                     'language_code')
                                            //                 .toString() ==
                                            //             'en')
                                            //         ? const Icon(
                                            //             Icons.keyboard_arrow_right,
                                            //             color: Colors.black,
                                            //           )
                                            //         : const Icon(
                                            //             Icons.keyboard_arrow_left,
                                            //             color: Colors.black,
                                            //           ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            SizedBox(
                              width: w,
                              height: h*0.4,
                              child: ListView.builder(
                                itemCount: bestDis.length,
                                scrollDirection: Axis.horizontal,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (ctx, i) {
                                  return InkWell(
                                    child: Padding(
                                      padding: isLeft()
                                          ? EdgeInsets.only(left: w * 0.025)
                                          : EdgeInsets.only(right: w * 0.025),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Stack(
                                            children: [
                                              ImageeNetworkWidget(
                                                fit: BoxFit.cover,
                                                image: bestDis[i].image,
                                                width: w * 0.5,
                                               height: h * 0.3,
                                              ),
                                              // (bestDis[i].isOrder == 1)
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
                                            width: w * 0.44,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: h * 0.01,
                                                ),
                                                Container(
                                                    width: w * 0.45,
                                                    constraints: BoxConstraints(
                                                      maxHeight: h * 0.07,
                                                    ),
                                                    child: Text(
                                                        translateString(
                                                            bestDis[i].nameEn,
                                                            bestDis[i].nameAr),
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontFamily:
                                                                        'Tajawal',
                                                            fontSize:
                                                                w * 0.035),
                                                        overflow: TextOverflow
                                                            .ellipsis)),
                                                SizedBox(
                                                  height: h * 0.005,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          if (bestDis[i].isSale)
                                                            TextSpan(
                                                                text: getProductprice(
                                                                    currency:
                                                                        currency,
                                                                    productPrice:
                                                                        bestDis[i]
                                                                            .salePrice!),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Tajawal',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        mainColor)),
                                                          if (!bestDis[i]
                                                              .isSale)
                                                            TextSpan(
                                                                text: getProductprice(
                                                                    currency:
                                                                        currency,
                                                                    productPrice:
                                                                        bestDis[
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
                                                    if (bestDis[i].isSale)
                                                      Text(
                                                        getProductprice(
                                                            currency: currency,
                                                            productPrice:
                                                                bestDis[i]
                                                                    .price),
                                                        style: TextStyle(
                                                            fontSize: w * 0.035,
                                                            decorationThickness:
                                                                w * 0.1,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            color: Colors.grey,
                                                            decorationColor:
                                                                mainColor),
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
                                      // await getItem(bestDis[i].id);
                                      // Navigator.pushNamed(context, 'pro');
                                      navP(
                                        context,
                                        Products(
                                          fromFav: false,
                                          productId: bestDis[i].id,
                                        ),
                                      );
                                    },
                                  );
                                },
                                // gridDelegate:
                                //     SliverGridDelegateWithFixedCrossAxisCount(
                                //         crossAxisSpacing: h * 0.001,
                                //         mainAxisSpacing: w * 0.05,
                                //         crossAxisCount: 2,
                                //         childAspectRatio: 0.8),
                              ),
                            ),
                          ],
                        ),
                    
                      // if (reItem.isNotEmpty)
                      //   Column(
                      //     children: [
                      //       Padding(
                      //         padding:
                      //             EdgeInsets.symmetric(horizontal: w * 0.025),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Container(
                      //               color: Colors.white,
                      //               width: w * 0.6,
                      //               child: Column(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   Text(
                      //                     translate(context, 'home', 'title4'),
                      //                     style: TextStyle(
                      //                         fontWeight: FontWeight.bold,
                      //                         fontSize: w * 0.05,
                      //                         fontFamily: 'Tajawal'),
                      //                   ),
                      //                   Divider(
                      //                     color: mainColor,
                      //                     thickness: 3,
                      //                     endIndent:
                      //                         (language == 'ar') ? 60 : 10,
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //             SizedBox(
                      //               width: w * 0.01,
                      //             ),
                      //             InkWell(
                      //               child: Container(
                      //                 decoration: const BoxDecoration(
                      //                   color: Colors.transparent,
                      //                 ),
                      //                 child: Padding(
                      //                   padding: EdgeInsets.all(w * 0.025),
                      //                   child: Row(
                      //                     children: [
                      //                       Container(
                      //                         width: w * 0.2,
                      //                         decoration: BoxDecoration(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(
                      //                                     w * 0.02),
                      //                             color: mainColor),
                      //                         padding: EdgeInsets.symmetric(
                      //                             horizontal: w * 0.02,
                      //                             vertical: h * 0.01),
                      //                         child: Center(
                      //                           child: Text(
                      //                             translate(
                      //                                 context, 'home', 'see'),
                      //                             style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: w * 0.05,
                      //                                 fontWeight:
                      //                                     FontWeight.bold),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //               onTap: () {
                      //                 Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                         builder: (context) =>
                      //                             const MoreScreen(
                      //                               endPoint:
                      //                                   "get-recommended-products",
                      //                             )));
                      //               },
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: h * 0.03,
                      //       ),
                      //       SizedBox(
                      //         width: w,
                      //         height: h * 0.3,
                      //         child: ListView.builder(
                      //           itemCount: reItem.length,
                      //           primary: false,
                      //           shrinkWrap: true,
                      //           scrollDirection: Axis.horizontal,
                      //           itemBuilder: (ctx, i) {
                      //             return InkWell(
                      //               child: Padding(
                      //                 padding: isLeft()
                      //                     ? EdgeInsets.only(left: w * 0.025)
                      //                     : EdgeInsets.only(right: w * 0.025),
                      //                 child: Container(
                      //                   decoration: BoxDecoration(
                      //                     color: Colors.grey[200],
                      //                     borderRadius:
                      //                         BorderRadius.circular(w * 0.05),
                      //                   ),
                      //                   child: Row(
                      //                     mainAxisSize: MainAxisSize.min,
                      //                     children: [
                      //                       Container(
                      //                         width: w * 0.4,
                      //                         // height: h * 0.25,
                      //                         decoration: BoxDecoration(
                      //                           color: Colors.grey[200],
                      //                           borderRadius: (prefs.getString(
                      //                                       'language_code') ==
                      //                                   'en')
                      //                               ? BorderRadius.only(
                      //                                   topLeft:
                      //                                       Radius.circular(
                      //                                           w * 0.05),
                      //                                   bottomLeft:
                      //                                       Radius.circular(
                      //                                           w * 0.05))
                      //                               : BorderRadius.only(
                      //                                   topRight:
                      //                                       Radius.circular(
                      //                                           w * 0.05),
                      //                                   bottomRight:
                      //                                       Radius.circular(
                      //                                           w * 0.05)),
                      //                           // image: DecorationImage(
                      //                           //   image: NetworkImage(
                      //                           //       reItem[i].image),
                      //                           //   fit: BoxFit.fitHeight,
                      //                           // )
                      //                         ),
                      //                         child: ClipRRect(
                      //                           borderRadius: (prefs.getString(
                      //                                       'language_code') ==
                      //                                   'en')
                      //                               ? BorderRadius.only(
                      //                                   topLeft:
                      //                                       Radius.circular(
                      //                                           w * 0.05),
                      //                                   bottomLeft:
                      //                                       Radius.circular(
                      //                                           w * 0.05))
                      //                               : BorderRadius.only(
                      //                                   topRight:
                      //                                       Radius.circular(
                      //                                           w * 0.05),
                      //                                   bottomRight:
                      //                                       Radius.circular(
                      //                                           w * 0.05)),
                      //                           child: ImageeNetworkWidget(
                      //                             fit: BoxFit.cover,
                      //                             image: reItem[i].image,
                      //                             width: w * 0.4,
                      //                             height: h * 0.3,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       SizedBox(
                      //                         width: w * 0.02,
                      //                       ),
                      //                       SizedBox(
                      //                         width: w * 0.4,
                      //                         child: Column(
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment.start,
                      //                           mainAxisSize: MainAxisSize.min,
                      //                           crossAxisAlignment:
                      //                               CrossAxisAlignment.start,
                      //                           children: [
                      //                             SizedBox(
                      //                               height: h * 0.01,
                      //                             ),
                      //                             Container(
                      //                                 width: w * 0.45,
                      //                                 constraints:
                      //                                     BoxConstraints(
                      //                                   maxHeight: h * 0.07,
                      //                                 ),
                      //                                 child: Text(
                      //                                     translateString(
                      //                                         reItem[i].nameEn,
                      //                                         reItem[i].nameAr),
                      //                                     maxLines: 2,
                      //                                     style: TextStyle(
                      //                                         color:
                      //                                             Colors.black,
                      //                                         fontSize:
                      //                                             w * 0.04),
                      //                                     overflow: TextOverflow
                      //                                         .ellipsis)),
                      //                             SizedBox(
                      //                               height: h * 0.005,
                      //                             ),
                      //                             Row(
                      //                               crossAxisAlignment:
                      //                                   CrossAxisAlignment
                      //                                       .start,
                      //                               mainAxisAlignment:
                      //                                   MainAxisAlignment
                      //                                       .spaceBetween,
                      //                               children: [
                      //                                 RichText(
                      //                                   text: TextSpan(
                      //                                     children: [
                      //                                       if (reItem[i]
                      //                                           .isSale)
                      //                                         TextSpan(
                      //                                             text: getProductprice(
                      //                                                 currency:
                      //                                                     currency,
                      //                                                 productPrice:
                      //                                                     reItem[i]
                      //                                                         .salePrice!),
                      //                                             style:
                      //                                                 TextStyle(
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               color:
                      //                                                   mainColor,
                      //                                               fontFamily:
                      //                                                   'Tajawal',
                      //                                             )),
                      //                                       if (!reItem[i]
                      //                                           .isSale)
                      //                                         TextSpan(
                      //                                             text: getProductprice(
                      //                                                 currency:
                      //                                                     currency,
                      //                                                 productPrice:
                      //                                                     reItem[i]
                      //                                                         .price),
                      //                                             style: const TextStyle(
                      //                                                 fontFamily:
                      //                                                     'Tajawal',
                      //                                                 fontWeight:
                      //                                                     FontWeight
                      //                                                         .bold,
                      //                                                 color: Colors
                      //                                                     .black)),
                      //                                     ],
                      //                                   ),
                      //                                 ),
                      //                                 if (reItem[i].isSale)
                      //                                   Text(
                      //                                     getProductprice(
                      //                                         currency:
                      //                                             currency,
                      //                                         productPrice:
                      //                                             reItem[i]
                      //                                                 .price),
                      //                                     style: TextStyle(
                      //                                         fontSize:
                      //                                             w * 0.035,
                      //                                         decoration:
                      //                                             TextDecoration
                      //                                                 .lineThrough,
                      //                                         color:
                      //                                             Colors.grey,
                      //                                         decorationThickness:
                      //                                             w * 0.1,
                      //                                         decorationColor:
                      //                                             mainColor),
                      //                                   ),
                      //                                 // if (reItem[i].isSale &&
                      //                                 //     reItem[i].disPer != null)
                      //                                 //   Text(reItem[i].disPer! + '%',
                      //                                 //       style: TextStyle(
                      //                                 //           fontWeight:
                      //                                 //               FontWeight.bold,
                      //                                 //           color: Colors.red)),
                      //                               ],
                      //                             ),
                      //                             SizedBox(
                      //                               height: h * 0.02,
                      //                             ),
                      //                             InkWell(
                      //                               onTap: () async {
                      //                                 dialog(context);
                      //                                 await getItem(
                      //                                     reItem[i].id);
                      //                                 Navigator
                      //                                     .pushReplacementNamed(
                      //                                         context, 'pro');
                      //                               },
                      //                               child: Container(
                      //                                 margin:
                      //                                     EdgeInsets.symmetric(
                      //                                         horizontal:
                      //                                             w * 0.02),
                      //                                 padding:
                      //                                     EdgeInsets.symmetric(
                      //                                         horizontal:
                      //                                             w * 0.02,
                      //                                         vertical:
                      //                                             h * 0.01),
                      //                                 decoration: BoxDecoration(
                      //                                     color: Colors.white,
                      //                                     borderRadius:
                      //                                         BorderRadius
                      //                                             .circular(
                      //                                                 10)),
                      //                                 child: Row(
                      //                                   crossAxisAlignment:
                      //                                       CrossAxisAlignment
                      //                                           .center,
                      //                                   mainAxisAlignment:
                      //                                       MainAxisAlignment
                      //                                           .spaceBetween,
                      //                                   children: [
                      //                                     Text(
                      //                                       translate(
                      //                                           context,
                      //                                           'language',
                      //                                           'shop'),
                      //                                       style: TextStyle(
                      //                                           color: Colors
                      //                                               .black,
                      //                                           fontSize:
                      //                                               w * 0.05,
                      //                                           fontWeight:
                      //                                               FontWeight
                      //                                                   .w400),
                      //                                     ),
                      //                                     (prefs.getString(
                      //                                                 'language_code') ==
                      //                                             'en')
                      //                                         ? const Icon(
                      //                                             Icons
                      //                                                 .keyboard_arrow_right,
                      //                                             color: Colors
                      //                                                 .black,
                      //                                           )
                      //                                         : const Icon(
                      //                                             Icons
                      //                                                 .keyboard_arrow_left,
                      //                                             color: Colors
                      //                                                 .black,
                      //                                           )
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                             )
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //               onTap: () async {
                      //                 // getItem(reItem[i].id).then((value) {
                      //                 //   Navigator.pushNamed(context, 'pro');
                      //                 // });
                      //                 navP(
                      //                   context,
                      //                   Products(
                      //                     fromFav: false,
                      //                     productId: reItem[i].id,
                      //                   ),
                      //                 );
                      //               },
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // SizedBox(
                      //   height: h * 0.03,
                      // ),
                      
                      
                      // if (bestItem.isNotEmpty)
                      //   Column(
                      //     children: [
                      //       Padding(
                      //         padding:
                      //             EdgeInsets.symmetric(horizontal: w * 0.025),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text(
                      //               translate(context, 'home', 'title3'),
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: w * 0.05,
                      //                   fontFamily: 'Tajawal'),
                      //             ),
                      //             SizedBox(
                      //               width: w * 0.01,
                      //             ),
                      //             InkWell(
                      //               child: Container(
                      //                 decoration: const BoxDecoration(
                      //                   color: Colors.transparent,
                      //                   // borderRadius: isLeft()
                      //                   //     ? const BorderRadius.only(
                      //                   //         bottomLeft: Radius.circular(15),
                      //                   //       )
                      //                   //     : const BorderRadius.only(
                      //                   //         bottomRight: Radius.circular(15),
                      //                   //       ),
                      //                 ),
                      //                 child: Padding(
                      //                   padding: EdgeInsets.all(w * 0.025),
                      //                   child: Row(
                      //                     children: [
                      //                       Container(
                      //                         width: w * 0.2,
                      //                         decoration: BoxDecoration(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(
                      //                                     w * 0.02),
                      //                             color: mainColor),
                      //                         padding: EdgeInsets.symmetric(
                      //                             horizontal: w * 0.02,
                      //                             vertical: h * 0.01),
                      //                         child: Center(
                      //                           child: Text(
                      //                             translate(
                      //                                 context, 'home', 'see'),
                      //                             style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: w * 0.05,
                      //                                 fontWeight:
                      //                                     FontWeight.bold),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //               onTap: () {
                      //                 Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                         builder: (context) =>
                      //                             const MoreScreen(
                      //                                 endPoint:
                      //                                     "get-best-products")));
                      //               },
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: h * 0.01,
                      //       ),
                      //       SizedBox(
                      //         width: w,
                      //         child: GridView.builder(
                      //           itemCount: bestItem.length,
                      //           primary: false,
                      //           shrinkWrap: true,
                      //           // scrollDirection: Axis.horizontal,
                      //           itemBuilder: (ctx, i) {
                      //             return InkWell(
                      //               child: Padding(
                      //                 padding: isLeft()
                      //                     ? EdgeInsets.only(left: w * 0.025)
                      //                     : EdgeInsets.only(right: w * 0.025),
                      //                 child: Column(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: [
                      //                     Container(
                      //                       width: w * 0.9,
                      //                       height: h * 0.25,
                      //                       decoration: BoxDecoration(
                      //                           color: Colors.grey[200],
                      //                           image: DecorationImage(
                      //                             image: NetworkImage(
                      //                                 bestItem[i].image),
                      //                             fit: BoxFit.cover,
                      //                           )),
                      //                       child: Padding(
                      //                         padding: EdgeInsets.all(w * 0.015),
                      //                         child: Align(
                      //                           alignment: isLeft()
                      //                               ? Alignment.bottomLeft
                      //                               : Alignment.bottomRight,
                      //                           child: InkWell(
                      //                             onTap: () async {
                      //                               if (cartId == null ||
                      //                                   cartId == studentId) {
                      //                                 try {
                      //                                   if (!cart.idp.contains(
                      //                                       bestDis[i].id)) {
                      //                                     await helper.createCar(
                      //                                         CartProducts(
                      //                                             id: null,
                      //                                             studentId:
                      //                                                 studentId,
                      //                                             image:
                      //                                                 bestItem[i]
                      //                                                     .image,
                      //                                             titleAr:
                      //                                                 bestItem[i]
                      //                                                     .nameAr,
                      //                                             titleEn:
                      //                                                 bestItem[i]
                      //                                                     .nameEn,
                      //                                             price: bestItem[
                      //                                                     i]
                      //                                                 .finalPrice
                      //                                                 .toDouble(),
                      //                                             quantity: 1,
                      //                                             att: att,
                      //                                             des: des,
                      //                                             idp: bestItem[i]
                      //                                                 .id,
                      //                                             idc: 0,
                      //                                             catNameEn: "",
                      //                                             catNameAr: "",
                      //                                             catSVG: ""));
                      //                                   } else {
                      //                                     int quantity = cart
                      //                                         .items
                      //                                         .firstWhere(
                      //                                             (element) =>
                      //                                                 element
                      //                                                     .idp ==
                      //                                                 bestItem[i]
                      //                                                     .id)
                      //                                         .quantity;
                      //                                     await helper
                      //                                         .updateProduct(
                      //                                             1 + quantity,
                      //                                             bestItem[i].id,
                      //                                             bestItem[i]
                      //                                                 .finalPrice
                      //                                                 .toDouble(),
                      //                                             jsonEncode(att),
                      //                                             jsonEncode(
                      //                                                 des));
                      //                                   }
                      //                                   await cart.setItems();
                      //                                 } catch (e) {
                      //                                   print('e');
                      //                                   print(e);
                      //                                 }
                      //                               } else {
                      //                                 if (cartId == null ||
                      //                                     cartId == studentId) {
                      //                                   try {
                      //                                     if (!cart.idp.contains(
                      //                                         bestItem[i].id)) {
                      //                                       await helper.createCar(CartProducts(
                      //                                           id: null,
                      //                                           studentId:
                      //                                               bestItem[i]
                      //                                                   .brands![
                      //                                                       i]
                      //                                                   .id,
                      //                                           image: bestItem[i]
                      //                                               .image,
                      //                                           titleAr: bestItem[
                      //                                                   i]
                      //                                               .nameAr,
                      //                                           titleEn:
                      //                                               bestItem[i]
                      //                                                   .nameEn,
                      //                                           price: bestItem[i]
                      //                                               .price
                      //                                               .toDouble(),
                      //                                           quantity: 1,
                      //                                           att: att,
                      //                                           des: des,
                      //                                           idp: bestItem[i]
                      //                                               .id,
                      //                                           idc: bestItem[i]
                      //                                               .id,
                      //                                           catNameEn: "",
                      //                                           catNameAr: "",
                      //                                           catSVG: ""));
                      //                                     } else {
                      //                                       int quantity = cart
                      //                                           .items
                      //                                           .firstWhere(
                      //                                               (element) =>
                      //                                                   element
                      //                                                       .idp ==
                      //                                                   bestItem[
                      //                                                           i]
                      //                                                       .id)
                      //                                           .quantity;
                      //                                       await helper
                      //                                           .updateProduct(
                      //                                               1 + quantity,
                      //                                               bestItem[i]
                      //                                                   .id,
                      //                                               bestItem[i]
                      //                                                   .finalPrice
                      //                                                   .toDouble(),
                      //                                               jsonEncode(
                      //                                                   att),
                      //                                               jsonEncode(
                      //                                                   des));
                      //                                     }
                      //                                     await cart.setItems();
                      //                                   } catch (e) {
                      //                                     print('e');
                      //                                     print(e);
                      //                                   }
                      //                                 } else {}
                      //                               }
                      //                             },
                      //                             child: CircleAvatar(
                      //                               backgroundColor: mainColor,
                      //                               radius: w * .05,
                      //                               child: Center(
                      //                                 child: Icon(
                      //                                   Icons
                      //                                       .shopping_cart_outlined,
                      //                                   color: Colors.white,
                      //                                   size: w * 0.05,
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: w * 0.4,
                      //                       child: Column(
                      //                         mainAxisSize: MainAxisSize.min,
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           SizedBox(
                      //                             height: h * 0.01,
                      //                           ),
                      //                           Container(
                      //                               width: w * 0.45,
                      //                               constraints: BoxConstraints(
                      //                                 maxHeight: h * 0.07,
                      //                               ),
                      //                               child: Text(
                      //                                   translateString(
                      //                                       bestItem[i].nameEn,
                      //                                       bestItem[i].nameAr),
                      //                                   maxLines: 2,
                      //                                   style: TextStyle(
                      //                                       fontSize: w * 0.035),
                      //                                   overflow: TextOverflow
                      //                                       .ellipsis)),
                      //                           SizedBox(
                      //                             height: h * 0.005,
                      //                           ),
                      //                           Row(
                      //                             crossAxisAlignment:
                      //                                 CrossAxisAlignment.start,
                      //                             mainAxisAlignment:
                      //                                 MainAxisAlignment
                      //                                     .spaceBetween,
                      //                             children: [
                      //                               RichText(
                      //                                 text: TextSpan(
                      //                                   children: [
                      //                                     if (bestItem[i].isSale)
                      //                                       TextSpan(
                      //                                           text:
                      //                                               '${bestItem[i].salePrice} $currency ',
                      //                                           style: TextStyle(
                      //                                               fontFamily:
                      //                                                   'Tajawal',
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               color:
                      //                                                   mainColor)),
                      //                                     if (!bestItem[i].isSale)
                      //                                       TextSpan(
                      //                                           text:
                      //                                               '${bestItem[i].price} $currency',
                      //                                           style: TextStyle(
                      //                                               fontFamily:
                      //                                                   'Tajawal',
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               color:
                      //                                                   mainColor)),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                               // if (bestItem[i].isSale &&
                      //                               //     bestItem[i].disPer != null)
                      //                               //   Text(bestItem[i].disPer! + '%',
                      //                               //       style: const TextStyle(
                      //                               //           fontWeight:
                      //                               //               FontWeight.bold,
                      //                               //           color: Colors.red)),
                      //                               if (bestItem[i].isSale)
                      //                                 Text(
                      //                                   '${bestItem[i].price} $currency',
                      //                                   style: TextStyle(
                      //                                     fontSize: w * 0.035,
                      //                                     decorationThickness:
                      //                                         w * 0.1,
                      //                                     decoration:
                      //                                         TextDecoration
                      //                                             .lineThrough,
                      //                                     decorationColor:
                      //                                         mainColor,
                      //                                     color: Colors.grey,
                      //                                   ),
                      //                                 ),
                      //                             ],
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               onTap: () async {
                      //                 dialog(context);
                      //                 await getItem(bestItem[i].id);
                      //                 Navigator.pushReplacementNamed(
                      //                     context, 'pro');
                      //               },
                      //             );
                      //           },
                      //           gridDelegate:
                      //               SliverGridDelegateWithFixedCrossAxisCount(
                      //                   crossAxisSpacing: h * 0.001,
                      //                   mainAxisSpacing: w * 0.05,
                      //                   crossAxisCount: 2,
                      //                   childAspectRatio: 0.8),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // SizedBox(
                      //   height: h * 0.02,
                      // ),
                      // if (bestPrice.isNotEmpty)
                      //   Column(
                      //     children: [
                      //       Padding(
                      //         padding:
                      //             EdgeInsets.symmetric(horizontal: w * 0.025),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text(
                      //               translate(context, 'home', 'title6'),
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: w * 0.05,
                      //                   fontFamily: 'Tajawal'),
                      //             ),
                      //             SizedBox(
                      //               width: w * 0.01,
                      //             ),

                      //             // InkWell(
                      //             //   child: Container(
                      //             //     decoration: const BoxDecoration(
                      //             //       color: Colors.transparent,
                      //             //     ),
                      //             //     child: Padding(
                      //             //       padding: EdgeInsets.all(w * 0.025),
                      //             //       child: Row(
                      //             //         children: [
                      //             //           // Container(
                      //             //           //   width: w * 0.2,
                      //             //           //   decoration: BoxDecoration(
                      //             //           //       borderRadius:
                      //             //           //           BorderRadius.circular(
                      //             //           //               w * 0.02),
                      //             //           //       color: mainColor),
                      //             //           //   padding: EdgeInsets.symmetric(
                      //             //           //       horizontal: w * 0.02,
                      //             //           //       vertical: h * 0.01),
                      //             //           //   child: Center(
                      //             //           //     child: Text(
                      //             //           //       translate(
                      //             //           //           context, 'home', 'see'),
                      //             //           //       style: TextStyle(
                      //             //           //           color: Colors.white,
                      //             //           //           fontSize: w * 0.05,
                      //             //           //           fontWeight:
                      //             //           //               FontWeight.bold),
                      //             //           //     ),
                      //             //           //   ),
                      //             //           // ),
                      //             //           // // SizedBox(
                      //             //           //   width: w * 0.01,
                      //             //           // ),
                      //             //           // Container(
                      //             //           //   padding: EdgeInsets.symmetric(
                      //             //           //       horizontal: w * 0.01),
                      //             //           //   color: Colors.grey[200],
                      //             //           //   child: Center(
                      //             //           //     child: (prefs
                      //             //           //                 .getString(
                      //             //           //                     'language_code')
                      //             //           //                 .toString() ==
                      //             //           //             'en')
                      //             //           //         ? const Icon(
                      //             //           //             Icons.keyboard_arrow_right,
                      //             //           //             color: Colors.black,
                      //             //           //           )
                      //             //           //         : const Icon(
                      //             //           //             Icons.keyboard_arrow_left,
                      //             //           //             color: Colors.black,
                      //             //           //           ),
                      //             //           //   ),
                      //             //           // ),
                      //             //         ],
                      //             //       ),
                      //             //     ),
                      //             //   ),
                      //             //   onTap: () {
                      //             //     Navigator.push(
                      //             //         context,
                      //             //         MaterialPageRoute(
                      //             //             builder: (context) => const MoreScreen(
                      //             //                 endPoint:
                      //             //                     "get-recommended-products")));
                      //             //   },
                      //             // ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: h * 0.03,
                      //       ),
                      //       SizedBox(
                      //         width: w,
                      //         child: GridView.builder(
                      //           primary: false,
                      //           shrinkWrap: true,
                      //           gridDelegate:
                      //               SliverGridDelegateWithFixedCrossAxisCount(
                      //                   crossAxisSpacing: h * 0.001,
                      //                   mainAxisSpacing: w * 0.05,
                      //                   crossAxisCount: 2,
                      //                   childAspectRatio: 0.8),
                      //           itemCount: bestPrice.length,
                      //           itemBuilder: (ctx, i) {
                      //             return InkWell(
                      //               child: Padding(
                      //                 padding: isLeft()
                      //                     ? EdgeInsets.only(left: w * 0.025)
                      //                     : EdgeInsets.only(right: w * 0.025),
                      //                 child: Column(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: [
                      //                     Container(
                      //                       width: w * 0.9,
                      //                       height: h * 0.25,
                      //                       decoration: BoxDecoration(
                      //                           color: Colors.grey[200],
                      //                           image: DecorationImage(
                      //                             image: NetworkImage(
                      //                                 bestPrice[i].image),
                      //                             fit: BoxFit.cover,
                      //                           )),
                      //                       child: Padding(
                      //                         padding: EdgeInsets.all(w * 0.015),
                      //                         child: Align(
                      //                           alignment: isLeft()
                      //                               ? Alignment.bottomLeft
                      //                               : Alignment.bottomRight,
                      //                           child: InkWell(
                      //                             onTap: () async {
                      //                               if (cartId == null ||
                      //                                   cartId == studentId) {
                      //                                 try {
                      //                                   if (!cart.idp.contains(
                      //                                       bestDis[i].id)) {
                      //                                     await helper.createCar(
                      //                                         CartProducts(
                      //                                             id: null,
                      //                                             studentId:
                      //                                                 studentId,
                      //                                             image:
                      //                                                 bestPrice[i]
                      //                                                     .image,
                      //                                             titleAr:
                      //                                                 bestPrice[i]
                      //                                                     .nameAr,
                      //                                             titleEn:
                      //                                                 bestPrice[i]
                      //                                                     .nameEn,
                      //                                             price: bestPrice[
                      //                                                     i]
                      //                                                 .finalPrice
                      //                                                 .toDouble(),
                      //                                             quantity: 1,
                      //                                             att: att,
                      //                                             des: des,
                      //                                             idp:
                      //                                                 bestPrice[i]
                      //                                                     .id,
                      //                                             idc: 0,
                      //                                             catNameEn: "",
                      //                                             catNameAr: "",
                      //                                             catSVG: ""));
                      //                                   } else {
                      //                                     int quantity = cart
                      //                                         .items
                      //                                         .firstWhere(
                      //                                             (element) =>
                      //                                                 element
                      //                                                     .idp ==
                      //                                                 bestPrice[i]
                      //                                                     .id)
                      //                                         .quantity;
                      //                                     await helper
                      //                                         .updateProduct(
                      //                                             1 + quantity,
                      //                                             bestPrice[i].id,
                      //                                             bestPrice[i]
                      //                                                 .finalPrice
                      //                                                 .toDouble(),
                      //                                             jsonEncode(att),
                      //                                             jsonEncode(
                      //                                                 des));
                      //                                   }
                      //                                   await cart.setItems();
                      //                                 } catch (e) {
                      //                                   print('e');
                      //                                   print(e);
                      //                                 }
                      //                               } else {
                      //                                 if (cartId == null ||
                      //                                     cartId == studentId) {
                      //                                   try {
                      //                                     if (!cart.idp.contains(
                      //                                         bestPrice[i].id)) {
                      //                                       await helper.createCar(CartProducts(
                      //                                           id: null,
                      //                                           studentId:
                      //                                               bestPrice[i]
                      //                                                   .brands![
                      //                                                       i]
                      //                                                   .id,
                      //                                           image: bestPrice[
                      //                                                   i]
                      //                                               .image,
                      //                                           titleAr:
                      //                                               bestPrice[
                      //                                                       i]
                      //                                                   .nameAr,
                      //                                           titleEn:
                      //                                               bestPrice[
                      //                                                       i]
                      //                                                   .nameEn,
                      //                                           price: bestPrice[
                      //                                                   i]
                      //                                               .price
                      //                                               .toDouble(),
                      //                                           quantity: 1,
                      //                                           att: att,
                      //                                           des: des,
                      //                                           idp: bestPrice[i]
                      //                                               .id,
                      //                                           idc: bestPrice[i]
                      //                                               .id,
                      //                                           catNameEn: "",
                      //                                           catNameAr: "",
                      //                                           catSVG: ""));
                      //                                     } else {
                      //                                       int quantity = cart
                      //                                           .items
                      //                                           .firstWhere(
                      //                                               (element) =>
                      //                                                   element
                      //                                                       .idp ==
                      //                                                   bestPrice[
                      //                                                           i]
                      //                                                       .id)
                      //                                           .quantity;
                      //                                       await helper
                      //                                           .updateProduct(
                      //                                               1 + quantity,
                      //                                               bestPrice[i]
                      //                                                   .id,
                      //                                               bestPrice[i]
                      //                                                   .finalPrice
                      //                                                   .toDouble(),
                      //                                               jsonEncode(
                      //                                                   att),
                      //                                               jsonEncode(
                      //                                                   des));
                      //                                     }
                      //                                     await cart.setItems();
                      //                                   } catch (e) {
                      //                                     print('e');
                      //                                     print(e);
                      //                                   }
                      //                                 } else {}
                      //                               }
                      //                             },
                      //                             child: CircleAvatar(
                      //                               backgroundColor: mainColor,
                      //                               radius: w * .05,
                      //                               child: Center(
                      //                                 child: Icon(
                      //                                   Icons
                      //                                       .shopping_cart_outlined,
                      //                                   color: Colors.white,
                      //                                   size: w * 0.05,
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: w * 0.4,
                      //                       child: Column(
                      //                         mainAxisSize: MainAxisSize.min,
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           SizedBox(
                      //                             height: h * 0.01,
                      //                           ),
                      //                           Container(
                      //                               width: w * 0.45,
                      //                               constraints: BoxConstraints(
                      //                                 maxHeight: h * 0.07,
                      //                               ),
                      //                               child: Text(
                      //                                   translateString(
                      //                                       bestPrice[i].nameEn,
                      //                                       bestPrice[i].nameAr),
                      //                                   maxLines: 2,
                      //                                   style: TextStyle(
                      //                                       fontSize: w * 0.035),
                      //                                   overflow: TextOverflow
                      //                                       .ellipsis)),
                      //                           SizedBox(
                      //                             height: h * 0.005,
                      //                           ),
                      //                           Row(
                      //                             crossAxisAlignment:
                      //                                 CrossAxisAlignment.start,
                      //                             mainAxisAlignment:
                      //                                 MainAxisAlignment
                      //                                     .spaceBetween,
                      //                             children: [
                      //                               RichText(
                      //                                 text: TextSpan(
                      //                                   children: [
                      //                                     if (bestPrice[i].isSale)
                      //                                       TextSpan(
                      //                                           text:
                      //                                               '${bestPrice[i].salePrice} $currency ',
                      //                                           style: TextStyle(
                      //                                               fontFamily:
                      //                                                   'Tajawal',
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               color:
                      //                                                   mainColor)),
                      //                                     if (!bestPrice[i]
                      //                                         .isSale)
                      //                                       TextSpan(
                      //                                           text:
                      //                                               '${bestPrice[i].price} $currency',
                      //                                           style: TextStyle(
                      //                                               fontFamily:
                      //                                                   'Tajawal',
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               color:
                      //                                                   mainColor)),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                               // if (bestPrice[i].isSale &&
                      //                               //     bestPrice[i].disPer != null)
                      //                               //   Text(bestPrice[i].disPer! + '%',
                      //                               //       style: const TextStyle(
                      //                               //           fontWeight:
                      //                               //               FontWeight.bold,
                      //                               //           color: Colors.red)),

                      //                               if (bestPrice[i].isSale)
                      //                                 Text(
                      //                                   '${bestPrice[i].price} $currency',
                      //                                   style: TextStyle(
                      //                                       fontSize: w * 0.035,
                      //                                       decorationThickness:
                      //                                           w * 0.1,
                      //                                       decoration:
                      //                                           TextDecoration
                      //                                               .lineThrough,
                      //                                       color: Colors.grey,
                      //                                       decorationColor:
                      //                                           mainColor),
                      //                                 ),
                      //                             ],
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               onTap: () async {
                      //                 dialog(context);
                      //                 await getItem(bestPrice[i].id);
                      //                 Navigator.pushReplacementNamed(
                      //                     context, 'pro');
                      //               },
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // SizedBox(
                      //   height: h * 0.03,
                      // ),
                      // if (topLikes.isNotEmpty)
                      //   Column(
                      //     children: [
                      //       Padding(
                      //         padding:
                      //             EdgeInsets.symmetric(horizontal: w * 0.025),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text(
                      //               translate(context, 'home', 'title7'),
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: w * 0.05,
                      //                   fontFamily: 'Tajawal'),
                      //             ),
                      //             SizedBox(
                      //               width: w * 0.01,
                      //             ),
                      //             InkWell(
                      //               child: Container(
                      //                 decoration: const BoxDecoration(
                      //                   color: Colors.transparent,
                      //                   // borderRadius: isLeft()
                      //                   //     ? const BorderRadius.only(
                      //                   //         bottomLeft: Radius.circular(15),
                      //                   //       )
                      //                   //     : const BorderRadius.only(
                      //                   //         bottomRight: Radius.circular(15),
                      //                   //       ),
                      //                 ),
                      //                 child: Padding(
                      //                   padding: EdgeInsets.all(w * 0.025),
                      //                   child: Row(
                      //                     children: [
                      //                       Container(
                      //                         width: w * 0.2,
                      //                         decoration: BoxDecoration(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(
                      //                                     w * 0.02),
                      //                             color: mainColor),
                      //                         padding: EdgeInsets.symmetric(
                      //                             horizontal: w * 0.02,
                      //                             vertical: h * 0.01),
                      //                         child: Center(
                      //                           child: Text(
                      //                             translate(
                      //                                 context, 'home', 'see'),
                      //                             style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: w * 0.05,
                      //                                 fontWeight:
                      //                                     FontWeight.bold),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //               onTap: () {
                      //                 Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                         builder: (context) => const MoreScreen(
                      //                             endPoint:
                      //                                 "get-topLikes-products")));
                      //               },
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: h * 0.03,
                      //       ),
                      //       SizedBox(
                      //         width: w,
                      //         // height: h * 0.4,
                      //         child: GridView.builder(
                      //           itemCount: topLikes.length,
                      //           primary: false,
                      //           shrinkWrap: true,
                      //           gridDelegate:
                      //               SliverGridDelegateWithFixedCrossAxisCount(
                      //                   crossAxisSpacing: h * 0.001,
                      //                   mainAxisSpacing: w * 0.05,
                      //                   crossAxisCount: 2,
                      //                   childAspectRatio: 0.8),
                      //           // scrollDirection: Axis.horizontal,
                      //           itemBuilder: (ctx, i) {
                      //             return InkWell(
                      //               child: Padding(
                      //                 padding: isLeft()
                      //                     ? EdgeInsets.only(left: w * 0.025)
                      //                     : EdgeInsets.only(right: w * 0.025),
                      //                 child: Column(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: [
                      //                     Container(
                      //                       width: w * 0.9,
                      //                       height: h * 0.25,
                      //                       decoration: BoxDecoration(
                      //                           color: Colors.grey[200],
                      //                           image: DecorationImage(
                      //                             image: NetworkImage(
                      //                                 topLikes[i].image),
                      //                             fit: BoxFit.cover,
                      //                           )),
                      //                       child: Padding(
                      //                         padding: EdgeInsets.all(w * 0.015),
                      //                         child: Align(
                      //                           alignment: isLeft()
                      //                               ? Alignment.bottomLeft
                      //                               : Alignment.bottomRight,
                      //                           child: InkWell(
                      //                             onTap: () async {
                      //                               if (cartId == null ||
                      //                                   cartId == studentId) {
                      //                                 try {
                      //                                   if (!cart.idp.contains(
                      //                                       bestDis[i].id)) {
                      //                                     await helper.createCar(
                      //                                         CartProducts(
                      //                                             id: null,
                      //                                             studentId:
                      //                                                 studentId,
                      //                                             image:
                      //                                                 topLikes[i]
                      //                                                     .image,
                      //                                             titleAr:
                      //                                                 topLikes[i]
                      //                                                     .nameAr,
                      //                                             titleEn:
                      //                                                 topLikes[i]
                      //                                                     .nameEn,
                      //                                             price: topLikes[
                      //                                                     i]
                      //                                                 .finalPrice
                      //                                                 .toDouble(),
                      //                                             quantity: 1,
                      //                                             att: att,
                      //                                             des: des,
                      //                                             idp: topLikes[i]
                      //                                                 .id,
                      //                                             idc: 0,
                      //                                             catNameEn: "",
                      //                                             catNameAr: "",
                      //                                             catSVG: ""));
                      //                                   } else {
                      //                                     int quantity = cart
                      //                                         .items
                      //                                         .firstWhere(
                      //                                             (element) =>
                      //                                                 element
                      //                                                     .idp ==
                      //                                                 topLikes[i]
                      //                                                     .id)
                      //                                         .quantity;
                      //                                     await helper
                      //                                         .updateProduct(
                      //                                             1 + quantity,
                      //                                             topLikes[i].id,
                      //                                             topLikes[i]
                      //                                                 .finalPrice
                      //                                                 .toDouble(),
                      //                                             jsonEncode(att),
                      //                                             jsonEncode(
                      //                                                 des));
                      //                                   }
                      //                                   await cart.setItems();
                      //                                 } catch (e) {
                      //                                   print('e');
                      //                                   print(e);
                      //                                 }
                      //                               } else {
                      //                                 if (cartId == null ||
                      //                                     cartId == studentId) {
                      //                                   try {
                      //                                     if (!cart.idp.contains(
                      //                                         topLikes[i].id)) {
                      //                                       await helper.createCar(CartProducts(
                      //                                           id: null,
                      //                                           studentId:
                      //                                               topLikes[i]
                      //                                                   .brands![
                      //                                                       i]
                      //                                                   .id,
                      //                                           image: topLikes[i]
                      //                                               .image,
                      //                                           titleAr: topLikes[
                      //                                                   i]
                      //                                               .nameAr,
                      //                                           titleEn:
                      //                                               topLikes[i]
                      //                                                   .nameEn,
                      //                                           price: topLikes[i]
                      //                                               .price
                      //                                               .toDouble(),
                      //                                           quantity: 1,
                      //                                           att: att,
                      //                                           des: des,
                      //                                           idp: topLikes[i]
                      //                                               .id,
                      //                                           idc: topLikes[i]
                      //                                               .id,
                      //                                           catNameEn: "",
                      //                                           catNameAr: "",
                      //                                           catSVG: ""));
                      //                                     } else {
                      //                                       int quantity = cart
                      //                                           .items
                      //                                           .firstWhere(
                      //                                               (element) =>
                      //                                                   element
                      //                                                       .idp ==
                      //                                                   topLikes[
                      //                                                           i]
                      //                                                       .id)
                      //                                           .quantity;
                      //                                       await helper
                      //                                           .updateProduct(
                      //                                               1 + quantity,
                      //                                               topLikes[i]
                      //                                                   .id,
                      //                                               topLikes[i]
                      //                                                   .finalPrice
                      //                                                   .toDouble(),
                      //                                               jsonEncode(
                      //                                                   att),
                      //                                               jsonEncode(
                      //                                                   des));
                      //                                     }
                      //                                     await cart.setItems();
                      //                                   } catch (e) {
                      //                                     print('e');
                      //                                     print(e);
                      //                                   }
                      //                                 } else {}
                      //                               }
                      //                             },
                      //                             child: CircleAvatar(
                      //                               backgroundColor: mainColor,
                      //                               radius: w * .05,
                      //                               child: Center(
                      //                                 child: Icon(
                      //                                   Icons
                      //                                       .shopping_cart_outlined,
                      //                                   color: Colors.white,
                      //                                   size: w * 0.05,
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: w * 0.4,
                      //                       child: Column(
                      //                         mainAxisSize: MainAxisSize.min,
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           SizedBox(
                      //                             height: h * 0.01,
                      //                           ),
                      //                           Container(
                      //                               width: w * 0.45,
                      //                               constraints: BoxConstraints(
                      //                                 maxHeight: h * 0.07,
                      //                               ),
                      //                               child: Text(
                      //                                   translateString(
                      //                                       topLikes[i].nameEn,
                      //                                       topLikes[i].nameAr),
                      //                                   maxLines: 2,
                      //                                   style: TextStyle(
                      //                                       fontSize: w * 0.035),
                      //                                   overflow: TextOverflow
                      //                                       .ellipsis)),
                      //                           SizedBox(
                      //                             height: h * 0.005,
                      //                           ),
                      //                           Row(
                      //                             crossAxisAlignment:
                      //                                 CrossAxisAlignment.start,
                      //                             mainAxisAlignment:
                      //                                 MainAxisAlignment
                      //                                     .spaceBetween,
                      //                             children: [
                      //                               RichText(
                      //                                 text: TextSpan(
                      //                                   children: [
                      //                                     if (topLikes[i].isSale)
                      //                                       TextSpan(
                      //                                           text:
                      //                                               '${topLikes[i].salePrice} $currency',
                      //                                           style: TextStyle(
                      //                                               fontFamily:
                      //                                                   'Tajawal',
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               color:
                      //                                                   mainColor)),
                      //                                     if (!topLikes[i].isSale)
                      //                                       TextSpan(
                      //                                           text:
                      //                                               '${topLikes[i].price} $currency',
                      //                                           style: TextStyle(
                      //                                               fontFamily:
                      //                                                   'Tajawal',
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               color:
                      //                                                   mainColor)),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                               if (topLikes[i].isSale)
                      //                                 Text(
                      //                                   '${topLikes[i].price} $currency',
                      //                                   style: TextStyle(
                      //                                       fontSize: w * 0.035,
                      //                                       decorationThickness:
                      //                                           w * 0.1,
                      //                                       decoration:
                      //                                           TextDecoration
                      //                                               .lineThrough,
                      //                                       color: Colors.grey,
                      //                                       decorationColor:
                      //                                           mainColor),
                      //                                 ),
                      //                             ],
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               onTap: () async {
                      //                 dialog(context);
                      //                 await getItem(topLikes[i].id);
                      //                 Navigator.pushReplacementNamed(
                      //                     context, 'pro');
                      //               },
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // SizedBox(
                      //   height: h * 0.03,
                      // ),
                      // if (topRate.isNotEmpty)
                      //   Column(
                      //     children: [
                      //       Padding(
                      //         padding:
                      //             EdgeInsets.symmetric(horizontal: w * 0.025),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text(
                      //               translate(context, 'home', 'title8'),
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: w * 0.05,
                      //                   fontFamily: 'Tajawal'),
                      //             ),
                      //             SizedBox(
                      //               width: w * 0.01,
                      //             ),
                      //             InkWell(
                      //               child: Container(
                      //                 decoration: const BoxDecoration(
                      //                   color: Colors.transparent,
                      //                   // borderRadius: isLeft()
                      //                   //     ? const BorderRadius.only(
                      //                   //         bottomLeft: Radius.circular(15),
                      //                   //       )
                      //                   //     : const BorderRadius.only(
                      //                   //         bottomRight: Radius.circular(15),
                      //                   //       ),
                      //                 ),
                      //                 child: Padding(
                      //                   padding: EdgeInsets.all(w * 0.025),
                      //                   child: Row(
                      //                     children: [
                      //                       Container(
                      //                         width: w * 0.2,
                      //                         decoration: BoxDecoration(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(
                      //                                     w * 0.02),
                      //                             color: mainColor),
                      //                         padding: EdgeInsets.symmetric(
                      //                             horizontal: w * 0.02,
                      //                             vertical: h * 0.01),
                      //                         child: Center(
                      //                           child: Text(
                      //                             translate(
                      //                                 context, 'home', 'see'),
                      //                             style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: w * 0.05,
                      //                                 fontWeight:
                      //                                     FontWeight.bold),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //               onTap: () {
                      //                 Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                         builder: (context) => const MoreScreen(
                      //                             endPoint:
                      //                                 "get-topRating-products")));
                      //               },
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: h * 0.03,
                      //       ),
                      //       SizedBox(
                      //         width: w,
                      //         // height: h * 0.4,
                      //         child: GridView.builder(
                      //           itemCount: topRate.length,
                      //           primary: false,
                      //           shrinkWrap: true,
                      //           gridDelegate:
                      //               SliverGridDelegateWithFixedCrossAxisCount(
                      //                   crossAxisSpacing: h * 0.001,
                      //                   mainAxisSpacing: w * 0.05,
                      //                   crossAxisCount: 2,
                      //                   childAspectRatio: 0.8),
                      //           // scrollDirection: Axis.horizontal,
                      //           itemBuilder: (ctx, i) {
                      //             return InkWell(
                      //               child: Padding(
                      //                 padding: isLeft()
                      //                     ? EdgeInsets.only(left: w * 0.025)
                      //                     : EdgeInsets.only(right: w * 0.025),
                      //                 child: Column(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: [
                      //                     Container(
                      //                       width: w * 0.9,
                      //                       height: h * 0.25,
                      //                       decoration: BoxDecoration(
                      //                           color: Colors.grey[200],
                      //                           image: DecorationImage(
                      //                             image: NetworkImage(
                      //                                 topRate[i].image),
                      //                             fit: BoxFit.cover,
                      //                           )),
                      //                       child: Padding(
                      //                         padding: EdgeInsets.all(w * 0.015),
                      //                         child: Align(
                      //                           alignment: isLeft()
                      //                               ? Alignment.bottomLeft
                      //                               : Alignment.bottomRight,
                      //                           child: InkWell(
                      //                             onTap: () async {
                      //                               if (cartId == null ||
                      //                                   cartId == studentId) {
                      //                                 try {
                      //                                   if (!cart.idp.contains(
                      //                                       bestDis[i].id)) {
                      //                                     await helper.createCar(
                      //                                         CartProducts(
                      //                                             id: null,
                      //                                             studentId:
                      //                                                 studentId,
                      //                                             image:
                      //                                                 topRate[i]
                      //                                                     .image,
                      //                                             titleAr:
                      //                                                 topRate[i]
                      //                                                     .nameAr,
                      //                                             titleEn:
                      //                                                 topRate[i]
                      //                                                     .nameEn,
                      //                                             price: topRate[
                      //                                                     i]
                      //                                                 .finalPrice
                      //                                                 .toDouble(),
                      //                                             quantity: 1,
                      //                                             att: att,
                      //                                             des: des,
                      //                                             idp: topRate[i]
                      //                                                 .id,
                      //                                             idc: 0,
                      //                                             catNameEn: "",
                      //                                             catNameAr: "",
                      //                                             catSVG: ""));
                      //                                   } else {
                      //                                     int quantity = cart
                      //                                         .items
                      //                                         .firstWhere(
                      //                                             (element) =>
                      //                                                 element
                      //                                                     .idp ==
                      //                                                 topRate[i]
                      //                                                     .id)
                      //                                         .quantity;
                      //                                     await helper
                      //                                         .updateProduct(
                      //                                             1 + quantity,
                      //                                             topRate[i].id,
                      //                                             topRate[i]
                      //                                                 .finalPrice
                      //                                                 .toDouble(),
                      //                                             jsonEncode(att),
                      //                                             jsonEncode(
                      //                                                 des));
                      //                                   }
                      //                                   await cart.setItems();
                      //                                 } catch (e) {
                      //                                   print('e');
                      //                                   print(e);
                      //                                 }
                      //                               } else {
                      //                                 if (cartId == null ||
                      //                                     cartId == studentId) {
                      //                                   try {
                      //                                     if (!cart.idp.contains(
                      //                                         topRate[i].id)) {
                      //                                       await helper.createCar(CartProducts(
                      //                                           id: null,
                      //                                           studentId:
                      //                                               topRate[i]
                      //                                                   .brands![
                      //                                                       i]
                      //                                                   .id,
                      //                                           image: topRate[i]
                      //                                               .image,
                      //                                           titleAr:
                      //                                               topRate[i]
                      //                                                   .nameAr,
                      //                                           titleEn:
                      //                                               topRate[i]
                      //                                                   .nameEn,
                      //                                           price: topRate[i]
                      //                                               .price
                      //                                               .toDouble(),
                      //                                           quantity: 1,
                      //                                           att: att,
                      //                                           des: des,
                      //                                           idp:
                      //                                               topRate[i].id,
                      //                                           idc:
                      //                                               topRate[i].id,
                      //                                           catNameEn: "",
                      //                                           catNameAr: "",
                      //                                           catSVG: ""));
                      //                                     } else {
                      //                                       int quantity = cart
                      //                                           .items
                      //                                           .firstWhere(
                      //                                               (element) =>
                      //                                                   element
                      //                                                       .idp ==
                      //                                                   topRate[i]
                      //                                                       .id)
                      //                                           .quantity;
                      //                                       await helper
                      //                                           .updateProduct(
                      //                                               1 + quantity,
                      //                                               topRate[i].id,
                      //                                               topRate[i]
                      //                                                   .finalPrice
                      //                                                   .toDouble(),
                      //                                               jsonEncode(
                      //                                                   att),
                      //                                               jsonEncode(
                      //                                                   des));
                      //                                     }
                      //                                     await cart.setItems();
                      //                                   } catch (e) {
                      //                                     print('e');
                      //                                     print(e);
                      //                                   }
                      //                                 } else {}
                      //                               }
                      //                             },
                      //                             child: CircleAvatar(
                      //                               backgroundColor: mainColor,
                      //                               radius: w * .05,
                      //                               child: Center(
                      //                                 child: Icon(
                      //                                   Icons
                      //                                       .shopping_cart_outlined,
                      //                                   color: Colors.white,
                      //                                   size: w * 0.05,
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     SizedBox(
                      //                       width: w * 0.4,
                      //                       child: Column(
                      //                         mainAxisSize: MainAxisSize.min,
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           SizedBox(
                      //                             height: h * 0.01,
                      //                           ),
                      //                           Container(
                      //                               width: w * 0.45,
                      //                               constraints: BoxConstraints(
                      //                                 maxHeight: h * 0.07,
                      //                               ),
                      //                               child: Text(
                      //                                   translateString(
                      //                                       topRate[i].nameEn,
                      //                                       topRate[i].nameAr),
                      //                                   maxLines: 2,
                      //                                   style: TextStyle(
                      //                                       fontSize: w * 0.035),
                      //                                   overflow: TextOverflow
                      //                                       .ellipsis)),
                      //                           SizedBox(
                      //                             height: h * 0.005,
                      //                           ),
                      //                           Row(
                      //                             crossAxisAlignment:
                      //                                 CrossAxisAlignment.start,
                      //                             mainAxisAlignment:
                      //                                 MainAxisAlignment
                      //                                     .spaceBetween,
                      //                             children: [
                      //                               RichText(
                      //                                 text: TextSpan(
                      //                                   children: [
                      //                                     if (topRate[i].isSale)
                      //                                       TextSpan(
                      //                                           text:
                      //                                               '${topRate[i].salePrice} $currency',
                      //                                           style: TextStyle(
                      //                                               fontFamily:
                      //                                                   'Tajawal',
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               color:
                      //                                                   mainColor)),
                      //                                     if (!topRate[i].isSale)
                      //                                       TextSpan(
                      //                                           text:
                      //                                               '${topRate[i].price} $currency',
                      //                                           style: TextStyle(
                      //                                               fontFamily:
                      //                                                   'Tajawal',
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               color:
                      //                                                   mainColor)),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                               if (topRate[i].isSale)
                      //                                 Text(
                      //                                   '${topRate[i].price} $currency',
                      //                                   style: TextStyle(
                      //                                       decorationThickness:
                      //                                           w * 0.1,
                      //                                       fontSize: w * 0.035,
                      //                                       decoration:
                      //                                           TextDecoration
                      //                                               .lineThrough,
                      //                                       color: Colors.grey,
                      //                                       decorationColor:
                      //                                           mainColor),
                      //                                 ),
                      //                             ],
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               onTap: () async {
                      //                 dialog(context);
                      //                 await getItem(topRate[i].id);
                      //                 Navigator.pushReplacementNamed(
                      //                     context, 'pro');
                      //               },
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      SizedBox(
                        height: h * 0.04,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }));
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
