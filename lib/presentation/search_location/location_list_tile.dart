import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile(
      {super.key, required this.location, required this.press});
  final String location;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          leading: const Icon(CupertinoIcons.location_circle),
          title: Text(
            location,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Divider(
          height: 2,
          thickness: 2,
          color: Colors.grey.withOpacity(0.1),
        ),
      ],
    );
  }
}
