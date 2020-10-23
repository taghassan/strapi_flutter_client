import 'dart:convert';

import 'package:bapp/config/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

class BusinessTimings {
  final DocumentReference myDoc;
  final allDayTimings = Observable(ObservableList<DayTiming>());

  BusinessTimings({this.myDoc}) {
    _getTimings(myDoc);
  }

  Future saveTimings() async {
    final map = toMap();
    await myDoc.set(map);
  }

  Map<String, dynamic> toMap() {
    return allDayTimings.value.fold(
      {},
      (previousValue, dt) {
        previousValue.addAll({dt.dayName: dt.toMap()});
        return previousValue;
      },
    );
  }

  Future _getTimings(DocumentReference myDoc) async {
    if (myDoc == null) {
      return;
    }
    final snap = await myDoc.get();
    if (snap.exists) {
      final data = snap.data();
      data.forEach(
        (key, value) {
          allDayTimings.value.add(
            DayTiming(value, dayName: key),
          );
        },
      );
    } else {
      allDayTimings.value.addAll(kDays.map((e) => DayTiming({}, dayName: e)));
      await saveTimings();
    }
    allDayTimings.value.sort(
      (a, b) {
        final aa = kDays.indexOf(a.dayName);
        final bb = kDays.indexOf(b.dayName);
        if (aa > bb) {
          return 1;
        }
        return -1;
      },
    );
  }
}

class DayTiming {
  final String dayName;
  final enabled = Observable(false);
  final timings = Observable(ObservableList<FromToTiming>());

  DayTiming(Map<String, dynamic> data, {this.dayName}) {
    enabled.value = data["enabled"];
    timings.value.addAll(_getDayTimings(data["timings"]));
  }

  toMap() {
    filterNull();
    return {
      "dayName": dayName,
      "enabled": enabled.value,
      "timings": timings.value.isEmpty
          ? []
          : timings.value.map((element) => element.toJson()).toList(),
    };
  }

  filterNull() {
    timings.value.removeWhere((element) => element == null);
  }

  List<FromToTiming> _getDayTimings(List j) {
    final List<FromToTiming> dayTimings = [];
    j.forEach(
      (element) {
        final FromToTiming fromTo = FromToTiming(element);
        dayTimings.add(fromTo);
      },
    );
    return dayTimings;
  }
}

class FromToTiming {
  DateTime from;
  DateTime to;

  FromToTiming(String data) {
    final j = json.decode(data);
    from = DateTime.parse(j[0]);
    to = DateTime.parse(j[1]);
  }

  FromToTiming.fromDates({DateTime from, DateTime to}) {
    this.from = from;
    this.to = to;
  }

  String toJson() {
    return json.encode([
      from.toIso8601String(),
      to.toIso8601String(),
    ]);
  }
}
