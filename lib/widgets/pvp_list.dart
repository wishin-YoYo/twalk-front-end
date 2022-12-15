import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:twalk_app/constants/common.dart';
import 'package:twalk_app/logics/wishin_api_caller.dart';
import '../constants/common.dart' as common;
import './profile_image.dart';
import './pvp_profile.dart';
import './pvp_score.dart';

class PvpList extends StatefulWidget {
  PvpList({Key? key}) : super(key: key);

  @override
  State<PvpList> createState() => _PvpListState();
}

class _PvpListState extends State<PvpList> {
  // final List<PvpListEntity> pvpListEntries = [1,2,3];
  final pvpListEntries = [1, 2, 3];
  final entityColors = common.harmonyColors;

  List<dynamic> _pvpHistory = [];

  @override
  void initState() {
    WishinApiCaller.getPvpHistory(1).then((response) {
      setState(() {
        _pvpHistory = response["result"]["data"];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      padding: EdgeInsets.all(0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _pvpHistory.length,
      itemBuilder: (c, i) {
        final entry = _pvpHistory[i];
        var win = true;
        if (entry["winner"] != null) {
          if (entry["winner"]["id"] != 1) {
            win = false;
          }
        }
        return PvpListEntity(
            title: entry["requester"]["id"] == 1
                ? entry["receiver"]["name"]
                : entry["requester"]["name"],
            subtitle:
                '마포구 대흥동, ${Jiffy(DateTime.parse(entry["createdAt"].toString())).fromNow()}',
            leftText: win ? "승리" : "패배",
            leftIcon: win
                ? Icons.thumb_up_alt_outlined
                : Icons.thumb_down_alt_outlined,
            rightText: "${(Random().nextDouble() * 5).toStringAsFixed(1)} km",
            profileImage: 'assets/images/profile${entry["id"] % 10 + 1}.png',
            backgroundColor: entityColors[i % entityColors.length]);
      },
        ));
  }
}

class PvpListEntity extends StatelessWidget {
  const PvpListEntity(
      {Key? key,
      this.title = "",
      this.subtitle = "",
      this.leftText = "",
      this.rightText = "",
      this.leftIcon = Icons.thumb_up_alt_outlined,
      this.rightIcon = Icons.turn_sharp_right,
      this.profileImage = "assets/images/profile1.png",
      this.backgroundColor = Colors.white})
      : super(key: key);

  final String title;
  final String subtitle;
  final String leftText;
  final String rightText;
  final IconData leftIcon;
  final IconData rightIcon;
  final String profileImage;
  final Color backgroundColor;

  static final buttonStyle = ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: Color.fromRGBO(255, 255, 255, 0.3),
    shadowColor: Colors.transparent,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
      elevation: 4.0,
      shape: const RoundedRectangleBorder(
        //모서리를 둥글게 하기 위해 사용
        borderRadius: BorderRadius.all(radiusCircular),
      ),
      child: Column(
        children: [
          PvpProfile(
            leading: ProfileImage(80, profileImage),
            title: Text(
              title,
              style: TextStyle(
                fontSize: (common.h1Size + 2 * common.h2Size) / 3,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                fontSize: common.h3Size,
                color: Colors.black87,
              ),
            ),
            // subtitle: PvpScore(
            //   wins: 100,
            //   loses: 50,
            //   fontSize: 15.0,
            // ),
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(
                  leftIcon,
                  color: common.blackColor,
                ),
                label: Text(
                  leftText,
                  style: TextStyle(
                      color: common.blackColor, fontSize: common.h3Size),
                ),
                style: buttonStyle),
            SizedBox(width: 15),
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(rightIcon, color: common.blackColor),
                label: Text(rightText,
                    style: TextStyle(
                        color: common.blackColor, fontSize: common.h3Size)),
                style: buttonStyle),
          ]),
        ],
      ),
    );
  }
}
