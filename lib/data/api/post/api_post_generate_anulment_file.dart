import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sapo_benefica/data/api/global_api.dart';
import 'package:sapo_benefica/data/aws/secrest.dart';
import 'package:sapo_benefica/data/models/client_model.dart' as c;

class ApiGenerateAnulmentFile {
  static Future<String> generateToken() async {
    const String credentials = 'dev@ecx-labs.com:D3vECxd0cuAI!';
    final Map<String, String> headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
      'Content-type': 'application/json',
    };
    final http.Response response = await http.get(
      Uri.parse(urlGenerateToken),
      headers: headers,
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body)['access_token'];
    }
    return '';
  }

  static Future<dynamic> generateAnulmentFile(Map<String, dynamic> data) async {
    debugPrint('Generating merge for anulment file');
    final String token = await generateToken();
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    // final CognitoUser cognitoUser;
    // final CognitoUserSession session;
    // final credentials = CognitoCredentials(
    // 'us-east-2:e8be7eee-4b79-47a3-ae55-a47bffc74921', userPool);
    // cognitoUser = (await userPool.getCurrentUser())!;
    // session = (await cognitoUser.getSession())!;
    // await credentials.getAwsCredentials(session.getIdToken().getJwtToken());
    final DateTime dateNow = DateTime.now();
    final String dateToMerge = DateFormat('yyyy-MM-dd').format(dateNow);
    // AwsSigV4Client(
    // credentials.accessKeyId.toString(),
    // credentials.secretAccessKey.toString(),
    // 'https://janus.grupomancheno.com',
    // sessionToken: credentials.sessionToken,
    // region: 'us-east-2');

    // final client = data['client'];
    final Map<String, String> dictionaryData = {
      'fecha_transaccion': dateToMerge,
      'nombre_completo': data['nombrePersona'],
      'identificacion': data['cedulaPersona'],
      'cuenta': data['cuenta'],
      'valor_debitado': '${data['valor_debitado']}',
      'pin': data['pin'],
      'plan': data['plan'],
      'motivo_anulacion':data['motivo_anulacion'],
    };

    debugPrint('Dictionary data: $dictionaryData');

    final cedula = data['cedulaPersona'];
    final Map<String, String> body = {
      'template_file': 'anulment.pdf',
      'template_bucket': 'siniestros-documents-bucket/benefica/',
      'dictionary_data': jsonEncode(dictionaryData),
      'output_file': 'anulacion_$cedula.pdf',
      'output_bucket': 'janus-afiliaciones-documents/benefica/$cedula/',
      'bucket_region': 'us-east-2'
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(urlGenerateFile),
        headers: headers,
        body: utf8.encode(json.encode(body)),
      );
      debugPrint('Response generate file: ${response.body}');
      if (response.statusCode == 200) {
        return json.decode(response.body)['Answer:'];
      }
    } catch (e) {
      return 'Error';
    }
    return 'Error';
  }

  static Future<void> signAnulmentFile(Map<String, dynamic> data) async {
    final c.Client client = data['client'];
    bodySign['signer_name_1'] =
        '${client.sdtPrimerNombre} ${client.sdtSegundoNombre} ${client.sdtPrimerApellido} ${client.sdtSegundoApellido}';
    bodySign['signer_name_2'] = ' ';
    bodySign['signer_lastname_1'] = ' ';
    bodySign['signer_lastname_2'] = ' ';
    bodySign['signer_dni'] = data['cedulaPersona'];
    bodySign['signer_email'] = "notificaciones@grupomancheno.com";
    bodySign['signer_cellphone'] = "01234567890";
    bodySign['signer_address'] = client.sdtReferencia;
    bodySign['output_prefix'] = "/benefica/${data['cedulaPersona']}/firmados/";
    bodySign['doc_to_sign'] =
        "s3://janus-afiliaciones-documents/benefica/${data['cedulaPersona']}/anulacion_${data['cedulaPersona']}.pdf";
    bodySign["sign_page_number"] = "1";
    bodySign["sign_position"] = "250,160,650,250";
    final String token = await generateToken();
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final http.Response response = await http.post(
      Uri.parse(urlSignFile),
      headers: headers,
      body: utf8.encode(json.encode(bodySign)),
    );
    print("RESP FIRMA ANUL " + response.body.toString());
    if (response.statusCode == 200) {
      debugPrint(jsonDecode(response.body)['status']);
    }
  }
}
