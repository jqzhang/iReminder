import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../edit_remind_page.dart';

Widget loadRemindError(
    BuildContext context, String error, VoidCallback? onPressed) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_outlined,
            size: 50,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            error.isNotEmpty ? AppLocalizations.of(context)!.reloadData : error,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    child: Text(AppLocalizations.of(context)!.reloadData),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget noData(BuildContext context, String content, VoidCallback? onPressed) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/none_data.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            content,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Row(
            children: [
              Expanded(
                child: null == onPressed
                    ? Text("")
                    : ElevatedButton(
                        onPressed: onPressed,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          child:
                              Text(AppLocalizations.of(context)!.addReminder),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
