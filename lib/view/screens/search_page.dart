import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sam_beckman/controller/searchController.dart';
import 'package:sam_beckman/view/constants.dart';
import 'package:sam_beckman/view/screens/apps_details_page.dart';
import 'package:sam_beckman/view/widgets/bottom_navigation_bar.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';
import 'package:sam_beckman/view/widgets/search_page/apps_display_container.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key, required this.filterValue}) : super(key: key);

  String filterValue;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(2),
        body: SearchPageBody(
          filterValue: widget.filterValue,
        ),
      ),
    );
  }
}

class SearchPageBody extends StatefulWidget {
  SearchPageBody({Key? key, required this.filterValue}) : super(key: key);

  String filterValue;

  @override
  State<SearchPageBody> createState() => _SearchPageBodyState();
}

class _SearchPageBodyState extends State<SearchPageBody> {
  TextEditingController? _searchController = new TextEditingController();
  searchController controller = Get.put(searchController());
  @override
  void initState() {
    controller.appList.clear();
    controller.searchList.clear();
    controller.Getapps();
    controller.popular.value = false;
    controller.older.value = false;
    controller.latest.value = false;
    controller.searchitem.value = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Find Your Favourite',
              fontWeight: FontWeight.w700,
              size: ScreenUtil().setSp(28),
              color: SchedulerBinding.instance.window.platformBrightness ==
                      Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            CustomText(
                text: 'Application',
                fontWeight: FontWeight.w700,
                size: ScreenUtil().setSp(28),
                color: Theme.of(context).primaryColor),
            SizedBox(height: 14.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.h),
                  // outlined border for search bar
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          SchedulerBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                      width: 1.h,
                    ),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      SizedBox(
                        width: 160.w,
                        height: 19.h,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              controller.popular.value = false;
                              controller.older.value = false;
                              controller.latest.value = false;
                              controller.searchitem.value = true;
                              controller.searchList = controller.appList
                                  .where((app) => app.applicationTitle
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                              print(controller.searchitem.value);
                            });
                          },
                          controller: _searchController,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Search',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5)
                      ]),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 42.h,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: '${widget.filterValue}',
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      iconSize: 24.h,
                      style: const TextStyle(color: Colors.black),
                      underline: null,
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue == 'Older') {
                            controller.appList.clear();
                            controller.GetOlder();
                            controller.popular.value = false;
                            controller.older.value = true;
                            controller.latest.value = false;
                            controller.searchitem.value = false;
                          } else if (newValue == 'Latest') {
                            controller.appList.clear();
                            controller.GetLatest();
                            controller.popular.value = false;
                            controller.older.value = false;
                            controller.latest.value = true;
                            controller.searchitem.value = false;
                          } else if (newValue == 'Popularity') {
                            controller.appList.clear();
                            controller.GetPopular();
                            controller.popular.value = true;
                            controller.older.value = true;
                            controller.latest.value = false;
                            controller.searchitem.value = false;
                          } else {
                            controller.appList.clear();
                            controller.Getapps();
                            controller.popular.value = false;
                            controller.older.value = false;
                            controller.latest.value = false;
                            controller.searchitem.value = false;
                          }
                        });
                      },
                      items: <String>[
                        'Filter By',
                        'Latest',
                        'Older',
                        'Popularity',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontFamily: 'Satoshi',
                              color: SchedulerBinding
                                          .instance.window.platformBrightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20.h),
            CustomText(
              text: 'Suggested',
              size: 20.sp,
              fontWeight: FontWeight.w700,
              color: SchedulerBinding.instance.window.platformBrightness ==
                      Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            SizedBox(height: 18.h),
            controller.older.value == false ||
                    controller.latest.value == false ||
                    controller.popular.value == false ||
                    controller.searchitem.value == false
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Obx(() => (ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.searchitem.value
                            ? controller.searchList.length
                            : controller.appList.length,
                        itemBuilder: (context, index) => controller
                                .searchitem.value
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AppsDetailsPage(
                                                color: controller.searchList
                                                    .elementAt(index)
                                                    .color,
                                                searchpage: true,
                                                link: controller.searchList
                                                    .elementAt(index)
                                                    .link,
                                                developer: controller.searchList
                                                    .elementAt(index)
                                                    .developer,
                                                description: controller
                                                    .searchList
                                                    .elementAt(index)
                                                    .description,
                                                appId: controller.searchList
                                                    .elementAt(index)
                                                    .appId,
                                                applicationTitle: controller
                                                    .searchList
                                                    .elementAt(index)
                                                    .applicationTitle,
                                                category: controller.searchList
                                                    .elementAt(index)
                                                    .category,
                                                iconName: controller.searchList
                                                    .elementAt(index)
                                                    .iconName,
                                                ratting: controller.searchList
                                                    .elementAt(index)
                                                    .ratting)));
                                  });
                                },
                                child: AppDisplayBox(
                                  color: controller.searchList
                                      .elementAt(index)
                                      .color,
                                  applicationTitle: controller.searchList
                                      .elementAt(index)
                                      .applicationTitle,
                                  category: controller.searchList
                                      .elementAt(index)
                                      .category,
                                  backgroundColor: kAppIconsColors[index],
                                  iconName: controller.searchList
                                      .elementAt(index)
                                      .iconName,
                                  appId: controller.searchList
                                      .elementAt(index)
                                      .appId,
                                  description: controller.searchList
                                      .elementAt(index)
                                      .description,
                                  ratting: controller.searchList
                                      .elementAt(index)
                                      .ratting
                                      .toString(),
                                  developer: controller.searchList
                                      .elementAt(index)
                                      .developer
                                      .toString(),
                                  link: controller.searchList
                                      .elementAt(index)
                                      .link
                                      .toString(),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AppsDetailsPage(
                                                color: controller.appList
                                                    .elementAt(index)
                                                    .color,
                                                searchpage: true,
                                                link: controller.appList
                                                    .elementAt(index)
                                                    .link,
                                                developer: controller.appList
                                                    .elementAt(index)
                                                    .developer,
                                                description: controller.appList
                                                    .elementAt(index)
                                                    .description,
                                                appId: controller.appList
                                                    .elementAt(index)
                                                    .appId,
                                                applicationTitle: controller
                                                    .appList
                                                    .elementAt(index)
                                                    .applicationTitle,
                                                category: controller.appList
                                                    .elementAt(index)
                                                    .category,
                                                iconName: controller.appList
                                                    .elementAt(index)
                                                    .iconName,
                                                ratting: controller.appList
                                                    .elementAt(index)
                                                    .ratting)));
                                  });
                                },
                                child: AppDisplayBox(
                                  color:
                                      controller.appList.elementAt(index).color,
                                  applicationTitle: controller.appList
                                      .elementAt(index)
                                      .applicationTitle,
                                  category: controller.appList
                                      .elementAt(index)
                                      .category,
                                  backgroundColor: kAppIconsColors[index],
                                  iconName: controller.appList
                                      .elementAt(index)
                                      .iconName,
                                  appId:
                                      controller.appList.elementAt(index).appId,
                                  description: controller.appList
                                      .elementAt(index)
                                      .description,
                                  ratting: controller.appList
                                      .elementAt(index)
                                      .ratting
                                      .toString(),
                                  developer: controller.appList
                                      .elementAt(index)
                                      .developer
                                      .toString(),
                                  link: controller.appList
                                      .elementAt(index)
                                      .link
                                      .toString(),
                                ))))),
                  )
                : Container(),
            controller.older.value
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Obx(() => ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.appList.length,
                        itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AppsDetailsPage(
                                            color: controller.appList
                                                .elementAt(index)
                                                .color,
                                            searchpage: true,
                                            link: controller.appList
                                                .elementAt(index)
                                                .link,
                                            developer: controller.appList
                                                .elementAt(index)
                                                .developer,
                                            description: controller.appList
                                                .elementAt(index)
                                                .description,
                                            appId: controller.appList
                                                .elementAt(index)
                                                .appId,
                                            applicationTitle: controller.appList
                                                .elementAt(index)
                                                .applicationTitle,
                                            category: controller.appList
                                                .elementAt(index)
                                                .category,
                                            iconName: controller.appList
                                                .elementAt(index)
                                                .iconName,
                                            ratting: controller.appList
                                                .elementAt(index)
                                                .ratting)));
                              });
                            },
                            child: AppDisplayBox(
                              color: controller.appList.elementAt(index).color,
                              applicationTitle: controller.appList
                                  .elementAt(index)
                                  .applicationTitle,
                              category:
                                  controller.appList.elementAt(index).category,
                              backgroundColor: kAppIconsColors[index],
                              iconName:
                                  controller.appList.elementAt(index).iconName,
                              appId: controller.appList.elementAt(index).appId,
                              description: controller.appList
                                  .elementAt(index)
                                  .description,
                              ratting: controller.appList
                                  .elementAt(index)
                                  .ratting
                                  .toString(),
                              developer: controller.appList
                                  .elementAt(index)
                                  .developer
                                  .toString(),
                              link: controller.appList
                                  .elementAt(index)
                                  .link
                                  .toString(),
                            )))))
                : Container(),
            controller.latest.value
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Obx(() => ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.appList.length,
                        itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AppsDetailsPage(
                                            color: controller.appList
                                                .elementAt(index)
                                                .color,
                                            searchpage: true,
                                            link: controller.appList
                                                .elementAt(index)
                                                .link,
                                            developer: controller.appList
                                                .elementAt(index)
                                                .developer,
                                            description: controller.appList
                                                .elementAt(index)
                                                .description,
                                            appId: controller.appList
                                                .elementAt(index)
                                                .appId,
                                            applicationTitle: controller.appList
                                                .elementAt(index)
                                                .applicationTitle,
                                            category: controller.appList
                                                .elementAt(index)
                                                .category,
                                            iconName: controller.appList
                                                .elementAt(index)
                                                .iconName,
                                            ratting: controller.appList
                                                .elementAt(index)
                                                .ratting)));
                              });
                            },
                            child: AppDisplayBox(
                              color: controller.appList.elementAt(index).color,
                              applicationTitle: controller.appList
                                  .elementAt(index)
                                  .applicationTitle,
                              category:
                                  controller.appList.elementAt(index).category,
                              backgroundColor: kAppIconsColors[index],
                              iconName:
                                  controller.appList.elementAt(index).iconName,
                              appId: controller.appList.elementAt(index).appId,
                              description: controller.appList
                                  .elementAt(index)
                                  .description,
                              ratting: controller.appList
                                  .elementAt(index)
                                  .ratting
                                  .toString(),
                              developer: controller.appList
                                  .elementAt(index)
                                  .developer
                                  .toString(),
                              link: controller.appList
                                  .elementAt(index)
                                  .link
                                  .toString(),
                            )))))
                : Container(),
            controller.popular.value
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Obx(() => ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.appList.length,
                        itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AppsDetailsPage(
                                            color: controller.appList
                                                .elementAt(index)
                                                .color,
                                            searchpage: true,
                                            link: controller.appList
                                                .elementAt(index)
                                                .link,
                                            developer: controller.appList
                                                .elementAt(index)
                                                .developer,
                                            description: controller.appList
                                                .elementAt(index)
                                                .description,
                                            appId: controller.appList
                                                .elementAt(index)
                                                .appId,
                                            applicationTitle: controller.appList
                                                .elementAt(index)
                                                .applicationTitle,
                                            category: controller.appList
                                                .elementAt(index)
                                                .category,
                                            iconName: controller.appList
                                                .elementAt(index)
                                                .iconName,
                                            ratting: controller.appList
                                                .elementAt(index)
                                                .ratting)));
                              });
                            },
                            child: AppDisplayBox(
                              color: controller.appList.elementAt(index).color,
                              applicationTitle: controller.appList
                                  .elementAt(index)
                                  .applicationTitle,
                              category:
                                  controller.appList.elementAt(index).category,
                              backgroundColor: kAppIconsColors[index],
                              iconName:
                                  controller.appList.elementAt(index).iconName,
                              appId: controller.appList.elementAt(index).appId,
                              description: controller.appList
                                  .elementAt(index)
                                  .description,
                              ratting: controller.appList
                                  .elementAt(index)
                                  .ratting
                                  .toString(),
                              developer: controller.appList
                                  .elementAt(index)
                                  .developer
                                  .toString(),
                              link: controller.appList
                                  .elementAt(index)
                                  .link
                                  .toString(),
                            )))))
                : Container(),
          ],
        ),
      ),
    );
  }
}

class App {
  App(
      {this.reviews,
      this.applicationTitle,
      this.category,
      this.iconName,
      this.appId,
      this.description,
      this.ratting,
      this.developer,
      this.link,
      this.publish,
      this.imagePath,
      this.color});
  String? color;
  String? imagePath;
  String? publish;
  String? applicationTitle;
  String? category;
  String? iconName;
  String? appId;
  String? description;
  String? ratting;
  String? developer;
  String? link;
  String? reviews;
}
