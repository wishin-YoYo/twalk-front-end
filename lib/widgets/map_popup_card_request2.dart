import 'package:flutter/material.dart';
import 'package:twalk_app/constants/common.dart';
import 'package:twalk_app/widgets/profile_image.dart';
import 'package:twalk_app/widgets/pvp_profile.dart';
import 'package:twalk_app/constants/common.dart' as common;

class MapPopupCardRequest2 extends StatelessWidget {
  const MapPopupCardRequest2(
      {Key? key,
      required this.targetInfoJson,
      required this.requestJalkingToId,
      required this.requestPvpToId})
      : super(key: key);
  static const buttonColor = Color.fromRGBO(208, 208, 208, 1.0);
  final targetInfoJson;
  final requestJalkingToId;
  final requestPvpToId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        PvpProfile(
          imageSize: 60,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          leading: const ProfileImage(60, 'assets/images/profile1.png'),
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          title: Text(
            targetInfoJson["name"],
            style: TextStyle(
              fontSize: common.h2Size,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Text(
            targetInfoJson["comment"],
            style: TextStyle(
              fontSize: common.h3Size,
              fontWeight: FontWeight.bold,
              color: common.primaryColor,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Card(
            margin: const EdgeInsets.fromLTRB(12, 5, 12, 5),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(radiusCircular),
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.local_fire_department_outlined,
                          size: 30),
                      title: const Text('PvP 전적',
                          style: TextStyle(
                            color: common.primaryColor,
                            fontSize: 12,
                          )),
                      subtitle: Text(
                          '${targetInfoJson["wins"]}승 ${targetInfoJson["loses"]}패',
                          style: const TextStyle(
                            fontSize: 16,
                            color: common.blackColor,
                            fontWeight: FontWeight.bold,
                          )),
                      minLeadingWidth: 1,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.route_outlined, size: 30),
                      title: const Text(
                        '총 이동거리',
                        style: TextStyle(
                          color: common.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Text('${targetInfoJson["totalDistance"]}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: common.blackColor,
                            fontWeight: FontWeight.bold,
                          )),
                      minLeadingWidth: 1,
                    ),
                  ),
                ],
              ),
            )),
        ListTile(
          title: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(buttonColor),
                  ),
                  child: const Text('PvP 대결하기'),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    requestJalkingToId(targetInfoJson["id"]);
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(buttonColor),
                  ),
                  child: const Text('같이 걷기'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
