// Packages
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Widgets
import 'rounded_image.dart';

// Models
import '../models/chat_message.dart';
import '../models/chat_user.dart';

class CustomListViewTileWithActivity extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isActivity;
  final Function onTap;

  const CustomListViewTileWithActivity(
      {Key? key,
      required this.height,
      required this.title,
      required this.subtitle,
      required this.imagePath,
      required this.isActive,
      required this.isActivity,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      leading: RoundedImageNetworkWithStatusIndicator(
        key: UniqueKey(),
        imagePath: imagePath,
        isActive: isActive,
        size: height / 2,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: isActivity
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitThreeBounce(
                  color: Colors.white54,
                  size: height * 0.10,
                ),
              ],
            )
          : Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }
}