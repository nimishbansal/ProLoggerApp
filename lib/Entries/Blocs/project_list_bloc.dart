import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';
import 'package:requests/requests.dart';
import 'package:pro_logger/utility/network_utils.dart';

class ProjectBloc {
  LogEntryRepository _logEntryRepository;

//  Stream<ApiResponse> newProjectStream;
  StreamController<ApiResponse> _newProjectStreamController;

  StreamSink<ApiResponse> get newProjectSink => _newProjectStreamController.sink;
  Stream<ApiResponse> get newProjectStream => _newProjectStreamController.stream;

  ProjectBloc() {
    _logEntryRepository = new LogEntryRepository();
    _newProjectStreamController = StreamController<ApiResponse>();
  }

  void createNewProject({@required String projectName}) async {
      print("creating project with project name $projectName");
      newProjectSink.add(ApiResponse.loading());
    Tuple2<bool, Response> results =  await _logEntryRepository.createProject(projectName: projectName);
    var response = results.item2;
    if (results.item1) {
      print("Succesfully Added New Project");
      newProjectSink.add(ApiResponse.completed(response));
    } else {
        Map<String, dynamic> jsonResponse= response.json();
        if (jsonResponse.containsKey('name'))
            {
                newProjectSink.add(ApiResponse.error(jsonResponse['name'][0].toString()));
            }
        else{
            newProjectSink.add(ApiResponse.error('Some Error Occured'));
        }

    }
  }

  void dispose() {
    _newProjectStreamController.close();
  }
}