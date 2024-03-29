import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:sam_beckman/view/screens/curated/addCuratedApps.dart';
import 'package:sam_beckman/view/screens/curated/postCuratedView.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';

import '../../../controller/usersController.dart';
import '../../widgets/bottom_navigation_bar.dart';

class CuratedAppsView extends StatefulWidget {
  CuratedAppsView(
      {Key? key,
      required this.appsList,
      required this.appsIconsList,
      required this.dialog,
      required this.shelfName,
      required this.linkUrl,
      required this.selectedColor})
      : super(key: key);

  var appsList;
  var appsIconsList;
  bool dialog;
  var shelfName;
  var linkUrl;
  var selectedColor;

  @override
  State<CuratedAppsView> createState() => _CuratedAppsViewState();
}

class _CuratedAppsViewState extends State<CuratedAppsView>
    with SingleTickerProviderStateMixin {
  Future<bool> _onBackPressed() {
    return Future.delayed(Duration(milliseconds: 1), () {
      return false;
    });
  }

  var currentUser = FirebaseAuth.instance.currentUser;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');

  TextEditingController _shelfNameController = new TextEditingController();
  TextEditingController _linkUrlController = new TextEditingController();
  var selectedColor = Color(0xffd25250);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _shelfNameController.text = widget.shelfName;
      _linkUrlController.text = widget.linkUrl;
      selectedColor = widget.selectedColor;
      widget.dialog ? getDialog() : null;
    });
  }

  var imagePath =
      "https://firebasestorage.googleapis.com/v0/b/sam-beckman.appspot.com/o/profile_images%2Fuser.png?alt=media&token=e7caad03-ed4d-48e7-b4c6-0e71ba0ae28a";

  @override
  Widget build(BuildContext context) {
    int i = 0;

    return SafeArea(
        child: ScreenUtilInit(
            designSize: const Size(360, 800),
            builder: () => WillPopScope(
                onWillPop: _onBackPressed,
                child: Scaffold(
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.35),
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset: Offset(0, 8), // changes position of shadow
                        ),
                      ],
                    ),
                    width: 150.w,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 4,
                        shadowColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      onPressed: getDialog,
                      child: Text(  
                        'Add New',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                        ),
                      ),
                    ),
                  ),
                    bottomNavigationBar: CustomBottomNavigationBar(1),
                    body: FutureBuilder(
                        future: userdata(),
                        builder: (context, snapshot) {
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 20, 10, 20),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Your Application ',
                                        style: TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
                                          fontSize: ScreenUtil().setSp(28),
                                          color: SchedulerBinding
                                                      .instance
                                                      .window
                                                      .platformBrightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Shelves ',
                                        style: TextStyle(
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w600,
                                            fontSize: ScreenUtil().setSp(28),
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('curated')
                                      .doc(currentUser!.uid)
                                      .collection('curatedApps')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView(
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          children: snapshot.data!.docs
                                              .map((document) {
                                            if (snapshot.hasData) {
                                              i++;
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async{
                                                      var appsList =  await getCuratedApps(document.id);
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) => PostCuratedView(appsList: appsList, docId: document.id,)));
                                                    },
                                                    child: Container(
                                                      width: 300.w,
                                                      height: 100.h,
                                                      decoration: BoxDecoration(
                                                          color: Color(int.parse(
                                                                  '0xff${document['color']}'))
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10))),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          SizedBox(width: 20,),
                                                          SizedBox(
                                                            height: 50,
                                                            width: 50,
                                                            child: Image.asset('assets/icons/books.png')),
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                                            child: CustomText(
                                                                text:
                                                                    document['shelfName'],
                                                                size: 18.sp,
                                                                color: SchedulerBinding
                                                                            .instance
                                                                            .window
                                                                            .platformBrightness ==
                                                                        Brightness.dark
                                                                    ? Colors.white
                                                                    : Colors.black,
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20.h,)
                                                ],
                                              );
                                            } else
                                              return Column(
                                                children: [
                                                  SizedBox(
                                                    height: 60.h,
                                                  ),
                                                  Image.asset(
                                                    'assets/images/smartphone.png',
                                                    width: 200.w,
                                                    height: 200.h,
                                                  ),
                                                  SizedBox(
                                                    height: 35.h,
                                                  ),
                                                  CustomText(
                                                    text:
                                                        'Curate your own unique list of applications',
                                                    size: 14.sp,
                                                    color: SchedulerBinding
                                                                .instance
                                                                .window
                                                                .platformBrightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  SizedBox(
                                                    height: 70.h,
                                                  ),
                                                ],
                                              );
                                          }).toList());
                                    } else
                                      return Container();
                                  }),
                                  
                            ],
                          );
                        })))));
  }

  getCurated() async {
    List<dynamic> curatedList = <dynamic>[];
    var auth = FirebaseAuth.instance;
    var collection = FirebaseFirestore.instance
        .collection('curated')
        .doc(currentUser!.uid)
        .collection('curatedApps');

    var Mapapps = await collection.doc().get();

    List Listapps = [];

    Mapapps.data() == null ? null : Listapps = Mapapps.data()!['appList'];
    curatedList.isEmpty
        ? Listapps.forEach((element) {
            curatedList.add(element['applicationTitle'].toString());
          })
        : null;
    return curatedList;
  }

  addList() async {
    var collectionCurated = FirebaseFirestore.instance
        .collection('curated')
        .doc(currentUser!.uid)
        .collection('curatedApps');

    final json = {
      "color": selectedColor.toString().substring(10, 16),
      "linkUrl": _linkUrlController.text,
      "shelfName": _shelfNameController.text,
      "apps": widget.appsList,
    };

    await collectionCurated.add(json);
    Navigator.pop(context);
  }

  userdata() async {
    var user = await collectionReference.doc(currentUser!.uid).get();
    imagePath = user['imagePath'].toString();
    return user['imagePath'].toString();
  }

  getDialog() {
    List<Color> _colorsList = [
      Color(0xffd25250),
      Color(0xfff4ad89),
      Color(0xfffff6a6),
      Color(0xffacd2a0),
      Color(0xff84cff0),
      Color(0xff8685b5),
      Color(0xffea9ba0)
    ];

    return showDialog(
        context: context,
        builder: (ctx) => Center(
                child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    'Shelf Name',
                                    style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: 11.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    "*",
                                    style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: 11.sp,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 50,
                              color: Colors.transparent,
                              child: Center(
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: Color.fromARGB(255, 243, 243, 243),
                                  child: TextFormField(
                                    controller: _shelfNameController,
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      color: Color(0xffa3a3a3),
                                      fontSize: 12.sp,
                                    ),
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        border: InputBorder.none,
                                        hintText: "i.e \"Customization\"",
                                        hintStyle: TextStyle(
                                          fontFamily: 'Satoshi',
                                          color: Color(0xffa3a3a3),
                                          fontSize: 12.sp,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: Text(
                                'Select Apps',
                                style: TextStyle(
                                    fontFamily: 'Satoshi',
                                    fontSize: 11.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.35),
                                      spreadRadius: 1,
                                      blurRadius: 15,
                                      offset: Offset(
                                          2, 6), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: 40,
                                height: 40,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AddCuratedApps(
                                                appsList: widget.appsList,
                                                appsIconsList:
                                                    widget.appsIconsList,
                                                shelfName:
                                                    _shelfNameController.text,
                                                linkUrl:
                                                    _linkUrlController.text,
                                                selectedColor: selectedColor)));
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 14.sp,
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 4,
                                    shadowColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 20.h,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5,
                                            crossAxisSpacing: 2,
                                            mainAxisSpacing: 10),
                                    itemCount: widget.appsIconsList.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 8),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.7),
                                                    spreadRadius: 4,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                                shape: BoxShape.circle,
                                                color: const Color.fromARGB(
                                                    15, 55, 180, 78),
                                                image: DecorationImage(
                                                    image: NetworkImage(widget
                                                        .appsIconsList[index])),
                                              ),
                                            ),
                                            Container(
                                                height: 43,
                                                width: 43,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.transparent),
                                                child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        widget.appsList
                                                            .removeAt(index);
                                                        widget.appsIconsList
                                                            .removeAt(index);
                                                        Navigator
                                                            .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        CuratedAppsView(
                                                                          appsList:
                                                                              widget.appsList,
                                                                          appsIconsList:
                                                                              widget.appsIconsList,
                                                                          dialog:
                                                                              true,
                                                                          shelfName:
                                                                              _shelfNameController.text,
                                                                          linkUrl:
                                                                              _linkUrlController.text,
                                                                          selectedColor:
                                                                              selectedColor,
                                                                        )));
                                                      },
                                                      child: Container(
                                                          height: 12.h,
                                                          width: 12.w,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color(
                                                                  0xfff3f3f3)),
                                                          child: Icon(
                                                            Icons.close,
                                                            size: 9.sp,
                                                            color: Colors.black,
                                                          )),
                                                    ))),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: Text(
                                'Custom Application? Enter it\'s URL:',
                                style: TextStyle(
                                    fontFamily: 'Satoshi',
                                    fontSize: 11.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 50,
                              color: Colors.transparent,
                              child: Center(
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: Color.fromARGB(255, 243, 243, 243),
                                  child: TextFormField(
                                    controller: _linkUrlController,
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      color: Color(0xffa3a3a3),
                                      fontSize: 12.sp,
                                    ),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.all(10),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: Text(
                                'List Colour',
                                style: TextStyle(
                                    fontFamily: 'Satoshi',
                                    fontSize: 11.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20.w, 0, 10.w, 0),
                              child: Container(
                                height: 50.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _colorsList.length,
                                  itemBuilder: (context, index) {
                                    print("colorrrrrrrrrrrrrrrrrrrr");
                                    return Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            selectedColor = _colorsList[index];
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        CuratedAppsView(
                                                          appsList:
                                                              widget.appsList,
                                                          appsIconsList: widget
                                                              .appsIconsList,
                                                          dialog: true,
                                                          shelfName:
                                                              _shelfNameController
                                                                  .text,
                                                          linkUrl:
                                                              _linkUrlController
                                                                  .text,
                                                          selectedColor:
                                                              selectedColor,
                                                        )));
                                          },
                                          child: Container(
                                            width: 25.0,
                                            height: 25.0,
                                            decoration: new BoxDecoration(
                                              border: selectedColor ==
                                                      _colorsList[index]
                                                  ? Border.all(
                                                      color: Colors.black)
                                                  : Border.all(
                                                      color:
                                                          Colors.transparent),
                                              color: _colorsList[index],
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.35),
                                      spreadRadius: 1,
                                      blurRadius: 15,
                                      offset: Offset(
                                          0, 8), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: 130.w,
                                child: TextButton(
                                  onPressed: addList,
                                  child: Text(
                                    'Create List',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: SchedulerBinding.instance.window
                                                  .platformBrightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 4,
                                    shadowColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 30.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage(imagePath))),
                  ),
                ],
              ),
            )));
  }

  
   Future<List<String>> getCuratedApps(docUid) async {
    List<String> appsList = <String>[];
    var auth = FirebaseAuth.instance;
    var collection = FirebaseFirestore.instance
        .collection('curated')
        .doc(currentUser!.uid)
        .collection('curatedApps');

    var Mapapps = await collection.doc(docUid).get();
    List Listapps = [];
    Mapapps.data() == null ? null : Listapps = Mapapps.data()!['apps'];
    appsList.isEmpty
        ? Listapps.forEach((element) {
            appsList.add(element.toString());
          })
        : null;
    print(appsList.toList().toString());
    return appsList;
  }

}

// class CuratedAppsViewBody extends StatefulWidget {
//   CuratedAppsViewBody({Key? key, required this.appsList, required this.appsIconsList, required this.dialog, required this.shelfName, required this.linkUrl, required this.selectedColor}) : super(key: key);

//   var appsList;
//   var appsIconsList;
//   bool dialog;
//   var shelfName;
//   var linkUrl;
//   var selectedColor;

//               // floatingActionButton: Container(
//               //   decoration: BoxDecoration(
//               //       boxShadow: [
//               //       BoxShadow(
//               //         color: Theme.of(context).primaryColor.withOpacity(0.35),
//               //         spreadRadius: 1,
//               //         blurRadius: 15,
//               //         offset: Offset(0, 8), // changes position of shadow
//               //       ),
//               //     ],
//               //   ),
//               //   width: 150.w,
//               //   child: TextButton(
//               //     style: TextButton.styleFrom(
//               //       padding: EdgeInsets.symmetric(vertical: 14.h),
//               //       backgroundColor: Theme.of(context).primaryColor,
//               //       elevation: 4,
//               //       shadowColor: Theme.of(context).primaryColor,
//               //       shape: RoundedRectangleBorder(
//               //         borderRadius: BorderRadius.circular(20.r),
//               //       ),
//               //     ),
//               //     onPressed: getDialog,
//               //     child: Text(  
//               //       'Add New',
//               //       style: TextStyle(
//               //         fontSize: 16.sp,
//               //         fontWeight: FontWeight.w500,
//               //         color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
//               //         ? Colors.white
//               //         : Colors.black,
//               //       ),
//               //     ),
//               //   ),
//               // ),

//   @override
//   State<CuratedAppsViewBody> createState() => _CuratedAppsViewBodyState();
// }

// class _CuratedAppsViewBodyState extends State<CuratedAppsViewBody> {
//   var currentUser = FirebaseAuth.instance.currentUser;

//   CollectionReference collectionReference =
//       FirebaseFirestore.instance.collection('users');

      
//   TextEditingController _shelfNameController = new TextEditingController();
//   TextEditingController _linkUrlController = new TextEditingController();
//   var selectedColor = Color(0xffd25250);


//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       _shelfNameController.text = widget.shelfName;
//       _linkUrlController.text = widget.linkUrl;
//       selectedColor = widget.selectedColor;
//       widget.dialog ? getDialog() : null;
//    });

//   }

//   var imagePath = "https://firebasestorage.googleapis.com/v0/b/sam-beckman.appspot.com/o/profile_images%2Fuser.png?alt=media&token=e7caad03-ed4d-48e7-b4c6-0e71ba0ae28a";
  

//   @override
//   Widget build(BuildContext context) {
//     int i = 0;

//     return 
//   }


// }