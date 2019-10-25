import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro_logger/Entries/Repositories/LogEntryRepository.dart';
import 'package:pro_logger/Entries/widgets/loader.dart';

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
                '*Project Name',
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
                        return 'Please enter some text';
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
      body: Material(
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
                              color: Colors.greenAccent, fontSize: 22),
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
      ),
    );
  }

  void _handleAddNewProject(BuildContext context) {
    this.newProjectForm = NewProjectForm(key: newProjectFormStateKey,);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
              actions: <Widget>[
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text(
                    'Ok',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    if(newProjectFormStateKey.currentState.formKey.currentState.validate()){
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return Loader();
                        });
                        LogEntryRepository().createProject(projectName:newProjectFormStateKey.currentState.myController.text);

                    }
                  },
                ),
                RaisedButton(
                  color: Colors.redAccent,
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              content: this.newProjectForm,
          );
        });
  }
}
