import 'package:flutter/material.dart';
import '../constants/common.dart' as common;
import '../constants/constants.dart' as constants;
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
  final entityColors = const [
    Color.fromARGB(255, 218, 236, 233),
    Color.fromARGB(255, 246, 240, 235),
    Color.fromARGB(255, 233, 235, 243),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      padding: EdgeInsets.all(0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 6,
      itemBuilder: (c, i) {
        return PvpListEntity(entityColors[i % entityColors.length]);
      },
    ));
  }
}

class PvpListEntity extends StatelessWidget {
  const PvpListEntity(this.backgroundColor, {Key? key}) : super(key: key);

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
      shape: RoundedRectangleBorder(
        //모서리를 둥글게 하기 위해 사용
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          const PvpProfile(
            leading: ProfileImage(80),
            title: Text('ABC'),
            subtitle: PvpScore(
              wins: 100,
              loses: 50,
              fontSize: 15.0,
            ),
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.subdirectory_arrow_left,
                    color: common.blackColor),
                label: Text(
                  '4.3km',
                  style: TextStyle(color: common.blackColor),
                ),
                style: buttonStyle),
            SizedBox(width: 15),
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.check, color: common.blackColor),
                label:
                    Text('4.3km', style: TextStyle(color: common.blackColor)),
                style: buttonStyle),
          ]),
        ],
      ),
    );
  }
}
