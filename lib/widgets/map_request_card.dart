import 'package:flutter/material.dart';
import 'package:twalk_app/constants/common.dart';
import 'package:twalk_app/logics/handshaking_request_status.dart';
import 'package:twalk_app/logics/wishin_api_caller.dart';
import 'package:twalk_app/widgets/circle_loading.dart';

import 'package:twalk_app/widgets/profile_image.dart';
import 'package:twalk_app/widgets/pvp_profile.dart';
import 'package:twalk_app/logics/rest_api_caller.dart';
import 'package:twalk_app/logics/pausable_timer.dart';

class MapRequestCard extends StatefulWidget {
  const MapRequestCard({Key? key, required this.id, required this.targetId})
      : super(key: key);
  final int id;
  final int targetId;

  @override
  State<MapRequestCard> createState() => _MapRequestCardState();
}

class _MapRequestCardState extends State<MapRequestCard> {
  static const INIT_COUNTER = 20;
  static const intervalSeconds = 1;

  HandshakingRequestStatus handshakingRequestStatus =
      HandshakingRequestStatus.READY;
  var targetInfoJson;
  var _counter = INIT_COUNTER;
  int matchId = 0;

  static PausableTimer _actionTimer =
      PausableTimer(const Duration(seconds: intervalSeconds), () {});

  @override
  void initState() {
    super.initState();
    getTargetInfoJson();
    setHandshakingStatus(handshakingRequestStatus);
  }

  initCounter() {
    _counter = INIT_COUNTER;
  }

  setHandshakingStatus(postHandshakingStatus) {
    if (mounted) {
      setState(() {
        handshakingRequestStatus = postHandshakingStatus;
        _actionTimer.dispose();
        switch (handshakingRequestStatus) {
          case HandshakingRequestStatus.JALKING_WAITING:
            initCounter();
            _actionTimer =
                PausableTimer(const Duration(seconds: intervalSeconds), () {
              jalkingWaitingActions();
            });
            break;
          case HandshakingRequestStatus.PVP_WAITING:
            initCounter();
            _actionTimer =
                PausableTimer(const Duration(seconds: intervalSeconds), () {
              pvpWaitingActions();
            });
            break;
        }
      });
    }
  }

  pvpWaitingActions() {
    if (_counter <= 1) {
      closeThis({'success': false});
    }
    WishinApiCaller.getPvp(matchId).then((response) {
      print("PVP Waiting : ${response["result"]["data"]["id"]}");
      var jalkingStatus = response["result"]["data"]["status"];
      switch (jalkingStatus) {
        case 'APPROVED':
          closeThis({
            'success': true,
            'mode': 'pvp',
            'targetId': response["result"]["data"]["id"],
          });
          break;
        case 'REJECTED':
        case 'COMPLETE':
          closeThis({'success': false});
          break;
      }
      if (mounted) {
        setState(() {
          _counter--;
        });
      }
    });
  }

  jalkingWaitingActions() {
    if (_counter <= 1) {
      closeThis({'success': false});
    }
    WishinApiCaller.getJalking(matchId).then((response) {
      var jalkingStatus = response["result"]["data"]["status"];
      print(response["result"]["data"]["id"]);
      switch (jalkingStatus) {
        case 'APPROVED':
          closeThis({
            'success': true,
            'mode': 'jalking',
            'targetId': targetInfoJson["id"]
          });
          break;
        case 'REJECTED':
        case 'COMPLETE':
          closeThis({'success': false});
          break;
      }
      if (mounted) {
        setState(() {
          _counter--;
        });
      }
    });
  }

  getTargetInfoJson() async {
    var response =
        await RestApiCaller.getMethod(["member", widget.targetId.toString()]);
    if (mounted) {
      setState(() {
        // handshakingStatus = HandshakingStatus.READY;
        targetInfoJson = response["result"]["data"];
      });
    }
    return true;
  }

  requestPvpToId(int targetId) async {
    Map<String, String> parameters = {
      'receiverId': widget.targetId.toString(),
      'requesterId': widget.id.toString(),
    };
    WishinApiCaller.postPvpRequest(parameters).then((responseBody) {
      matchId = responseBody["result"]["data"]["id"];
      setHandshakingStatus(HandshakingRequestStatus.PVP_WAITING);
    });
  }

  requestJalkingToId(int targetId) async {
    Map<String, String> parameters = {
      'receiverId': widget.targetId.toString(),
      'requesterId': widget.id.toString(),
    };
    WishinApiCaller.postJalkingRequest(parameters).then((responseBody) {
      print("[CGCG] $responseBody");
      matchId = responseBody["result"]["data"]["id"];
      setHandshakingStatus(HandshakingRequestStatus.JALKING_WAITING);
    });
  }

  closeThis(Map<String, dynamic> returnValues) {
    _actionTimer.dispose();
    Navigator.pop(context, returnValues);
  }

  @override
  Widget build(BuildContext context) {
    if (targetInfoJson == null) {
      return const CircleLoading();
    }
    if (handshakingRequestStatus == HandshakingRequestStatus.JALKING_WAITING) {
      return widgetWaiting();
    }
    if (handshakingRequestStatus == HandshakingRequestStatus.PVP_WAITING) {
      return widgetWaiting();
    } else if (handshakingRequestStatus ==
        HandshakingRequestStatus.PVP_WAITING) {}
    return widgetReady();
  }

  Widget widgetWaiting() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '상대방의 응답을 기다리고 있습니다!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$_counter',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                  )),
              const SizedBox(
                width: 5.0,
              ),
              const Text('걸음',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget widgetReady() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        PvpProfile(
          imageSize: 60,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          leading: ProfileImage(60,
              'assets/images/profile${(targetInfoJson["id"] % 10 + 1)}.png'),
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          title: Text(
            targetInfoJson["name"],
            style: TextStyle(
              fontSize: h2Size,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Text(
            targetInfoJson["comment"],
            style: TextStyle(
              fontSize: h3Size,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Card(
            elevation: 3.0,
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
                            color: primaryColor,
                            fontSize: 12,
                          )),
                      subtitle: Text(
                          '${targetInfoJson["wins"]}승 ${targetInfoJson["loses"]}패',
                          style: const TextStyle(
                            fontSize: 15,
                            color: blackColor,
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
                          color: primaryColor,
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Text('${targetInfoJson["totalDistance"]}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: blackColor,
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
                  onPressed: () {
                    requestPvpToId(targetInfoJson["id"]);
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(blackColor),
                    elevation: MaterialStatePropertyAll(10.0),
                  ),
                  child: const Text(
                    'PvP 대결하기',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                    backgroundColor: MaterialStatePropertyAll(primaryColor),
                    elevation: MaterialStatePropertyAll(10.0),
                  ),
                  child: const Text('같이 걷기',
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _actionTimer.dispose();
    super.dispose();
  }
}
