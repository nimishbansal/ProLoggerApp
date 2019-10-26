
import 'dart:collection';

import 'package:pro_logger/Entries/utils.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/constants.dart';
import 'package:pro_logger/utility/network_utils.dart';
import 'package:requests/requests.dart';
import 'package:tuple/tuple.dart';

class LogEntryRepository {

  Future<Tuple2<bool, Response>> createProject({String projectName}) async {
    String requestUrl = BASE_URL + PROJECT_ENTRY_LIST_CREATE_ENDPOINT;
    HashMap<String, String> data;
    data = new HashMap<String, String>();
    data['name'] = projectName;
    Response r = await Requests.post(requestUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Token 81a8d8783d8737a59cb684e47428d4acba33de87'
            },
            body: data,);
    final Map<String, dynamic> response = r.json();
    return Tuple2(r.success, r);
    }

  Future<Tuple2<List<LogEntry>, int>> fetchLogEntryList({pageNo: 1}) async {
    List<LogEntry> results = [];
    String requestUrl = BASE_URL +
        LOG_ENTRY_LIST_ENDPOINT +
        PAGINATOR_QUERY_PARAM +
        pageNo.toString();
    String parameterisedRequestUrl = requestUrl.replaceAll("{project_id}", "1");
    Response r = await Requests.get(parameterisedRequestUrl);
    final Map<String, dynamic> response = r.json();

    var it = response['results'].iterator;
    int count = response['count'];
    while (it.moveNext()) {
      results.add(LogEntry.fromJson(it.current));
    }
    return Tuple2(results, count);
  }

  Future<LogEntry> fetchLogEntryDetails(int entryId) async {
    String requestUrl = BASE_URL + LOG_ENTRY_RETRIEVE_UPDATE_DESTROY_ENDPOINT;
    String parameterisedRequestUrl = requestUrl.replaceAll("{project_id}", "1").replaceAll("{entry_id}", entryId.toString());
    Response r = await Requests.get(parameterisedRequestUrl);
    final Map<String, dynamic> response = r.json();
    return LogEntry.fromJson(response);
  }

  Future<bool> deleteLogEntry(int entryId) async {
    String requestUrl = BASE_URL + LOG_ENTRY_RETRIEVE_UPDATE_DESTROY_ENDPOINT;
    String parameterisedRequestUrl = requestUrl.replaceAll("{project_id}", "1").replaceAll("{entry_id}", entryId.toString());
    Response r = await Requests.delete(parameterisedRequestUrl);
    if (r.content() == '')
        return true;
    else
        return false;
  }

}
