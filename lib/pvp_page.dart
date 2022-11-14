import 'package:flutter/material.dart';
import './common_widgets.dart' as common;
import './constants.dart' as constants;
import './pvp_page.style.dart' as pvpStyle;

void main(){
  runApp(MaterialApp(
      home: PvpPage()
  ));
}

class PvpPage extends StatelessWidget {
  const PvpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Column(
          children: [
            PvpProfile(),
            PvpList(),
          ],
        ),
      )
    );
  }
}

class PvpProfile extends StatefulWidget {
  const PvpProfile({Key? key}) : super(key: key);

  @override
  State<PvpProfile> createState() => _PvpProfileState();
}

class _PvpProfileState extends State<PvpProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(232, 232, 232, 1.0),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Need to change
                common.ProfileImage(80),
                Expanded(
                  flex:1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello, 엠마!', style: TextStyle(
                              fontSize: pvpStyle.h1Size,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text('오늘은 누구랑 대결할까요?', style: TextStyle(
                          fontSize: pvpStyle.h3Size,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff30c665),
                          overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Text(
              '전적 20승 3패',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            )
          ),
        ],
      ),
    );
  }
}

class PvpList extends StatefulWidget {
  PvpList({Key? key}) : super(key: key);

  @override
  State<PvpList> createState() => _PvpListState();
}

class _PvpListState extends State<PvpList> {
  // final List<PvpListEntity> pvpListEntries = [1,2,3];
  final pvpListEntries = [1,2,3];
  final entityColors = const [
    Color.fromRGBO(0, 255, 196, 0.5019607843137255),
    Color.fromRGBO(248, 228, 6, 0.5058823529411764),
    Color.fromRGBO(142, 108, 255, 0.5019607843137255),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (c, i){
          return ListTile(
            leading: common.ProfileImage(30),
            title: Text('ABC'),
          );
        },
      )
    );
  }
}

class PvpListEntity extends StatelessWidget {
  const PvpListEntity(this.backgroundColor, {Key? key}) : super(key: key);

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

