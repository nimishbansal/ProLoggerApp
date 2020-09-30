import 'dart:collection';

import 'package:pro_logger/Auth/Repositories/auth_repository.dart';
import 'package:pro_logger/Entries/utils.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/constants.dart';
import 'package:pro_logger/utility/network_utils.dart';
import 'package:requests/requests.dart';
import 'package:tuple/tuple.dart';
import 'package:pro_logger/globals.dart' as globals;

class LogEntryRepository {
  String get authToken{
    return globals.authToken;
}

  Future<Tuple2<bool, Response>> createProject({String projectName}) async {
    String requestUrl = BASE_URL + PROJECT_ENTRY_LIST_CREATE_ENDPOINT;
    HashMap<String, String> data;
    data = new HashMap<String, String>();
    data['name'] = projectName;
    Response r = await Requests.post(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authToken
      },
      json: data,
    );
    final Map<String, dynamic> response = r.json();
    return Tuple2(r.success, r);
  }

  Future<Tuple2<bool, Response>> listProjects() async {
    String requestUrl = BASE_URL + PROJECT_ENTRY_LIST_CREATE_ENDPOINT;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': authToken
//      'Authorization': 'Token 81a8d8783d8737a59cb684e47428d4acba33de87'
    };
    Response r = await Requests.get(requestUrl, headers: headers);
    return Tuple2(r.success, r);
  }

  Future<Tuple2<bool, Response>> deleteProjects(List<int> projectIds) async {
    String requestUrl = BASE_URL + PROJECT_BULK_DELETE_ENDPOINT;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': authToken
//      'Authorization': 'Token 81a8d8783d8737a59cb684e47428d4acba33de87'
    };
    Response r =
        await Requests.post(requestUrl, body: projectIds, headers: headers);
    return Tuple2(r.success, r);
  }

  Future<Tuple2<List<LogEntry>, int>> fetchLogEntryList(
      {pageNo: 1, int projectId}) async {
    List<LogEntry> results = [];
    String requestUrl = BASE_URL +
        LOG_ENTRY_LIST_ENDPOINT +
        PAGINATOR_QUERY_PARAM +
        pageNo.toString();
    String parameterisedRequestUrl =
        requestUrl.replaceAll("{project_id}", projectId.toString());
    Response r = await Requests.get(parameterisedRequestUrl);
    final Map<String, dynamic> response = r.json();

    var it = response['results'].iterator;
    int count = response['count'];
    while (it.moveNext()) {
      results.add(LogEntry.fromJson(it.current));
    }
    return Tuple2(results, count);
  }

  Future<LogEntry> fetchLogEntryDetails(int entryId, int projectId) async {
    String requestUrl = BASE_URL + LOG_ENTRY_RETRIEVE_UPDATE_DESTROY_ENDPOINT;
    String parameterisedRequestUrl = requestUrl
        .replaceAll("{project_id}", projectId.toString())
        .replaceAll("{entry_id}", entryId.toString());
    Response r = await Requests.get(parameterisedRequestUrl);
    final Map<String, dynamic> response = r.json();
    print("current response is $response");
    return LogEntry.fromJson(response);
  }

  Future<bool> deleteLogEntry(int entryId, int projectId) async {
    String requestUrl = BASE_URL + LOG_ENTRY_RETRIEVE_UPDATE_DESTROY_ENDPOINT;
    String parameterisedRequestUrl = requestUrl
        .replaceAll("{project_id}", projectId.toString())
        .replaceAll("{entry_id}", entryId.toString());
    Response r = await Requests.delete(parameterisedRequestUrl);
    if (r.content() == '')
      return true;
    else
      return false;
  }

  Future<Tuple2<bool, Response>> deleteLogEntries(List<int> logEntryIds, int projectId) async {
    String requestUrl = (BASE_URL + LOG_ENTRY_BULK_DELETE_ENDPOINT).replaceAll('{project_id}', projectId.toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': authToken
    };
    Response r =
    await Requests.post(requestUrl, body: logEntryIds, headers: headers);
    return Tuple2(r.success, r);
  }
}
