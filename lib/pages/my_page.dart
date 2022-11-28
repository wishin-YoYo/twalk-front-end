import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; // FOR JSON CONVERTING
import '../constants/common.dart' as common;
import '../constants/constants.dart' as constants;
import '../widgets/profile_image.dart';
import '../widgets/pvp_profile.dart';

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
  final cardBorderRadius = BorderRadius.circular(16.0);

  final testChartData = [
    BarChartData(leading: '월', size: 1000),
    BarChartData(leading: '화', size: 2000),
    BarChartData(leading: '수', size: 7000),
    BarChartData(leading: '목', size: 9000),
    BarChartData(leading: '금', size: 10000),
    BarChartData(leading: '토', size: 4000),
    BarChartData(leading: '일', size: 6000),
    BarChartData(leading: '월', size: 1000),
    BarChartData(leading: '화', size: 2000),
    BarChartData(leading: '수', size: 7000),
    BarChartData(leading: '목', size: 9000),
    BarChartData(leading: '금', size: 10000),
    BarChartData(leading: '토', size: 4000),
    BarChartData(leading: '일', size: 6000),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: common.greyColor,
      ),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Column(
                children: [
                  PvpProfile(
                    imageSize: 80,
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    leading: ProfileImage(80),
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
                    child: Text(
                      '걸음 수',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                  Container(
                    height: 200,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: testChartData.length,
                        itemBuilder: (c, i) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  BarChartEntity(size: testChartData[i].size),
                                  Text(testChartData[i].leading),
                                ]),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BarChartData {
  BarChartData({required this.leading, required this.size});

  final String leading;
  final int size;
}

class BarChartEntity extends StatelessWidget {
  const BarChartEntity({this.size = 1000, this.max = 10000, Key? key})
      : super(key: key);

  final size;
  final max;
  static const height = 150;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (size / max) * height,
      width: 10,
      child: const DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100.0),
                topRight: Radius.circular(100.0)),
            color: Colors.grey),
      ),
    );
  }
}
