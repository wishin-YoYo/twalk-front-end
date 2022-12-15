import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twalk_app/constants/common.dart';
import 'package:twalk_app/logics/wishin_api_caller.dart';
import 'dart:convert'; // FOR JSON CONVERTING
import '../constants/common.dart' as common;
import '../constants/constants.dart' as constants;
import '../widgets/profile_image.dart';
import '../widgets/pvp_profile.dart';
import 'package:jiffy/jiffy.dart';

void main() {
  runApp(MultiProvider(
    providers: [],
    child: MaterialApp(
      home: MyPage(),
    ),
  ));
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final cardMargin = const EdgeInsets.fromLTRB(15, 15, 15, 0);
  final cardBorderRadius = const BorderRadius.all(radiusCircular);
  List<dynamic> _jalkingHistory = [];

  @override
  void initState() {
    super.initState();
    print("initState called");
    WishinApiCaller.getJalkingHistory(1).then((response) {
      setState(() {
        _jalkingHistory = response["result"]["data"].sublist(0, 10);
        print(_jalkingHistory);
      });
    });
  }

  final testChartData = [
    BarChartData(leading: '금', size: 200),
    BarChartData(leading: '목', size: 900),
    BarChartData(leading: '수', size: 700),
    BarChartData(leading: '화', size: 200),
    BarChartData(leading: '월', size: 300),
    BarChartData(leading: '일', size: 600),
    BarChartData(leading: '토', size: 400),
    BarChartData(leading: '금', size: 1000),
    BarChartData(leading: '목', size: 900),
    BarChartData(leading: '수', size: 700),
    BarChartData(leading: '화', size: 400),
    BarChartData(leading: '월', size: 500),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
                  children: [
                    PvpProfile(
                      imageSize: 80,
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      leading: ProfileImage(80, 'assets/images/profile1.png'),
                      contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                          color: common.primaryColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Card(
                        margin: cardMargin,
                        shape: RoundedRectangleBorder(
                          borderRadius: cardBorderRadius,
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Row(
                            children: const [
                              Expanded(
                                child: ListTile(
                                  leading: Icon(
                                      Icons.local_fire_department_outlined,
                                      size: 40),
                                  title: Text('총 칼로리',
                                      style: TextStyle(
                                        color: common.primaryColor,
                                        fontSize: 14,
                                      )),
                                  subtitle: Text('546 kcal',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: common.blackColor,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  minLeadingWidth: 1,
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  leading: Icon(Icons.route_outlined, size: 40),
                                  title: Text(
                                    '총 이동거리',
                                    style: TextStyle(
                                      color: common.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text('3.5 km',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: common.blackColor,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  minLeadingWidth: 1,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                )),
            Card(
              margin: cardMargin,
              shape: RoundedRectangleBorder(
                borderRadius: cardBorderRadius,
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(35, 20, 35, 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        '걸음 수',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          itemCount: testChartData.length,
                          itemBuilder: (c, i) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    BarChartEntity(
                                      size: testChartData[i].size,
                                      active: (i == 0 ? true : false),
                                    ),
                                    Text(testChartData[i].leading),
                                  ]),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  for (var i = 0; i < _jalkingHistory.length; i++)
                    jalkingHistoryEntity(i),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget jalkingHistoryEntity(int i) {
    final entry = _jalkingHistory[i];
    const entityColors = [
      Color.fromARGB(255, 218, 236, 233),
      Color.fromARGB(255, 246, 240, 235),
      Color.fromARGB(255, 233, 235, 243),
      Color.fromARGB(255, 242, 241, 218),
    ];
    return Card(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
        color: entityColors[i % entityColors.length],
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          //모서리를 둥글게 하기 위해 사용
          borderRadius: BorderRadius.all(radiusCircular),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProfileImage(80, 'assets/images/profile${i % 10 + 1}.png'),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry["requester"]["id"] == 1 ? entry["receiver"]["name"] : entry["requester"]["name"]}',
                        style: TextStyle(
                          fontSize: common.h2Size,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        Jiffy(DateTime.parse(entry["createdAt"].toString()))
                            .fromNow(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class BarChartData {
  BarChartData({required this.leading, required this.size});

  final String leading;
  final int size;
}

class BarChartEntity extends StatelessWidget {
  const BarChartEntity(
      {this.size = 1000, this.max = 1000, this.active = false, Key? key})
      : super(key: key);

  final size;
  final max;
  final bool active;
  static const height = 150;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (size / max) * height,
      width: 10,
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(100.0),
                topRight: Radius.circular(100.0)),
            color: (!active ? Colors.grey : primaryColor)),
      ),
    );
  }
}
