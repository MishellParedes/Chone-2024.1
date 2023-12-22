import 'dart:convert';
import 'package:sapo_benefica/data/api/global_api.dart';
import 'package:sapo_benefica/data/aws/aws_secrets.dart';
import 'package:sapo_benefica/data/aws/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:sapo_benefica/data/models/client_model.dart';

class ApiQueryClientInMufasa {
  static Future<dynamic> queryClientInMufasa(String numCed) async {
    final userService = UserService(AmazonConstant.userPool);
    final token = userService.session?.getIdToken().getJwtToken();
    final Map<String, String> headers = Map<String, String>.from({
      'Content-Type': 'application/json',
      'Authorization': token ?? '',
    });
    final http.Response response;
    try {
      response = await http.post(
        Uri.parse(graphQLAPI),
        headers: headers,
        body: json.encode(Client.clientInMufasa(numCed)),
      );
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body)['data']
            ['queryAfiliacionesByIdSociocedulaIndex']['items'];
        for (var i = 0; i < list.length; i++) {
          if (list[i]['cooperativa'] == 'Benefica') {
            return jsonDecode(response.body)['data']
                ['queryAfiliacionesByIdSociocedulaIndex']['items'][i];
          }
        }
        return "No Existe";
      }
    } catch (e) {
      return 'Error';
    }
    return "Error";
  }
}
