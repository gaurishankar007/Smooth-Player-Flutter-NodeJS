import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:smooth_player_app/api/res/report_res.dart';

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

  Future<Map> deleteReport(String reportId) async {
    final response = await delete(
      Uri.parse(routeUrl + "report/delete"),
      body: {"reportId": reportId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }

  Future<Map> deleteReportedSong(String songId) async {
    final response = await delete(
      Uri.parse(routeUrl + "report/deleteSong"),
      body: {"songId": songId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }

  Future<Map> reportDeleteSong(String songId) async {
    final response = await delete(
      Uri.parse(routeUrl + "report/songDeleted"),
      body: {"songId": songId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }

  Future<Map> warnArtist(String reportId, String message) async {
    final response = await put(
      Uri.parse(routeUrl + "report/warnArtist"),
      body: {"reportId": reportId, "message": message},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }

  Future<bool> checkReport() async {
    final response = await get(
      Uri.parse(routeUrl + "report/check"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    bool reportExist = jsonDecode(response.body);

    return reportExist;
  }

  Future<List<Report>> viewMyReports() async {
    final response = await get(
      Uri.parse(routeUrl + "report/viewMy"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List reports = jsonDecode(response.body);

    return reports.map((e) => Report.fromJson(e)).toList();
  }

  Future<List<Report>> viewAllReports(int reportNum) async {
    final response = await post(
      Uri.parse(routeUrl + "report/viewAll"),
      body: {"reportNum": reportNum.toString()},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List reports = jsonDecode(response.body);

    return reports.map((e) => Report.fromJson(e)).toList();
  }

  Future<List<Report>> searchReports(String artistName, bool solved) async {
    final response = await post(
      Uri.parse(routeUrl + "report/viewAll"),
      body: {"artistName": artistName, "solved": solved},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List reports = jsonDecode(response.body);

    return reports.map((e) => Report.fromJson(e)).toList();
  }
}
