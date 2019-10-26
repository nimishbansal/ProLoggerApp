import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro_logger/Entries/Blocs/project_list_bloc.dart';
import 'package:pro_logger/Entries/widgets/loader.dart';
import 'package:pro_logger/common_widgets.dart';
import 'package:pro_logger/utility/network_utils.dart';

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

  String _errorText;

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
                decoration: InputDecoration(errorText: _errorText),
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

  @override
  Widget build(BuildContext context) {
    Widget box = Container(
      padding: EdgeInsets.all(16),
      foregroundDecoration: BoxDecoration(border: Border.all(width: 2)),
      child: CircleAvatar(
        child: Icon(
          Icons.add,
          size: 100,
          color: Colors.white,
        ),
        foregroundColor: Colors.blue,
      ),
    );
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.greenAccent,
        title: Text(
          'Projects',
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: Drawer(
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
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Material(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 0.3 * MediaQuery.of(context).size.height,
                ),
                Container(
                  child: Text(
                    "You don't have \nany projects yet.",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                  ),
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      //https://stackoverflow.com/a/52697978/7698247
                      color: Colors.black,
                      child: InkWell(
                        splashColor: Colors.green,
                        radius: 200,
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Add New Project',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.greenAccent, fontSize: 20),
                            ),
                            width: 0.9 * MediaQuery.of(context).size.width),
                        onTap: () => _handleAddNewProject(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleAddNewProject(BuildContext context) {
    var scaffoldContext = context;
    this.newProjectForm = NewProjectForm(
      key: newProjectFormStateKey,
    );

    ProjectBloc projectBloc = ProjectBloc();
    showDialog(
        context: context,
        builder: (builderContext) =>
            _mainDialogBuilder(builderContext, projectBloc, scaffoldContext));
  }

  Widget _mainDialogBuilder(BuildContext context, ProjectBloc projectBloc, BuildContext scaffoldContext) {
    return StreamBuilder<ApiResponse>(
        stream: projectBloc.newProjectStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!=null && snapshot.data.status == Status.COMPLETED){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
              Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
                      content: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Project Created Succesfully',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),duration: Duration(seconds: 1),),);
            });
          }
          return AlertDialog(
            content: Builder(builder: (_) {
              print("data is ${snapshot.data}");
              return Column(
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
}
