import 'package:flutter/material.dart';

class BlinkingCaret extends StatefulWidget {
  /// caret cursor color.
  final Color cursorColor;

  /// width of caret cursor.
  final double width;

  final EdgeInsetsGeometry caretPadding;

  const BlinkingCaret(
      {Key key,
      this.cursorColor = Colors.blue,
      this.width = 2,
      this.caretPadding = const EdgeInsets.only(top: 8, bottom: 8)})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return BlinkingCaretState();
  }
}

class BlinkingCaretState extends State<BlinkingCaret>
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
        return Container(
          padding: widget.caretPadding,
          child: SizedBox(
            height: double.infinity,
            child: Container(
              width: widget.width,
              color: _animation.value,
            ),
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

class OTPField extends StatefulWidget {
  /// Width of the single OTP box
  final double boxWidth;

  /// Height of the single OTP box
  final double boxHeight;

  final Widget defaultGap;

  const OTPField(
      {Key key,
      this.boxWidth = 40,
      this.boxHeight = 40,
      this.defaultGap = const Padding(padding: EdgeInsets.all(4))})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OTPFieldState();
  }
}

class OTPFieldState extends State<OTPField> {
  List<Widget> otpContainers;
  List<Widget> otpContainersWithPadding;
  List<Widget> children = List<Widget>();
  int maxLength;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    maxLength = 4;
    for (int i = 0; i < maxLength; i++) {
      children.add(getUnfilledBoxWithoutNo());
    }
    _handleOTPChanged('');
  }

  Widget getUnfilledBoxWithoutNo() {
    return Container(
        height: widget.boxHeight,
        width: widget.boxWidth,
        alignment: Alignment.center,
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          maxRadius: 7,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ));
  }

  Widget getFilledBoxWithNo(String value) {
    return Container(
      height: widget.boxHeight,
      width: widget.boxWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.blue)),
      /*
        child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
      */
      child: Image.network(
          "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQa49UMY_GWpfxiR-1Os0-cBPmygpTgGECD_LLxYzO26UOb1pFa"),
      alignment: Alignment.center,
    );

    Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget textField = TextField(
      enableInteractiveSelection: false,
      maxLength: maxLength,
      autofocus: true,
      focusNode: _focusNode,
      keyboardType: TextInputType.phone,
      onChanged: _handleOTPChanged,
    );

    return Material(
      child: Stack(
        children: <Widget>[
          Visibility(
            child: textField,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: false,
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 4)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(
                  2 * maxLength - 1,
                  (int index) {
                    if (index % 2 == 0)
                      return Container(
                        width: widget.boxWidth,
                        height: widget.boxHeight,
                        child: this.children[(index / 2).floor()],
                        alignment: Alignment.center,
                      );
                    else
                      return widget.defaultGap;
                  },
                ),
              ),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(_focusNode);
            },
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
        Widget textWidget = getFilledBoxWithNo(value[i]);
        this.children[i] = i == maxLength - 1
            ? Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  textWidget,
                  Align(
                    child: BlinkingCaret(
                      caretPadding: EdgeInsets.only(
                          left: 4,
                          right: 4,
                          top: 0.1 * widget.boxHeight,
                          bottom: 0.1 * widget.boxHeight),
                    ),
                    alignment: Alignment(0.65, 0),
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
                  getUnfilledBoxWithoutNo(),
                  Align(
                      child: BlinkingCaret(
                        caretPadding: EdgeInsets.only(
                            left: 4,
                            right: 4,
                            top: 0.1 * widget.boxHeight,
                            bottom: 0.1 * widget.boxHeight),
                      ),
                      alignment: Alignment(-0.65, 0))
                ])
              : getUnfilledBoxWithoutNo(), // i == value.length ensures blinking on focused digit box
          alignment: Alignment.center,
//          padding: EdgeInsets.only(top: 6, bottom: 6),
        );
      }
    });
  }
}
