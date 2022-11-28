import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:twalk_app/widgets/google_maps_marker_icon_generator.dart';
import 'package:twalk_app/widgets/rest_api_caller.dart';
import 'package:twalk_app/constants/common.dart' as common;

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

  LatLng currentLocationLatLng = LatLng(37.5498, 126.9417);
  Marker myMarker = Marker(markerId: MarkerId(id.toString()));
  bool jalking = false;
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _updateCurrentLocation();
    timerIntervalActions(intervalSeconds);
  }

  timerIntervalActions(int seconds) {
    Timer.periodic(Duration(seconds: seconds), (timer) async {
      print("[Time Interval] @@@@@@@@@@@@@@@@@@@@@@@");
      // 1-1. Get locations
      _updateCurrentLocation();
      // 1-2. Get locations of me from server.
      // 2-1. Set Markers from gotten locations
      updateMarkers();
      // 2-2. Change camera
      // var newPosition = CameraPosition(
      //   target: currentLocationLatLng,
      //   zoom: _zoom,
      // );
      // CameraUpdate update = CameraUpdate.newCameraPosition(newPosition);
      // _controller?.moveCamera(update);
    });
  }

  void _getUserLocation() async {}

  Future<void> updateMarkers() async {
    // Update Marker of me
    var newMyMarker = Marker(
        markerId: myMarker.markerId,
        onTap: () {},
        position: currentLocationLatLng,
        icon: await MarkerGenerator.getMarkerIcon(
            "assets/Avatar.png", const Size(150.0, 150.0), Colors.blue));
    myMarker = newMyMarker;
    List<Marker> newMarkers = [myMarker];
    // Update Marker around me
    if (jalking) {
      var membersAroundMe =
          await RestApiCaller.getMethod(["member-around", id.toString()]);
      for (var entity in membersAroundMe) {
        newMarkers.add(Marker(
          markerId: MarkerId(entity["id"].toString()),
          position: LatLng(
              entity["latLonPairDto"]["lat"], entity["latLonPairDto"]["lon"]),
          icon: await MarkerGenerator.getMarkerIcon("assets/Avatar.png",
              const Size(150.0, 150.0), Colors.greenAccent),
        ));
      }
    }
    setState(() {
      print("newMarers length@@@@@@@@@@@@");
      print(newMarkers.length);
      markers = newMarkers;
    });
  }

  _updateCurrentLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation));
    setState(() {
      currentLocationLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: Set.from(markers),
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          zoom: _zoom,
          target: currentLocationLatLng,
        ),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _controller = controller;
          });
        },
        myLocationEnabled: false,
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: jalking ? common.primaryColor : common.greyColor,
        elevation: 3.0,
        child: jalking
            ? const Icon(Icons.group)
            : const Icon(Icons.group_off, color: common.blackColor),
        onPressed: () {
          setState(() {
            jalking = jalking ? false : true;
            markers = [markers[0]];
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
