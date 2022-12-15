import 'package:flutter/material.dart';
import '../constants/common.dart' as common;
import '../constants/constants.dart' as constants;
import '../widgets/profile_image.dart';
import '../widgets/pvp_profile.dart';
import '../widgets/pvp_list.dart';
import '../widgets/pvp_score.dart';

void main() {
  runApp(const MaterialApp(
    home: PvpPage(),
  ));
}

class PvpPage extends StatelessWidget {
  const PvpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              decoration: const BoxDecoration(
                color: common.greyColor,
              ),
              child: Column(
                children: [
                  PvpProfile(
                    imageSize: 80,
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    leading:
                        const ProfileImage(80, 'assets/images/profile1.png'),
                    contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    title: Text(
                      'Hello, 엠마!',
                      style: TextStyle(
                        fontSize: common.h1Size,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    subtitle: Text(
                      '오늘은 누구랑 대결할까요?',
                      style: TextStyle(
                        fontSize: common.h3Size,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff30c665),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const PvpScore(
                    wins: 47,
                    loses: 0,
                    backgroundColor: common.greyColor,
                    width: double.infinity,
                    fontWeight: FontWeight.bold,
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    fontSize: 38.0,
                  ),
                ],
              )),
          PvpList(),
        ],
      ),
    );
  }
}
