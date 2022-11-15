import 'package:flutter/material.dart';
import '../common.dart' as common;
import './profile_image.dart';

class PvpProfile extends StatelessWidget {
  const PvpProfile({
    Key? key,
    this.imageSize = 80,
    this.padding,
    this.contentPadding,
    this.leading,
    this.title,
    this.subtitle,
    this.extraChild,
  }) : super(key: key);

  final double imageSize;
  final padding;
  final contentPadding;
  final leading;
  final title;
  final subtitle;
  final extraChild;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Need to change
            leading,
            Expanded(
              flex: 1,
              child: Container(
                padding: contentPadding,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    subtitle,
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
