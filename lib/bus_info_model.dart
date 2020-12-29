import 'package:flutter/cupertino.dart';

class BusInfo {
  final String busId;
  final String busNameTo;
  final List<String> arrivals;

  BusInfo(
      {@required this.busId,
      @required this.busNameTo,
      @required this.arrivals});

  factory BusInfo.fromJson(Map<String, dynamic> json) {
    List<String> arr = [];
    for (var i in json['arrivals'][0]['arrivals']) {
      arr.add(i['minutes'].toString());
    }

    return BusInfo(
      busId: json['arrivals'][0]['busId'] as String,
      busNameTo: json['arrivals'][0]['busNameTo'] as String,
      arrivals: arr,
    );
  }
}
