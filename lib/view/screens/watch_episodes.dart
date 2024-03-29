import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sam_beckman/controller/favController.dart';
import 'package:sam_beckman/controller/searchController.dart';
import 'package:sam_beckman/view/screens/search_page.dart';
import 'package:sam_beckman/view/widgets/apps_details/icon_with_texts.dart';
import 'package:sam_beckman/view/widgets/bottom_navigation_bar.dart';
import 'package:sam_beckman/view/widgets/rating_dialogue.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../widgets/custom_text.dart';
import '../widgets/episodeIconsText.dart';
import 'home_page.dart';

class watch_episodes extends StatefulWidget {
  watch_episodes(
      {this.ratting,
        this.description,
        this.appId,
        this.category,
        this.applicationTitle,
        this.iconName,this.developer,this.link,this.searchpage,this.video});
  final String? appId;
  final String? applicationTitle;
  final String? category;
  final String? iconName;
  final String? description;
  final String? ratting;
  final String? developer;
  final String? link;
  final bool? searchpage;
  final String? video;

  @override
  State<watch_episodes> createState() => _watch_episodesState(
      description: description,
      appId: appId,
      applicationTitle: applicationTitle,
      category: category,
      iconName: iconName,
      ratting: ratting,developer: developer,link: link,searchPage: searchpage,video: video);
}

class _watch_episodesState extends State<watch_episodes> {
  _watch_episodesState(
      {this.ratting,
        this.description,
        this.appId,
        this.category,
        this.applicationTitle,
        this.iconName,this.developer,this.link,this.searchPage,this.video});
  final String? link;
  final String? appId;
  final String? applicationTitle;
  final String? category;
  final String? iconName;
  final String? description;
  final String? ratting;
  final String?developer;
  final bool? searchPage;
  final String? video;
  @override
  Widget build(BuildContext context) {
    print("Vid Thereeeeeeeee" + widget.video.toString());
    return SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: () => Scaffold(
            body: watch_episodesBody(
              description: description,
              appId: appId,
              applicationTitle: applicationTitle,
              category: category,
              iconName: iconName,
              ratting: ratting,developer: developer,link: link,searchPage: searchPage,video: video,)),
      ),
    );
  }
}

class watch_episodesBody extends StatefulWidget {
  watch_episodesBody(
      {this.ratting,
        this.description,
        this.appId,
        this.category,
        this.applicationTitle,
        this.iconName,this.link,this.developer,this.searchPage,this.video});
  final String? appId;
  final String? applicationTitle;
  final String? category;
  final String? iconName;
  final String? description;
  final String? ratting;
  final String? link;
  final String? developer;
  final bool? searchPage;
  final String? video;
  @override
  State<watch_episodesBody> createState() => _watch_episodesBodyState();
}

class _watch_episodesBodyState extends State<watch_episodesBody> {
  bool detail=true;
  YoutubePlayerController ?_controller;

  @override
  void initState() {
    super.initState();
    print(widget.video.toString());
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.video.toString())!,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.h),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      searchController controller=new searchController();
                      controller.appList.clear();
                      controller.searchList.clear();
                      controller.Getapps();
                      controller.popular.value = false;
                      controller.older.value = false;
                      controller.latest.value = false;
                      controller.searchitem.value = false;
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0.r),
                          side: const BorderSide(color: Colors.grey),
                        )),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        CustomText(
                          text: 'Back',
                          size: 12.sp,
                          fontWeight: FontWeight.w500,
                          color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    height: 300.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.red
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: YoutubePlayer(
                        controller: _controller!,
                        showVideoProgressIndicator: true,
                        onReady: () {
                          print('Player is ready.');
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                          },
                          child: episodeIconsWithTexts(
                            isView: true,
                            isLike: false,
                            title: 'View',
                            iconName: 'download',
                            subtitle: '40k',
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: (){
                          },
                          child: episodeIconsWithTexts(
                            isView: false,
                            isLike:true,
                            title: 'Like',
                            iconName: 'download',
                            subtitle: '10k',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: episodeIconsWithTexts(
                          isLike: false,
                          isView:false,
                          title: 'Upload Date',
                          iconName: 'download',
                          subtitle: '11-Feb, 2022',
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible:detail,
                    child: Column(children:[SizedBox(height: 33.h),
                      ReadMoreText(
                        '${widget.description}',
                        trimLines: 6,
                        colorClickableText:Theme.of(context).primaryColor,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Read more',
                        trimExpandedText: 'Read less',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp
                        ),
                        moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),
                      ),
                      //
                      SizedBox(height: 14.h),
                        ],
                      )
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              Home()));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: CustomText(
                    text: 'View Featured Apps',
                    size: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
