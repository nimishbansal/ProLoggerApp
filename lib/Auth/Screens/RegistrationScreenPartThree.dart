import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro_logger/Auth/Repositories/auth_repository.dart';
import 'package:pro_logger/Entries/widgets/loader.dart';
import 'package:pro_logger/common_widgets.dart';
import 'package:pro_logger/library_widgets/otp_field.dart';
import 'package:sms/sms.dart';
import 'package:tuple/tuple.dart';

import '../utils.dart';

final otpFieldStateKey = new GlobalKey<OTPFieldState>();

class RegistrationScreenPartThree extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistrationScreenPartThreeState();
  }
}

class RegistrationScreenPartThreeState
    extends State<RegistrationScreenPartThree> {
  SmsReceiver receiver;

  StreamSubscription<SmsMessage> _streamSubscription;

  String otpValue = '';

  OTPField otpField;

  List phoneNoAndDialCode;
  String phoneNo;
  String dialCode;
  int otpEstimateTs;

  @override
  void initState() {
    super.initState();
    receiver = new SmsReceiver();
    _streamSubscription = receiver.onSmsReceived.listen((SmsMessage msg) {
      if (AuthRepository().checkAuthorizedSMS(msg)) {
        RegExp regExp = new RegExp("(\\d{4})");
        String receivedOTP = regExp.firstMatch(msg.body).group(0);
        print(receivedOTP);
        try {
          otpFieldStateKey.currentState.fillWithOTP(receivedOTP);
//          _handleNextPressed(context, dialCode+phoneNo);
        } catch (ex) {}
      }
    });
    otpEstimateTs = DateTime.now().millisecondsSinceEpoch + 20000;
  }

  @override
  Widget build(BuildContext context) {
    bool buttonEnabled = (otpValue.length == 4);
    this.otpField = OTPField(
      key: otpFieldStateKey,
      onOtpChanged: (String currentOtp) {
        setState(() {
          otpValue = currentOtp;
        });
      },
    );
    phoneNoAndDialCode = ModalRoute.of(context).settings.arguments;
    phoneNo = phoneNoAndDialCode[0];
    dialCode = '+' + phoneNoAndDialCode[1];
    return Scaffold(
      body: Material(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 0.1 * MediaQuery.of(context).size.height,
            ),
            Container(
              child: Text(
                'Please wait.\nWe will auto verify\nthe OTP sent to\n$dialCode${phoneNo.toString()}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              padding: EdgeInsets.only(left: 40),
              alignment: Alignment.centerLeft,
            ),
            SizedBox(
              height: 0.1 * MediaQuery.of(context).size.height,
            ),
            Container(
              padding: EdgeInsets.only(left: 40),
              alignment: Alignment.centerLeft,
              child: this.otpField,
            ),
            SizedBox(height: 20,),
            StreamBuilder(
                stream: Stream.periodic(Duration(seconds: 1), (i) => i),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  DateFormat format = DateFormat("mm:ss");
                  int now = DateTime.now().millisecondsSinceEpoch;
                  Duration remaining =
                      Duration(milliseconds: otpEstimateTs - now);
                  if (remaining >= Duration.zero) {
                    var dateString =
                        '${remaining.inMinutes}:${remaining.inSeconds}';
                    return Container(
                      padding: EdgeInsets.only(left: 40),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          'Auto Verifying your otp in ${format.format(format.parse(dateString))}',
                      style: TextStyle(fontSize: 18),),
                    );
                  } else {
                    return GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(left: 40),
                        alignment: Alignment(-0.6, 0),
                        child: Row(
                          children: <Widget>[
                            Text('Didn\'t Received OTP? ', style: TextStyle(fontSize: 18),),
                            Text('Resend OTP', style: TextStyle(color: Colors.blue,decoration:TextDecoration.underline,fontSize: 18)),
                          ],
                        ),
                      ),
                      onTap: (){
                        setState(() {
                          AuthRepository().generateOtp(phoneNo: dialCode+phoneNo);
                          otpEstimateTs = DateTime.now().millisecondsSinceEpoch + 20000;
                        });
                      },
                    );
                  }
                }),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  //https://stackoverflow.com/a/52697978/7698247
                  color: buttonEnabled ? Colors.black : Colors.grey,
                  child: InkWell(
                    splashColor: Colors.white,
                    radius: 200,
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Next',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        width: 0.9 * MediaQuery.of(context).size.width),
                    onTap: buttonEnabled
                        ? () => _handleNextPressed(context, dialCode + phoneNo)
                        : null,
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

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  _handleNextPressed(BuildContext context, String phoneNo) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return Loader();
        });
      validateOtp(otpValue, phoneNo).then((Tuple3<bool, String, String> tup) {
        bool isOtpValid = tup.item1;
        String reason = tup.item2;
        String title = tup.item3;
        Navigator.of(context).pop();
        if (!isOtpValid) {
          showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return getAlertDialog(
                context: buildContext,
                title: title,
                buttonText: 'OK',
                description: reason,
                onTap: () {
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FocusScope.of(context)
                            .requestFocus(otpFieldStateKey.currentState.focusNode);
                  });
                },
              );
            },
          );
        } else {
          Navigator.of(context).pushNamed('HomeScreen');
        }
      });
  }

  Future<Tuple3<bool, String, String>> validateOtp(String otp, String phoneNo) async {
    try{
      bool result =
      await AuthRepository().validateOtp(phoneNo: phoneNo, otp: otp);
      String reason, title;
      if (!result){
        reason = INVALID_OTP_MESSAGE;
        title = INVALID_OTP_TITLE;
      }
      return Tuple3(result, reason, title);
    }
    catch(e){
      return Tuple3(false, e.toString(), 'Some error occurred');
    }

  }
}
