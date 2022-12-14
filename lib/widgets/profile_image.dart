import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage(double this.size, String this.path, {Key? key})
      : super(key: key);
  final size;
  final String path;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: this.size / 2,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: this.size / 2 - 4,
          backgroundImage: AssetImage(path),
        ));
  }
}
