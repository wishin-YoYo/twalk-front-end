import 'package:flutter/material.dart';
import 'package:twalk_app/widgets/pvp_profile.dart';

class MapFloatingMenu extends StatelessWidget {
  const MapFloatingMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: [
                PvpProfile(
                  imageSize: 40,
                )
              ],
            )));
  }
}
