import 'package:flutter/material.dart';

class OTPField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OTPFieldState();
  }
}

class _OTPFieldState extends State<OTPField> {
  Row textFieldRow;

  @override
  void initState() {
    super.initState();
    textFieldRow = getTextFieldRow();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          width: 200,
          height: 200,
          color: Colors.lightGreenAccent,
          child: textFieldRow,
        ),
      ),
    );
  }

  Row getTextFieldRow() {
    int noOfFields = 4;
    Row textFieldRow;
    List<Container> textFieldRowChildren;
    textFieldRowChildren = new List<Container>.generate(
      noOfFields,
      (i) => Container(
        padding: EdgeInsets.all(4),
        child: TextField(
          focusNode: FocusNode(),
          keyboardType: TextInputType.phone,
          textAlign: TextAlign.center,
          maxLength: 1,
          decoration: InputDecoration(counterText: ''),
          onChanged: (String value) {
            TextField textField = (textFieldRowChildren[i].child as TextField);

            // value.length = 0 when text field back pressed
            if (value.length == 0) {
            } else {
              if (i == noOfFields - 1) {
                print(textField.focusNode.hasFocus);
                textField.focusNode.unfocus();
              } else {
                TextField nextTextField =
                    (textFieldRowChildren[i + 1].child as TextField);
                print(nextTextField.focusNode.hasFocus);
                FocusScope.of(context).requestFocus(nextTextField.focusNode);
              }
            }
          },
        ),
        width: 50,
      ),
    );
    textFieldRow = Row(
      children: textFieldRowChildren,
    );
    return textFieldRow;
  }
}

class OTPField2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OTPField2State();
  }
}

class BlinkingWidget extends StatefulWidget {
  final Color cursorColor;

  const BlinkingWidget({Key key, this.cursorColor = Colors.blue})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return BlinkingWidgetState();
  }
}

class BlinkingWidgetState extends State<BlinkingWidget>
    with SingleTickerProviderStateMixin {
  Duration _blinkDuration = Duration(milliseconds: 250);
  AnimationController _animationController;
  Animation<Color> _animation;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _blinkDuration);
    final CurvedAnimation curve =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);
    _animation = ColorTween(begin: Colors.transparent, end: widget.cursorColor)
        .animate(curve);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
      setState(() {});
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, _) {
        return SizedBox(
          height: double.infinity,
          child: Container(
            width: 3,
            color: _animation.value,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class OTPField2State extends State<OTPField2> {
  List<Widget> otpContainers;
  List<Widget> otpContainersWithPadding;
  List<Widget> children = List<Widget>();
  int maxLength;
  Widget widgetWithoutText = Container(
    child: CircleAvatar(
      backgroundColor: Colors.grey,
      radius: 8,
    ),
  );

  @override
  void initState() {
    super.initState();
    maxLength = 4;
    for (int i = 0; i < maxLength; i++) {
      children.add(widgetWithoutText);
    }
    _handleOTPChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: TextField(
              maxLength: maxLength,
              autofocus: true,
              keyboardType: TextInputType.phone,
              onChanged: _handleOTPChanged,
            ),
            width: 200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              2 * maxLength,
              (int index) {
                if (index % 2 == 0)
                  return Container(
                    width: 40,
                    height: 40,
                    child: this.children[(index / 2).floor()],
                    alignment: Alignment.center,
                  );
                else
                  return Padding(
                    padding: EdgeInsets.all(6),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleOTPChanged(String value) {
    print("otp has been changed");

    setState(() {
      // loop for building filled boxes
      for (int i = 0; i < value.length; i++) {
        Text textWidget = Text(
          value[i],
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        );
        this.children[i] = i == maxLength - 1
            ? Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  textWidget,
                  Align(
                    child: BlinkingWidget(),
                    alignment: Alignment(0.5, 0),
                  )
                ],
              )
            : Container(
                child: textWidget,
              );
      }

      // loop for building unfilled box
      for (int i = value.length; i < this.children.length; i++) {
//        this.children[i] = widgetWithoutText; // Default Container
        this.children[i] = Container(
//          color: Colors.greenAccent,
          child: i == value.length
              ? Stack(alignment: Alignment.center, children: <Widget>[
                  widgetWithoutText,
                  Align(child: BlinkingWidget(), alignment: Alignment(-0.5, 0))
                ])
              : widgetWithoutText, // i == value.length ensures blinking on focused digit box
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 6, bottom: 6),
        );
      }
    });
  }
}
