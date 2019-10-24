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


    @override
  void initState() {
    super.initState();
    receiver = new SmsReceiver();
    _streamSubscription = receiver.onSmsReceived.listen((SmsMessage msg) {
        if (AuthRepository().checkAuthorizedSMS(msg)){
            RegExp regExp = new RegExp("(\\d{4})");
            String receivedOTP = regExp.firstMatch(msg.body).group(0);
            print(receivedOTP);
        }

    });
  }

  @override
  Widget build(BuildContext context) {
    List phoneNoAndDialCode = ModalRoute.of(context).settings.arguments;
    String phoneNo = phoneNoAndDialCode[0];
    String dialCode = '+' + phoneNoAndDialCode[1];
    return Scaffold(
      body: Material(
        child: Column(
          children: <Widget>[
            SizedBox(height: 0.1*MediaQuery.of(context).size.height,),
            Container(
                padding: EdgeInsets.only(left: 40, top: 30),
                child: Text(
                    'Please wait.\nWe will auto verify\nthe OTP sent to\n$dialCode${phoneNo.toString()}', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, ),),),
            SizedBox(height: 0.1*MediaQuery.of(context).size.height,),
            OTPField(),
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
}
