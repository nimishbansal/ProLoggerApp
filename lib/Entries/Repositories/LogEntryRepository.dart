
import 'package:pro_logger/Entries/utils.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/constants.dart';
import 'package:requests/requests.dart';
import 'package:tuple/tuple.dart';

class LogEntryRepository {
  Future<Tuple2<List<LogEntry>, int>> fetchLogEntryList({pageNo: 1}) async {
    List<LogEntry> results = [];
    String requestUrl = BASE_URL +
        LOG_ENTRY_LIST_ENDPOINT +
        PAGINATOR_QUERY_PARAM +
        pageNo.toString();
    String parameterisedRequestUrl = requestUrl.replaceAll("{project_id}", "1");
    final Map<String, dynamic> response =
        await Requests.get(parameterisedRequestUrl, json: true);
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
    final Map<String, dynamic> response = await Requests.get(parameterisedRequestUrl, json: true);
    return LogEntry.fromJson(response);
  }

  Future<bool> deleteLogEntry(int entryId) async {
    String requestUrl = BASE_URL + LOG_ENTRY_RETRIEVE_UPDATE_DESTROY_ENDPOINT;
    String parameterisedRequestUrl = requestUrl.replaceAll("{project_id}", "1").replaceAll("{entry_id}", entryId.toString());
    var response = await Requests.delete(parameterisedRequestUrl, json: false);
    if (response == '')
        return true;
    else
        return false;
  }

}
