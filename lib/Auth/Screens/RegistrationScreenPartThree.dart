import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pro_logger/Auth/Repositories/auth_repository.dart';
import 'package:pro_logger/library_widgets/otp_field.dart';
import 'package:sms/sms.dart';

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

  @override
  void initState() {
    super.initState();
    receiver = new SmsReceiver();
    _streamSubscription = receiver.onSmsReceived.listen((SmsMessage msg) {
      if (AuthRepository().checkAuthorizedSMS(msg)) {
        RegExp regExp = new RegExp("(\\d{4})");
        String receivedOTP = regExp.firstMatch(msg.body).group(0);
        print(receivedOTP);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool buttonEnabled = (otpValue.length == 4);
    List phoneNoAndDialCode = ModalRoute.of(context).settings.arguments;
    String phoneNo = phoneNoAndDialCode[0];
    String dialCode = '+' + phoneNoAndDialCode[1];
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
              child: OTPField(
                onOtpChanged: (String currentOtp) {
                  setState(() {
                    otpValue = currentOtp;
                  });
                },
              ),
            ),
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
                        ? () => _handleNextPressed(context)
                        : null,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10,),
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

  _handleNextPressed(BuildContext context) {

  }
}
