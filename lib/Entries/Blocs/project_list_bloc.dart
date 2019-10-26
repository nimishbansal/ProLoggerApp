import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';
import 'package:requests/requests.dart';
import 'package:pro_logger/utility/network_utils.dart';

class ProjectBloc {
  LogEntryRepository _logEntryRepository;

  // Stream utils for creating new project
  StreamController<ApiResponse> _newProjectStreamController;
  StreamSink<ApiResponse> get newProjectSink =>
      _newProjectStreamController.sink;
  Stream<ApiResponse> get newProjectStream =>
      _newProjectStreamController.stream;

  // Stream utils for fetching project list
  StreamController<ApiResponse> _listProjectStreamController;
  StreamSink<ApiResponse> get listProjectSink => _listProjectStreamController.sink;
  Stream<ApiResponse> get listProjectStream =>
      _listProjectStreamController.stream;


  // Stream utils for deleting projects list
  StreamController<ApiResponse> _deleteProjectsStreamController;
  StreamSink<ApiResponse> get deleteProjectSink => _deleteProjectsStreamController.sink;
  Stream<ApiResponse> get deleteProjectStream => _deleteProjectsStreamController.stream;

  ProjectBloc() {
    _logEntryRepository = new LogEntryRepository();
    _newProjectStreamController = StreamController<ApiResponse>();
    _listProjectStreamController = StreamController<ApiResponse>();
    _deleteProjectsStreamController = StreamController<ApiResponse>();
  }

  void listProjects({bool addLoadingInitially = true}) async {
    if (addLoadingInitially == true) {
      listProjectSink.add(ApiResponse.loading());
    }
    Tuple2<bool, Response> results = await _logEntryRepository.listProjects();
    var response = results.item2;
    if (results.item1) {
      listProjectSink.add(ApiResponse.completed(response));
    } else {
      print(response.content());
      listProjectSink.add(ApiResponse.error('Some Error Occured'));
    }
  }

  void createNewProject({@required String projectName}) async {
    print("creating project with project name $projectName");
    newProjectSink.add(ApiResponse.loading());
    Tuple2<bool, Response> results =
        await _logEntryRepository.createProject(projectName: projectName);
    var response = results.item2;
    if (results.item1) {
      print("Succesfully Added New Project");
      newProjectSink.add(ApiResponse.completed(response));
    } else {
      Map<String, dynamic> jsonResponse = response.json();
      if (jsonResponse.containsKey('name')) {
        newProjectSink
            .add(ApiResponse.error(jsonResponse['name'][0].toString()));
      } else {
        newProjectSink.add(ApiResponse.error('Some Error Occured'));
      }
    }
  }

  void deleteProjects(List<int> indexes, List<dynamic> projectLists) async {
      deleteProjectSink.add(ApiResponse.loading());
      List<int> projectIds = indexes.map((index){
        return (projectLists[index]['id'] as int);
      }).toList();
      Tuple2<bool, Response> results = await _logEntryRepository.deleteProjects(projectIds);
      var response = results.item2;
      if (results.item1) {
        deleteProjectSink.add(ApiResponse.completed(response));
      } else {
        print(response.content());
        deleteProjectSink.add(ApiResponse.error('Some Error Occured'));
      }
  }

  void dispose() {
    _newProjectStreamController.close();
    _listProjectStreamController.close();
    _deleteProjectsStreamController.close();
  }
}
