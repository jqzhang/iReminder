import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String DefaultDateTimeFormat = "yyyy-MM-dd HH:mm:ss";

Future<DateTime?> showBottomDateTimePicker(
  BuildContext context,
  DateTime? initialDateTime,
  DateTime? minimumDate,
) async {
  DateTime? selectedDateTime;
  // Display the date picker
  final DateTime? date = await showBottomDatePicker(context,
      CupertinoDatePickerMode.dateAndTime, initialDateTime, minimumDate);
  if (date != null) {
    // 设置选中时间，秒默认为00
    selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute.remainder(60),
    );
  }

  return selectedDateTime;
}

Future<DateTime?> showBottomDatePicker(
  BuildContext context,
  CupertinoDatePickerMode mode,
  DateTime? initialDateTime,
  DateTime? minimumDate,
) async {
  DateTime? selectedDateTime = initialDateTime ?? DateTime.now();

  return await showModalBottomSheet<DateTime>(
    context: context,
    builder: (BuildContext builder) {
      return SizedBox(
        height: 260,
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(""),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.chooseTime,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      child: Text(
                        AppLocalizations.of(context)!.confirm,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(selectedDateTime);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                use24hFormat: true,
                mode: mode,
                dateOrder: DatePickerDateOrder.ymd,
                initialDateTime: initialDateTime,
                minimumDate: minimumDate,
                onDateTimeChanged: (DateTime newDateTime) {
                  selectedDateTime = newDateTime;
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<Duration?> showBottomTimePicker(
  BuildContext context,
  Duration? initialDuration,
) async {
  Duration selectedDuration = initialDuration ?? Duration.zero;

  return await showModalBottomSheet<Duration>(
    context: context,
    builder: (BuildContext builder) {
      return SizedBox(
        height: 260,
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(""),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.chooseTime,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      child: Text(
                        AppLocalizations.of(context)!.confirm,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(selectedDuration);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hms,
                initialTimerDuration: selectedDuration,
                onTimerDurationChanged: (Duration newDuration) {
                  selectedDuration = newDuration;
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
