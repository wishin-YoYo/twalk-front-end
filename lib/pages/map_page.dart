import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:twalk_app/constants/common.dart';
import 'package:twalk_app/logics/wishin_api_caller.dart';

import 'package:twalk_app/widgets/google_maps_marker_icon_generator.dart';
import 'package:twalk_app/widgets/jalking_stop_button.dart';
import 'package:twalk_app/widgets/map_request_card.dart';
import 'package:twalk_app/constants/common.dart' as common;

import '../logics/jalking_status.dart';
import '../logics/pausable_timer.dart';
import '../widgets/wishin_pedometer.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  //Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _controller;
  static const int id = 1;
  static const intervalSeconds = 1;
  static const _zoom = 16.0;
  static JalkingStatus jalkingStatus = JalkingStatus.WALKING;
  static var _initialCameraLocation = const CameraPosition(
    target: LatLng(37.5498, 126.9417),
    zoom: _zoom,
  );
  static PausableTimer _actionTimer =
      PausableTimer(const Duration(seconds: intervalSeconds), () {});

  LatLng currentLocationLatLng = LatLng(37.5498, 126.9417);
  Marker myMarker = Marker(markerId: MarkerId(id.toString()));
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];
  Widget _popupWidget = const WishinPedometer();

  var currentJalkingRequest = 0;
  var partnerId = 0;

  @override
  void initState() {
    super.initState();
    _updateCurrentLocation().then((_) {
      _initialCameraLocation = CameraPosition(
        target: currentLocationLatLng,
        zoom: _zoom,
      );
      if (mounted) {
        setState(() {
          CameraUpdate update =
              CameraUpdate.newCameraPosition(_initialCameraLocation);
          _controller?.moveCamera(update);
        });
      }
    });
    _setJalkingStatus(JalkingStatus.WALKING);
  }

  @override
  void dispose() {
    _actionTimer.dispose();
    super.dispose();
    print("[CGCG]Map page disposed");
  }

  _setJalkingStatus(postJalkingStatus) async {
    _actionTimer.dispose();
    if (mounted) {
      setState(() {
        jalkingStatus = postJalkingStatus;
        _polylines = [];
        print("Polylines !!!!!@@@@@@@@@@@@@@@@@");
        print(_polylines.length);
        print(_polylines);
        _popupWidget = const WishinPedometer();
      });
    }
    switch (jalkingStatus) {
      case JalkingStatus.WALKING:
        _actionTimer =
            PausableTimer(const Duration(seconds: intervalSeconds), () {
          _walkingStatusActions();
        });
        break;
      case JalkingStatus.WAITING:
        _actionTimer =
            PausableTimer(const Duration(seconds: intervalSeconds), () {
          _waitingStatusActions();
        });
        break;
      case JalkingStatus.HANDSHAKING:
        _actionTimer =
            PausableTimer(const Duration(seconds: intervalSeconds), () {
          _handshakingActions();
        });
        break;
      case JalkingStatus.JALKING:
        _actionTimer =
            PausableTimer(const Duration(seconds: intervalSeconds), () {
          _jalkingActions();
        });
        break;
      case JalkingStatus.PVP:
        _actionTimer =
            PausableTimer(const Duration(seconds: intervalSeconds), () {
          _pvpActions();
        });
        break;
    }
  }

  _walkingStatusActions() {
    setState(() {
      _polylines = [];
      _popupWidget = const WishinPedometer();
    });
    print("[CGCG] walkingStatusAction is runned.");
    _updateCurrentLocation().then((_) {
      _updateMarkers([]);
    });
  }

  _waitingStatusActions() {
    setState(() {
      _polylines = [];
      _popupWidget = const WishinPedometer();
    });
    print("[CGCG] waitingStatusAction is runned.");
    // WAIT 1)
    _updateCurrentLocation().then((_) {
      WishinApiCaller.getMemberAroundMe(id).then((userAroundMe) {
        _updateMarkers(userAroundMe["result"]["data"]);
      });
    });
    // WAIT 2)
    WishinApiCaller.getJakingRequestOfMe(id).then((response) {
      if (jalkingStatus == JalkingStatus.WAITING &&
          currentJalkingRequest != response["result"]["data"]["id"]) {
        _setJalkingStatus(JalkingStatus.HANDSHAKING);
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: common.greyColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(radiusCircular),
                ),
                child: MapRequestCard(
                  id: id,
                  targetId: response["result"]["data"]["requester"]["id"],
                ),
              );
            }).then((result) {
          print("[CGCG] Result of dialog = $result");
          // Matching Successes
          if (result != null && result["success"]) {
            if (result['mode'] == 'jalking') {
              _setJalkingStatus(JalkingStatus.JALKING);
            }
            if (result['mode'] == 'pvp') {
              _setJalkingStatus(JalkingStatus.PVP);
            }
            // Matching fails
          } else {
            _setJalkingStatus(JalkingStatus.WAITING);
          }
        });
      }
      currentJalkingRequest = response["result"]["data"]["id"];
    });
    // WAIT 3)
    WishinApiCaller.getPvpRequestOfMe(id).then((response) {});
  }

  _handshakingActions() {
    print("[CGCG] handshakingStatusAction is runned.");
  }

  _jalkingActions() {
    print("[CGCG] Jalking is running");
    _updateCurrentLocation().then((_) {
      WishinApiCaller.getMemberById(partnerId).then((response) {
        _updateMarkers([response["result"]["data"]]).then((_) {
          // Add Polyline
          if (mounted) {
            setState(() {
              _polylines = [
                Polyline(
                  polylineId: PolylineId(id.toString() + partnerId.toString()),
                  visible: true,
                  points: [_markers[0].position, _markers[1].position],
                  color: primaryColor.withOpacity(0.4),
                  zIndex: -1,
                  width: 5,
                )
              ];
              _popupWidget = GestureDetector(
                onTap: () {
                  _setJalkingStatus(JalkingStatus.WAITING);
                },
                child: const JalkingStopButton(content: '같이 걷기 종료!'),
              );
            });
          }
        });
      });
    });
  }

  _pvpActions() {
    print("[CGCG] PvP is running");
    _updateCurrentLocation().then((_) {
      WishinApiCaller.getPvp(partnerId).then((response) {
        if (response["result"]["data"]["winner"] != null &&
            jalkingStatus == JalkingStatus.PVP) {
          _setJalkingStatus(JalkingStatus.WAITING);
          if (response["result"]["data"]["winner"]["id"] == id) {
            _secondsPopup(
              10,
              const Icon(
                Icons.thumb_up_alt_outlined,
                size: 50,
                color: Color.fromARGB(255, 18, 179, 203),
              ),
              const Text(
                '축하합니다! PvP 승리!',
                style: TextStyle(color: Colors.black54),
              ),
            );
          } else {
            _secondsPopup(
              10,
              const Icon(
                Icons.thumb_down_alt_outlined,
                size: 50,
                color: Color.fromARGB(255, 255, 80, 48),
              ),
              const Text(
                'PvP 패배! 멋진 대결이었습니다!',
                style: TextStyle(color: Colors.black54),
              ),
            );
          }
          return;
        }
        final targetInfo = response["result"]["data"]["requester"]["id"] == id
            ? response["result"]["data"]["receiver"]
            : response["result"]["data"]["requester"];
        final flagLatLng = LatLng(
          response["result"]["data"]["targetLocation"]["lat"],
          response["result"]["data"]["targetLocation"]["lon"],
        );
        _updateMarkers([targetInfo]).then((_) {
          _addFlagMarker(flagLatLng).then((_) {
            if (mounted) {
              setState(() {
                _polylines = [
                  Polyline(
                    polylineId: PolylineId("${id}ToFlag"),
                    visible: true,
                    points: [_markers[0].position, _markers[2].position],
                    color: Colors.greenAccent.withOpacity(0.7),
                    zIndex: -1,
                    width: 5,
                  ),
                  Polyline(
                    polylineId: PolylineId("${targetInfo["id"]}ToFlag"),
                    visible: true,
                    points: [_markers[1].position, _markers[2].position],
                    color: Colors.greenAccent.withOpacity(0.7),
                    zIndex: -1,
                    width: 5,
                  ),
                ];
                _popupWidget = GestureDetector(
                  onTap: () {
                    _setJalkingStatus(JalkingStatus.WAITING);
                  },
                  child: const JalkingStopButton(content: 'PvP 걷기 종료!'),
                );
              });
              // Add Polyline
            }
          });
        });
      });
    });
  }

  Future<int> _addFlagMarker(LatLng latLng) async {
    final Uint8List markerIcon =
        await getByteFromAsset("assets/images/flag_icon.png", 150);
    var flagMarker = Marker(
      markerId: MarkerId("999999"),
      position: latLng,
      icon: BitmapDescriptor.fromBytes(markerIcon),
    );
    if (mounted) {
      _markers.add(flagMarker);
    }
    return 0;
  }

  Future<Uint8List> getByteFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  _updateMarkers(List<dynamic> usersAroundMe) async {
    var newMyMarker = Marker(
        markerId: myMarker.markerId,
        onTap: () {},
        position: currentLocationLatLng,
        icon: await MarkerGenerator.getMarkerIcon("assets/images/profile1.png",
            const Size(150.0, 150.0), Color.fromRGBO(236, 65, 123, 0.9)));
    myMarker = newMyMarker;
    List<Marker> newMarkers = [myMarker];
    for (var user in usersAroundMe) {
      newMarkers.add(Marker(
        markerId: MarkerId(user["id"].toString()),
        onTap: () {
          _setJalkingStatus(JalkingStatus.HANDSHAKING);
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(radiusCircular),
                  ),
                  backgroundColor: common.greyColor,
                  child: MapRequestCard(id: id, targetId: user["id"]),
                );
              }).then((result) {
            print("[CGCG] $result");
            if (result != null && result["success"]) {
              if (result['mode'] == 'jalking') {
                partnerId = result['targetId'];
                _setJalkingStatus(JalkingStatus.JALKING);
              } else if (result['mode'] == 'pvp') {
                partnerId = result['targetId'];
                _setJalkingStatus(JalkingStatus.PVP);
              }
            } else {
              _setJalkingStatus(JalkingStatus.WAITING);
            }
          });
        },
        position:
            LatLng(user["latLonPairDto"]["lat"], user["latLonPairDto"]["lon"]),
        icon: await MarkerGenerator.getMarkerIcon(
            "assets/images/profile${(user["id"] % 10) + 1}.png",
            const Size(150.0, 150.0),
            primaryColor),
      ));
    }
    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }
  }

  Future<void> _updateCurrentLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation));
    if (mounted) {
      setState(() {
        currentLocationLatLng = LatLng(position.latitude, position.longitude);
      });
    }
  }

  void _secondsPopup(int sec, var icon, var message) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: sec), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            icon: icon,
            title: message,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(radiusCircular),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            markers: Set.from(_markers),
            polylines: Set.from(_polylines),
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraLocation,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller = controller;
              });
            },
            myLocationEnabled: false,
            zoomControlsEnabled: false,
          ),
          _popupWidget,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: jalkingStatus == JalkingStatus.WALKING
            ? common.greyColor
            : common.primaryColor,
        elevation: 3.0,
        child: jalkingStatus == JalkingStatus.WALKING
            ? const Icon(Icons.group_off, color: blackColor)
            : const Icon(Icons.group, color: greyColor),
        onPressed: () {
          jalkingStatus == JalkingStatus.WALKING
              ? _setJalkingStatus(JalkingStatus.WAITING)
              : _setJalkingStatus(JalkingStatus.WALKING);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
