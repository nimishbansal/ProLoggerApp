import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro_logger/Entries/Blocs/project_list_bloc.dart';
import 'package:pro_logger/Entries/Screens/LogEntryListScreen.dart';
import 'package:pro_logger/Entries/Screens/project_detail.dart';
import 'package:pro_logger/Entries/widgets/loader.dart';
import 'package:pro_logger/common_widgets.dart';
import 'package:pro_logger/utility/network_utils.dart';
import 'package:requests/requests.dart';

final newProjectFormStateKey = GlobalKey<NewProjectFormState>();

class NewProjectForm extends StatefulWidget {
  const NewProjectForm({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return NewProjectFormState();
  }
}

class NewProjectFormState extends State<NewProjectForm> {
  final formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                  title: Text(
                'Project Name',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w400),
              )),
              ListTile(
                  title: TextFormField(
                controller: myController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Project Name can't be empty";
                  }
                  return null;
                },
                style: TextStyle(
                  fontSize: 18,
                ),
                autofocus: true,
              )),
            ],
          ),
        ),
      ],
    );
  }
}

class ProjectsListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProjectsListScreenState();
  }
}

class ProjectsListScreenState extends State<ProjectsListScreen> {
  NewProjectForm newProjectForm;
  ProjectBloc _projectBloc;
  List<int> _selectedIndexList = List<int>();
  bool _selectionMode = false;

  List<dynamic> _currentProjectsList = List<dynamic>();

  @override
  void initState() {
    super.initState();
    _projectBloc = ProjectBloc();
    _projectBloc.listProjects();
  }

  Drawer getAppDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(6),
            child: Image.network(
                "https://i0.wp.com/www.winhelponline.com/blog/wp-content/uploads/2017/12/user.png?fit=256%2C256&quality=100&ssl=1"),
            width: 0.4 * MediaQuery.of(context).size.width,
            height: 0.4 * MediaQuery.of(context).size.width,
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Nimish Bansal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
              child: Text(
            '+91-965XXXXX49',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.grey[400]));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.green[600],
        actions: <Widget>[
          _selectionMode
              ? IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 30,
                  ),
                  onPressed: () {
                    ProjectBloc projectBloc = ProjectBloc();
                    showDialog(
                        context: context,
                        builder: (BuildContext buildContext) {
                          return StreamBuilder<ApiResponse>(
                              stream: projectBloc.deleteProjectStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data != null &&
                                    snapshot.data.status == Status.COMPLETED) {
                                  projectBloc.deleteProjectSink
                                      .add(ApiResponse.halt());
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.of(context).pop();
                                    _selectedIndexList.clear();
                                    _selectionMode = false;
                                    _projectBloc.listProjects(
                                        addLoadingInitially: false);
                                  });
                                }

                                bool _isLoading = snapshot.hasData &&
                                    snapshot.data != null &&
                                    snapshot.data.status == Status.LOADING;
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Are you Sure you want to delete ${_selectedIndexList.length} projects?',
                                      ),
                                      _isLoading ? Loader() : SizedBox(height: 0,)
                                    ],
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Yes'),
                                      onPressed: _isLoading
                                          ? null
                                          : () {
                                              projectBloc.deleteProjects(
                                                  _selectedIndexList,
                                                  _currentProjectsList);
                                            },
                                    ),
                                    FlatButton(
                                      child: Text('No'),
                                      onPressed: _isLoading
                                          ? null
                                          : () {
                                              Navigator.of(context).pop();
                                            },
                                    ),
                                  ],
                                );
                              });
                        }).then((_) {
                      projectBloc.dispose();
                    });
                  },
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
        ],
        title: Text(
          'Projects',
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: getAppDrawer(),
      body: StreamBuilder<ApiResponse>(
          stream: _projectBloc.listProjectStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data.status == Status.LOADING)) {
              return Center(child: Loader());
            }
            bool noProjectsCondition = snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data.status == Status.COMPLETED &&
                (((snapshot.data.data as Response).json() as List<dynamic>)
                        .toList()
                        .length ==
                    0);

            if (snapshot.hasData && snapshot.data != null) {
              _currentProjectsList =
                  ((snapshot.data.data as Response).json() as List<dynamic>);
            }
            return Builder(
              builder: (BuildContext context) {
                return Material(
                  child: Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          noProjectsCondition
                              ? Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 0.3 *
                                          MediaQuery.of(context).size.height,
                                    ),
                                    Container(
                                      child: Text(
                                        "You don't have \nany projects yet.",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 24),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )
                              : Expanded(
                                  child: GridView.count(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.0,
                                      padding: const EdgeInsets.all(4.0),
                                      mainAxisSpacing: 4.0,
                                      crossAxisSpacing: 4.0,
                                      children: ((snapshot.data.data
                                                  as Response)
                                              .json() as List<dynamic>)
                                          .toList()
                                          .asMap()
                                          .map((
                                            int index,
                                            dynamic obj,
                                          ) {
                                            return MapEntry(
                                              index,
                                              new GridTile(
                                                header: GridTileBar(
                                                  leading: _selectionMode
                                                      ? Icon(
                                                          _selectedIndexList
                                                                  .contains(
                                                                      index)
                                                              ? Icons
                                                                  .check_circle
                                                              : Icons
                                                                  .radio_button_unchecked,
                                                          color: _selectedIndexList
                                                                  .contains(
                                                                      index)
                                                              ? Colors
                                                                  .lightBlueAccent
                                                              : Colors.black,
                                                        )
                                                      : null,
                                                ),
                                                child: InkWell(
                                                  child: Container(
                                                    color:
                                                        Colors.deepPurpleAccent,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      ((obj as Map)['name']),
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  onLongPress: () {
                                                    _changeSelection(
                                                        index: index);
                                                  },
                                                  onTap: () async {
                                                    if (_selectionMode) {
                                                      _changeSelection(
                                                          index: index);
                                                    } else {
                                                      int projectId = (obj as Map<String, dynamic>)['id'];
                                                      String projectTitle = (obj as Map<String, dynamic>)['name'];
                                                      Navigator.push(context, MaterialPageRoute(builder: (_){
                                                        return LogEntryListScreen(projectId: projectId, title: projectTitle,);
                                                      }));
                                                      return;
                                                    }
                                                  },
                                                ),
                                              ),
                                            );
                                          })
                                          .values
                                          .toList()),
                                ),
                        ],
                      ),

                      // Add New Project Button
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Material(
                              //https://stackoverflow.com/a/52697978/7698247
                              color: Colors.black,
                              child: InkWell(
                                splashColor: Colors.green,
                                radius: 300,
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(
                                          Icons.add,
                                          color: Colors.greenAccent,
                                        ),
                                        Text(
                                          'Add New Project',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.greenAccent,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    width: 0.6 *
                                        MediaQuery.of(context).size.width),
                                onTap: () => _handleAddNewProject(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }

  void _handleAddNewProject(BuildContext context) async {
    var scaffoldContext = context;
    this.newProjectForm = NewProjectForm(
      key: newProjectFormStateKey,
    );

    ProjectBloc projectBloc = ProjectBloc();
    await showDialog(
        context: context,
        builder: (builderContext) => _mainDialogBuilder(
            builderContext, projectBloc, scaffoldContext)).then((_) {
      projectBloc.dispose();
    });
  }

  Widget _mainDialogBuilder(BuildContext context, ProjectBloc projectBloc,
      BuildContext scaffoldContext) {
    return StreamBuilder<ApiResponse>(
        stream: projectBloc.newProjectStream,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.status == Status.COMPLETED) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              projectBloc.newProjectSink.add(ApiResponse.halt());
              Navigator.of(context).pop();
              Scaffold.of(scaffoldContext).showSnackBar(
                SnackBar(
                  content: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Project Created Succesfully',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  duration: Duration(seconds: 1),
                ),
              );
              _selectedIndexList.clear();
              _selectionMode = false;
              _projectBloc.listProjects(addLoadingInitially: false);
            });
          }
          return AlertDialog(
            content: Builder(builder: (_) {
              return Container(
                width: 0.5*MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    this.newProjectForm,
                    (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data.status == Status.LOADING)
                        ? Loader()
                        : SizedBox(
                            height: 0,
                          ),
                    (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data.status == Status.ERROR)
                        ? Text(
                            snapshot.data.message.toString(),
                            style: TextStyle(color: Colors.red),
                          )
                        : SizedBox(
                            height: 0,
                          ),
//                  Text(snapshot.data?.message?.toString() ?? 'aww', style: TextStyle(color: Colors.red),),
                  ],
                ),
              );
            }),
            actions: <Widget>[
              FlatButton(
                disabledTextColor: Colors.grey,
                color: Colors.white,
                child: Text(
                  'Ok',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: (snapshot.data?.status == Status.LOADING)
                    ? null
                    : () {
                        var formKey =
                            newProjectFormStateKey.currentState.formKey;
                        if (formKey.currentState.validate()) {
                          projectBloc.createNewProject(
                              projectName: newProjectFormStateKey
                                  .currentState.myController.text);
                        } else {
                          // remove error message
                          projectBloc.newProjectSink.add(ApiResponse.error(''));
                        }
                      },
              ),
              FlatButton(
                disabledTextColor: Colors.grey,
                color: Colors.white,
                child: Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: (snapshot.data?.status == Status.LOADING)
                    ? null
                    : () {
                        Navigator.of(context).pop();
                      },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _changeSelection({int index}) {
    setState(() {
      if (_selectedIndexList.length == 0) {
        _selectionMode = true;
      }
      if (_selectedIndexList.contains(index)) {
        _selectedIndexList.remove(index);
      } else {
        _selectedIndexList.add(index);
      }
      if (_selectedIndexList.length == 0) {
        _selectionMode = false;
      }
    });
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }
}
