import 'package:flutter/material.dart';
import 'package:twalk_app/constants/common.dart';
import 'package:twalk_app/logics/handshaking_request_status.dart';
import 'package:twalk_app/widgets/profile_image.dart';
import 'package:twalk_app/widgets/pvp_profile.dart';
import 'package:twalk_app/constants/common.dart' as common;

class MapPopupCardResponse extends StatelessWidget {
  const MapPopupCardResponse(
      {Key? key,
      required this.targetInfoJson,
      required this.responseMode,
      required this.rejectFunc,
      required this.accectFunc})
      : super(key: key);
  static const buttonColor = Color.fromRGBO(208, 208, 208, 1.0);
  final targetInfoJson;
  final HandshakingRequestStatus responseMode;
  final rejectFunc;
  final accectFunc;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: common.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: radiusCircular,
              topRight: radiusCircular,
            ),
          ),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          width: double.infinity,
          child: Text(
              (responseMode == HandshakingRequestStatus.JALKING_WAITING
                  ? '같이 걸으실래요?'
                  : 'PvP 대결 한판!?'),
              style: TextStyle(
                color: common.blackColor,
                fontSize: common.h3Size + 2.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              )),
        ),
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
                  child: const Text('거절하기'),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    rejectFunc(targetInfoJson["id"]);
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(buttonColor),
                  ),
                  child: const Text('수락하기'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
