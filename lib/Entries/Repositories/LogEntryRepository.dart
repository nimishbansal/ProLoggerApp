import 'dart:convert';

import 'package:pro_logger/Entries/utils.dart';
import 'package:pro_logger/Entries/Models/LogEntry.dart';
import 'package:pro_logger/constants.dart';
import 'package:requests/requests.dart';

class LogEntryRepository
{
    Future<List<LogEntry>> fetchLogEntryList({page:1}) async {
        List<LogEntry> results = [];
        String requestUrl = BASE_URL + LOG_ENTRY_LIST_ENDPOINT + PAGINATOR_QUERY_PARAM + page.toString();
        String parameterisedRequestUrl = requestUrl.replaceAll("{project_id}", "1");
        final Map<String, dynamic> response = await Requests.get(parameterisedRequestUrl, json: true);
        var it = response['results'].iterator;
        while (it.moveNext()) {
            results.add(LogEntry.fromJson(it.current));
        }
        return results;
    }
}