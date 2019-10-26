import 'package:flutter/material.dart';

class ProjectDetailScreen extends StatefulWidget {
  final int projectId;

  final String projectName;

  const ProjectDetailScreen({Key key, this.projectId, this.projectName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProjectDetailScreenState();
  }
}

class ProjectDetailScreenState extends State<ProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectName),
      ),
      body: Container(
        color: Colors.purpleAccent,
      ),
    );
  }
}
