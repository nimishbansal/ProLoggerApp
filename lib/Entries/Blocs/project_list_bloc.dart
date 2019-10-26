import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';
import 'package:requests/requests.dart';
import 'package:pro_logger/utility/network_utils.dart';

class ProjectBloc {
  LogEntryRepository _logEntryRepository;

  StreamController<ApiResponse> _newProjectStreamController;

  StreamSink<ApiResponse> get newProjectSink => _newProjectStreamController.sink;
  Stream<ApiResponse> get newProjectStream => _newProjectStreamController.stream;


  StreamController<ApiResponse> _listProjectStreamController;

  StreamSink<ApiResponse> get listProjectSink => _listProjectStreamController.sink;
  Stream<ApiResponse> get listProjectStream => _listProjectStreamController.stream;

  ProjectBloc() {
    _logEntryRepository = new LogEntryRepository();
    _newProjectStreamController = StreamController<ApiResponse>();
    _listProjectStreamController = StreamController<ApiResponse>();
  }

  void listProjects({bool addLoadingInitially=true}) async {
      if (addLoadingInitially==true){
          listProjectSink.add(ApiResponse.loading());
      }
      Tuple2<bool, Response> results  = await _logEntryRepository.listProjects();
      var response = results.item2;
      if (results.item1){
          listProjectSink.add(ApiResponse.completed(response));
      }
      else{
          print(response.content());
          listProjectSink.add(ApiResponse.error('Some Error Occured'));
      }
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
    _listProjectStreamController.close();
  }
}