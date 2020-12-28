import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bus_info_model.dart';

Future<BusInfo> fetchBusFrom() async {
  final response =
      await http.get('https://prominfo.projekti.si/lpp_rc/api/602092');

  if (response.statusCode == 200) {
    return BusInfo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load from API');
  }
}

Future<BusInfo> fetchBusTo() async {
  final response =
      await http.get('https://prominfo.projekti.si/lpp_rc/api/602093');

  if (response.statusCode == 200) {
    return BusInfo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load from API');
  }
}
