import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../log_status.dart';
import '../urls.dart';

class ReportHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> reportSong(String songId, List<String> reportFor) async {
    Map<String, String> reportData = {
      "songId": songId,
    };

    for (int i = 0; i < reportFor.length; i++) {
      reportData["reportFor[" + i.toString() + "]"] = reportFor[i];
    }

    final response = await post(
      Uri.parse(routeUrl + "report/song"),
      body: reportData,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }

  Future<Map> reportSolved(String reportId) async {
    final response = await put(
      Uri.parse(routeUrl + "report/solved"),
      body: {"reportId": reportId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }
}
