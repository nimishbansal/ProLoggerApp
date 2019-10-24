import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

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

  /// Gap between two Adjacent Boxes.
  final Widget defaultGap;

  final ValueChanged<String> onOtpChanged;

  const OTPField(
      {Key key,
      this.boxWidth = 40,
      this.boxHeight = 40,
      this.defaultGap = const Padding(
        padding: EdgeInsets.all(4),
      ),
      this.onOtpChanged})
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
  bool _isKeyboardVisible = true;
  String otpValue = '';

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        _isKeyboardVisible = visible;
      },
    );

    maxLength = 4;
    for (int i = 0; i < maxLength; i++) {
      children.add(Container());
    }
    updateChildren('');
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
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ));
  }

  Widget getFilledBoxWithNo(String value) {
    return Container(
      height: widget.boxHeight,
      width: widget.boxWidth,
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
      ),
      alignment: Alignment.center,
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
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Visibility(
            child: textField,
            maintainSize: false,
            maintainAnimation: true,
            maintainState: true,
            visible: false,
          ),
          Container(
            child: GestureDetector(
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
                onTap: () {
                  // Don't execute if keyboard is already open and text field
                  // is already focused.
                  if (!_isKeyboardVisible) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => FocusScope.of(context).requestFocus(_focusNode),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  void updateChildren(value) {
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
                  alignment: Alignment(1.0, 0),
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
                    alignment: Alignment(-0.7, 0))
              ])
            : getUnfilledBoxWithoutNo(), // i == value.length ensures blinking on focused digit box
        alignment: Alignment.center,
//          padding: EdgeInsets.only(top: 6, bottom: 6),
      );
    }
  }

  void _handleOTPChanged(String value) {
    print("otp has been changed");
    setState(() {
      otpValue = value;
      updateChildren(value);
    });
    if (widget.onOtpChanged != null) widget.onOtpChanged(otpValue);
  }
}
