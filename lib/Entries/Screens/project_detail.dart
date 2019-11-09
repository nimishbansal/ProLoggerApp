import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ProjectDetailScreen extends StatefulWidget {
  final int projectId;

  final String projectName;

  final String secretKey;

  const ProjectDetailScreen({Key key, this.projectId, this.projectName, this.secretKey})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProjectDetailScreenState();
  }
}

class ProjectDetailScreenState extends State<ProjectDetailScreen> {

  @override
  void initState() {
    super.initState();
    new WebviewScaffold(
            url: new Uri.dataFromString('<html><body>hello world</body></html>', mimeType: 'text/html').toString()
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectName??'Project1'),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 6,),
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 4),),
                Text('Setup', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ],
            ),
            SizedBox(height: 6,),
            Container(
              height: 0.8*MediaQuery.of(context).size.height,
              child: new WebviewScaffold(
                      url: new Uri.dataFromString(
                      '<html>'
                      '<head>'
                      '<script src="https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.js"></script>'
                      '</head>'
                      '<style>'
                      'pre.prettyprint {'
                      'border: none !important;'
                      'font-size: 1em;'
                      'background-color: #F1F8FF'
                      '}'
                      '</style>'
                      '<body>'
                      '<div>'
                      'Install our python sdk early in your application\'s setup'
                      '<pre class="prettyprint py">'
                      '$installCode'
                      '</pre>'
                      '<br/>'
                      'Import and initialize the prologger SDK early in your applications setup'
                      '<pre class="prettyprint py">'
                      '${sourceCode.replaceFirst('{0}', widget.secretKey)};'
                      '</pre>'
                      '<br/>'
                      'You can cause a Python error by inserting a divide by zero expression into your application:'
                      '<pre class="prettyprint py">'
                      '$exampleCode'
                      '</pre>'
                      '</div>'
                      '</body>'
                      '</html>', mimeType: 'text/html').toString()
              ),
            ),
          ],
        )
      ),
    );
  }
}

var installCode = """
\$ pip install --upgrade prologgersdk==0.0.1
""";


var sourceCode =
"""
import prologgersdk
prologgersdk.setup("{0}")
""";

var exampleCode =
"""
division_by_zero = 1 / 0
""";