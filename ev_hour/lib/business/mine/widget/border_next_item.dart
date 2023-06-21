import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BorderNextItem extends StatelessWidget {
  String title;

  BorderRadius? borderRadius;

  GestureTapCallback onTap;

  BorderNextItem({
    super.key,
    required this.title,
    this.borderRadius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10),
      //   border: Border.all(
      //     width: 1,
      //     color: Theme.of(context).disabledColor,
      //   ),
      // ),
      child: InkWell(
        highlightColor: Theme.of(context).primaryColor.withAlpha(20),
        borderRadius: borderRadius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const Icon(CupertinoIcons.right_chevron),
            ],
          ),
        ),
      ),
    );
  }
}
