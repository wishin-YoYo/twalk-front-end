import 'package:flutter/material.dart';
import 'package:twalk_app/widgets/pvp_profile.dart';
import 'package:twalk_app/constants/common.dart';

class MapFloatingMenu extends StatelessWidget {
  const MapFloatingMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(radiusCircular),
        ),
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: const [
                PvpProfile(
                  imageSize: 40,
                )
              ],
            )));
  }
}
