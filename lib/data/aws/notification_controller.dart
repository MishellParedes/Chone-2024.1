import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sapo_benefica/data/aws/otp.dart';
// import 'package:sapo_benefica/models/user_model.dart';
import 'package:sapo_benefica/data/aws/secrest.dart';
import 'package:sapo_benefica/data/aws/user_service.dart';

import 'package:base32/base32.dart';

class NotificationController {
  dynamic sendSMS(String path, String pinCode, String phoneNumber) async {
    final userService = UserService(userPool);

    // User _user = User();
    // bool _isAutheticated = false;

    await userService.init();
    // _user = (await userService.getCurrentUser())!;

    // final _credentials = await userService.getCredentials();

    // final signedRequest =
    //     SigV4Request(awsSigV4Client, method: 'POST', path: _path, body: {
    //   "phone_number": _phone_number,
    //   "pin_code": _pin_code,
    //   "message_id": "23808",
    //   "url": "https://cutt.ly/dbEUyFK"
    // }
    // path: '/dbquery/',
    //   body: {
    // 'queryType': 'polizas',
    // 'ejecutivo': 'galo@ecx-labs.com',
    // 'cliente': ''
    // }
    // );

    // print("Almost going to do the request");
    const String baseUrl = "https://janus.grupomancheno.com/send-otp";
    Uri uri = Uri.parse(baseUrl);

    final headers = {'Content-type': 'application/json'};
    final qParams = {
      "phone_number": phoneNumber.toString(),
      "pin_code": pinCode.toString(),
      "message_id": "34014",
      "url": "https://cutt.ly/dbEUyFK"
    };

    // http.Response response;
    try {
      // response = await http.post(uri, headers: headers, body: jsonEncode(qParams));
      await http.post(uri, headers: headers, body: jsonEncode(qParams));
      // print(response.body);
    } catch (e) {
      // print("Error");
      // print(e);
      return "Error";
    }
  }

  dynamic sendSMSAnulment(
      String path, String pinCode, String phoneNumber) async {
    final userService = UserService(userPool);

    // User _user = User();
    // bool _isAutheticated = false;

    await userService.init();
    // _user = (await userService.getCurrentUser())!;

    // final _credentials = await userService.getCredentials();

    // final signedRequest =
    //     SigV4Request(awsSigV4Client, method: 'POST', path: _path, body: {
    //   "phone_number": _phone_number,
    //   "pin_code": _pin_code,
    //   "message_id": "23808",
    //   "url": "https://cutt.ly/dbEUyFK"
    // }
    // path: '/dbquery/',
    //   body: {
    // 'queryType': 'polizas',
    // 'ejecutivo': 'galo@ecx-labs.com',
    // 'cliente': ''
    // }
    // );

    // print("Almost going to do the request");
    const String baseUrl = "https://janus.grupomancheno.com/send-otp";
    Uri uri = Uri.parse(baseUrl);

    final headers = {'Content-type': 'application/json'};
    final qParams = {
      "phone_number": phoneNumber.toString(),
      "pin_code": pinCode.toString(),
      "message_id": "31863",
      "url": "https://cutt.ly/dbEUyFK"
    };

    // http.Response response;
    try {
      // response = await http.post(uri, headers: headers, body: jsonEncode(qParams));
      await http.post(uri, headers: headers, body: jsonEncode(qParams));
      // print(response.body);
    } catch (e) {
      // print("Error");
      // print(e);
      return "Error";
    }
  }
}

class OtpController {
  generateCode(String nonEncodedString) {
    // print("Generating Code..");
    if (nonEncodedString.length < 10) {
      // print("Invalid length");
      nonEncodedString = "${nonEncodedString}12";
    }
    var stringToEncode =
        (nonEncodedString.replaceAll(" ", "")).substring(0, 10);
    var encodedString = base32.encodeString(stringToEncode);
    final code = OTP.generateTOTPCodeString(
        encodedString, DateTime.now().millisecondsSinceEpoch,
        interval: 900);
    // print(int.parse(code.substring(2)));
    return int.parse(code);
  }

  bool verifyCode(int userInputCode, String nonEncodedString) {
    if (userInputCode == generateCode(nonEncodedString)) {
      return true;
    } else {
      return false;
    }
  }

  // final code = OptController()
  //                                                 .generateCode();
  //                                             print(code);

  // var inputOptCode = int.parse(
  //                                             pin1InputTextController.text +
  //                                                 pin2InputTextController.text +
  //                                                 pin3InputTextController.text +
  //                                                 pin4InputTextController.text);
  //                                         print(OptController()
  //                                             .verifyCode(inputOptCode));
}
