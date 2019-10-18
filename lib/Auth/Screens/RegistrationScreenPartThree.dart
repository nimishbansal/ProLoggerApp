import 'package:flutter/material.dart';

class RegistrationScreenPartThree extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistrationScreenPartThreeState();
  }
}

class RegistrationScreenPartThreeState
    extends State<RegistrationScreenPartThree> {

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
                padding: EdgeInsets.all(16),
                child: Text(
                    'Please wait while we\nauto verify the OTP\nsent to\n$dialCode${phoneNo.toString()}', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, ),),),
          ],
        ),
      ),
    );
  }
}
