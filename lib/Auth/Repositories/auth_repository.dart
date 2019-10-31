import 'dart:collection';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pro_logger/Auth/utils.dart';
import 'package:pro_logger/constants.dart';
import 'package:pro_logger/utility/network_utils.dart';
import 'package:requests/requests.dart';
import 'package:sms/sms.dart';
import 'package:pro_logger/globals.dart' as globals;

final storage = new FlutterSecureStorage();

class AuthRepository {
  Future<bool> generateOtp({String phoneNo}) async {
    String requestUrl = BASE_URL + OTP_MESSAGE_ENDPOINT;
    HashMap<String, String> data;
    data = new HashMap<String, String>();
    data['phone_no'] = phoneNo;
    Response r = await Requests.post(requestUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        json: data,);
    final Map<String, dynamic> response = r.json();
    print(response);
    return true;
  }

  Future<bool> validateOtp({String phoneNo, String otp}) async {
    String requestUrl = BASE_URL + OTP_VERIFY_ENDPOINT;
    HashMap<String, String> data;
    data = new HashMap<String, String>();
    data['phone_no'] = phoneNo;
    data['key'] = otp;
    Response r = await Requests.post(
      requestUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: data,
    );
    final Map<String, dynamic> response = r.json();
    if (response[STATUS] == SUCCESS) {
      storage.write(key: 'token', value: 'Token ${response['key']}');
      globals.authToken = 'Token ${response['key']}';
    }
    return true;
  }

  bool checkAuthorizedSMS(SmsMessage msg) {
    // TODO: add more rules
//      if (msg.sender!='VK-540604') return false;
    return true;
  }
}
