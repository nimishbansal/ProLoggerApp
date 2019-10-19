import 'dart:collection';

import 'package:pro_logger/Auth/utils.dart';
import 'package:pro_logger/Entries/utils.dart';
import 'package:pro_logger/constants.dart';
import 'package:requests/requests.dart';

class AuthRepository {
  Future<bool> generateOtp({String phoneNo}) async {
    String requestUrl = BASE_URL + OTP_MESSAGE_ENDPOINT;
    HashMap<String, String> data;
    data = new HashMap<String, String>();
    data['phone_no'] = phoneNo;
    final Map<String, dynamic> response = await Requests.post(requestUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: data,
        json: true);
    print(response);
    return true;
  }
}