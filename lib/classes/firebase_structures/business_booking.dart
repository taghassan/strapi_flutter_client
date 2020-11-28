import 'package:bapp/config/config.dart';
import 'package:bapp/config/config_data_types.dart';
import 'package:bapp/config/constants.dart';
import 'package:bapp/helpers/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'business_branch.dart';
import 'business_services.dart';
import 'business_staff.dart';
import 'business_timings.dart';

class BusinessBooking {
  final BusinessStaff staff;
  final BusinessBranch branch;
  final FromToTiming fromToTiming;
  final List<BusinessService> services;
  final String bookedByNumber;
  final BusinessBookingStatus status;
  final UserType bookingUserType;
  final DateTime remindTime;

  final DocumentReference myDoc;

  BusinessBooking({
    @required this.myDoc,
    @required this.bookingUserType,
    @required this.status,
    @required this.bookedByNumber,
    @required this.staff,
    @required this.branch,
    @required this.fromToTiming,
    @required this.services,
    @required this.remindTime,
  });

  static DocumentReference newDoc() {
    return FirebaseFirestore.instance.collection("bookings").doc(kUUIDGen.v1());
  }

  Map<String, dynamic> toMap() {
    return {
      "staff": staff.name,
      "from": fromToTiming.from.toTimeStamp(),
      "to": fromToTiming.to.toTimeStamp(),
      "remindTime": remindTime.toTimeStamp(),
      "services": services.map((e) => e.toMap()).toList(),
      "branch": branch.myDoc.value,
      "bookedByNumber": bookedByNumber,
      "status": EnumToString.convertToString(status),
      "bookingUserType": EnumToString.convertToString(bookingUserType),
    };
  }

  static BusinessBooking fromSnapShot(
      {@required DocumentSnapshot snap, @required BusinessBranch branch}) {
    final j = snap.data();
    return BusinessBooking(
      myDoc: snap.reference,
      services: (j["services"] as List).map(
        (s) {
          return BusinessService.fromJson(s);
        },
      ).toList(),
      staff: branch.getStaffFor(name: j["staff"]),
      branch: branch,
      fromToTiming: FromToTiming.fromTimeStamps(
        from: j["from"],
        to: j["to"],
      ),
      status:
          EnumToString.fromString(BusinessBookingStatus.values, j["status"]),
      bookedByNumber: j["bookedByNumber"],
      bookingUserType: EnumToString.fromString(
        UserType.values,
        j["bookingUserType"],
      ),
      remindTime: (j["remindTime"] as Timestamp).toDate(),
    );
  }

  double totalCost() {
    var t = 0.0;
    services.forEach((element) {
      t += element.price.value;
    });
    return t;
  }

  String getServicesSeperatedBycomma() {
    var s = "";
    services.forEach((element) {
      s += element.serviceName.value + ", ";
    });
    //s = s.trim().replaceFirst(",", "", s.length - 1);
    return s;
  }

  static Color getColor(BusinessBookingStatus status) {
    switch (status) {
      case BusinessBookingStatus.accepted:
      case BusinessBookingStatus.ongoing:
        {
          return CardsColor.colors["teal"];
        }
      case BusinessBookingStatus.walkin:
      case BusinessBookingStatus.pending:
        {
          return CardsColor.colors["purple"];
        }
      case BusinessBookingStatus.cancelledByUser:
        {
          return CardsColor.colors["orange"];
        }
      case BusinessBookingStatus.cancelledByManager:
      case BusinessBookingStatus.cancelledByReceptionist:
      case BusinessBookingStatus.cancelledByStaff:
      case BusinessBookingStatus.noShow:
        {
          return Colors.redAccent;
        }
      case BusinessBookingStatus.finished:
        {
          return Colors.grey[400];
        }
      default:
        return Colors.grey[300];
    }
  }

  static String getButtonLabel(BusinessBookingStatus status) {
    switch (status) {
      case BusinessBookingStatus.accepted:
      case BusinessBookingStatus.ongoing:
        {
          return "Confirmed";
        }
      case BusinessBookingStatus.walkin:
        {
          return "Walkin";
        }
      case BusinessBookingStatus.pending:
        {
          return "New";
        }
      case BusinessBookingStatus.cancelledByUser:
        {
          return "Cancelled";
        }
      case BusinessBookingStatus.cancelledByManager:
      case BusinessBookingStatus.cancelledByReceptionist:
      case BusinessBookingStatus.cancelledByStaff:
      case BusinessBookingStatus.noShow:
        {
          return "Rejected";
        }
      case BusinessBookingStatus.finished:
        {
          return "Completed";
        }
      default:
        return "Unknown";
    }
  }
}

enum BusinessBookingStatus {
  cancelledByUser,
  cancelledByStaff,
  cancelledByReceptionist,
  cancelledByManager,
  walkin,
  pending,
  accepted,
  ongoing,
  finished,
  noShow
}
