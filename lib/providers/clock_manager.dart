import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

enum ClockStyle { Analog, Digital }

class ClockManager extends ChangeNotifier {
  ClockStyle clockStyle = ClockStyle.Analog;

  List<TimeOfDay> alarms = [];

  List<Map<String, dynamic>> get myAlarms => alarms
      .map((e) => {
            "time": e,
            "display": "${e.hour}:${e.minute}",
          })
      .toList().reversed.toList();

  get style => clockStyle;

  switchStyle() {
    if (style == ClockStyle.Digital) {
      this.clockStyle = ClockStyle.Analog;
      notifyListeners();
    } else {
      this.clockStyle = ClockStyle.Digital;
      notifyListeners();
    }
  }

  saveAlarm(TimeOfDay time) {
    alarms.add(time);
    notifyListeners();
  }

  removeAlarm(TimeOfDay timeOfDay) {
    alarms.remove(timeOfDay);
    notifyListeners();
  }
}
