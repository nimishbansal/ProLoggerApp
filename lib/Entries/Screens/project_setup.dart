import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ProjectSetupScreen extends StatefulWidget {
  final int projectId;

  final String projectName;

  final String secretKey;

  const ProjectSetupScreen(
      {Key key, this.projectId, this.projectName, this.secretKey})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProjectSetupScreenState();
  }
}

class ProjectSetupScreenState extends State<ProjectSetupScreen> {
  WebviewScaffold webViewScaffold;
  @override
  void initState() {
    super.initState();
    webViewScaffold = new WebviewScaffold(
      url: new Uri.dataFromString(
              '<html>'
                      '<head>'
                      '<script src="https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.js"></script>'
                      '</head>'
                      '<style>'
                      'pre.prettyprint {'
                      'border: none !important;'
                      'font-size: 1em;'
                      'background-color: #F1F8FF;'
                      'width:200%;'
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
                      '${sourceCode.replaceFirst('{0}', widget.secretKey)}'
                      '</pre>'
                      '<br/>'
                      'You can cause a Python error by inserting a divide by zero expression into your application:'
                      '<pre class="prettyprint py">'
                      '$exampleCode'
                      '</pre>'
                      '<br/>'
                      'If you are aware of Logging Dict configuration for. e.g in Django '
                      '[See : https://docs.djangoproject.com/en/2.2/topics/logging/]'
                      'then you can use'
                      '<pre class="prettyprint py">'
                      '${loggingDictConfig.replaceFirst('{0}', widget.secretKey)}'
                      '</pre>'
                      '</div>'
                      '</body>'
                      '</html>',
              mimeType: 'text/html')
              .toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectName ?? 'Project1'),
      ),
      body: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 6,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 4),
              ),
              Text(
                'Setup',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            height: 0.8 * MediaQuery.of(context).size.height,
            child: webViewScaffold,
          ),
        ],
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

var installCode = """
\$ pip install --upgrade prologgersdk==0.0.1
""";

var sourceCode = """
from prologgersdk.log import ProLoggerHandler
handler = ProLoggerHandler(
secret_key="{0}"
)
""";

var exampleCode = """
division_by_zero = 1 / 0
""";

var loggingDictConfig = """
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'pro_logger': {
            'level': 'DEBUG', # Specify your level
            'class': 'prologgersdk.log.ProLoggerHandler',
            "secret_key": "{0}" # this is your secret key
        }
    },
    'loggers': {
        '': { # empty one is root logger, You can use your own named logger
            'handlers': ['pro_logger', ],
            'level': 'ERROR',
            'propagate': False,
        },
    }
}
""";