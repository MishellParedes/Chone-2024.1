import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sapo_benefica/data/api/global_api.dart';
import 'package:sapo_benefica/data/aws/aws_secrets.dart';
import 'package:sapo_benefica/data/aws/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:sapo_benefica/data/models/client_model.dart' as c;

class ApiUpdateClientBenefit {
  static Future<dynamic> updateBenefit(Map<String, dynamic> data) async {
    final userService = UserService(AmazonConstant.userPool);
    await userService.init();
    final token = userService.session?.getIdToken().getJwtToken();
    final body = {
      'operationName': 'updateAfiliaciones',
      'query': '''mutation updateAfiliaciones {
      updateAfiliaciones(input: {
        id: "${data['id']}",
        socioBeneficiarios: "${data['socioBeneficiarios']}",
        socioTipoBeneficiarios: "${data['socioTipoBeneficiarios']}",
        }) {
          id
        } 
      }
      ''',
    };
    try {
      final response = await http.post(
        Uri.parse(graphQLAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? '',
        },
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data']['updateAfiliaciones']['id'] ??
            'Error';
      }
    } catch (e) {
      return 'Error';
    }
    return 'Error';
  }

  static generateCertificate(Map<String, dynamic> data) async {
    try {
      // Obtenemos el token de acceso
      final String token = await generateToken();

      // Creamos el encabezado para las siguientes peticiones
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Generamos los documentos
      await generateCertificado(headers, data);

      // Firmamos los documentos
      await signCertificado(headers, data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

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

  static Future<void> generateCertificado(
      Map<String, String> headers, Map<String, dynamic> data) async {
    print('*****************');
    print('Entre al generate');
    print('*****************');

    final c.Client client = data['client'];
    final String fechaInicioVigencia =
        data['mufasa']['socioOpcion'] == 'Regularización'
            ? '01/11/2023'
            : data['mufasa']['fechaGestion']
                .toString()
                .substring(0, 10)
                .replaceAll('-', '/');
    final Map<String, String> dictionaryData = {
      'd1': fechaInicioVigencia.split('/')[0],
      'm1': fechaInicioVigencia.split('/')[1],
      'a1': fechaInicioVigencia.split('/')[2],
      'numero_poliza': 'MTRX-0949413001-1',
      'Nombres y Apellidos':
          '${client.sdtPrimerNombre} ${client.sdtPrimerApellido}',
      'direccion': client.sdtCallePrincipal,
      'identificacion': client.sdtNumeroIdentificacion,
      'email': data['mufasa']['socioEmailNuevo'] == ''
          ? data['mufasa']['socioEmailAnterior']
          : data['mufasa']['socioEmailNuevo'],
      'fecha_nacimiento': client.sdtFechaNacimientoCh,
      'beneficiario_1': data['dependents'][0]['name'],
      'beneficiario_2': data['dependents'][1]['name'],
      'beneficiario_3': data['dependents'][2]['name'],
      'beneficiario_4': data['dependents'][3]['name'],
      'beneficiario_5': data['dependents'][4]['name'],
      'relacion_1': data['dependents'][0]['relationship'],
      'relacion_2': data['dependents'][1]['relationship'],
      'relacion_3': data['dependents'][2]['relationship'],
      'relacion_4': data['dependents'][3]['relationship'],
      'relacion_5': data['dependents'][4]['relationship'],
      'porcentaje_1': data['dependents'][0]['age'],
      'porcentaje_2': data['dependents'][1]['age'],
      'porcentaje_3': data['dependents'][2]['age'],
      'porcentaje_4': data['dependents'][3]['age'],
      'porcentaje_5': data['dependents'][4]['age'],
      'celular': data['mufasa']['socioCelularNuevo'] == ''
          ? data['mufasa']['socioCelularAnterior']
          : data['mufasa']['socioCelularNuevo'],
      'nacionalidad': client.sdtNacionalidad,
      'estado_civil': client.sdtEstadoCivil,
      'ciudad': client.sdtCiudad,
    };
    final Map<String, String> body = {
      'template_file': 'certificado_1.pdf',
      'template_bucket': 'siniestros-documents-bucket/benefica/',
      'dictionary_data': jsonEncode(dictionaryData),
      'output_file': '${client.sdtNumeroIdentificacion}_certificado_1.pdf',
      'output_bucket':
          'janus-afiliaciones-documents/benefica/${client.sdtNumeroIdentificacion}/',
      'bucket_region': 'us-east-2'
    };
    final http.Response response = await http.post(
      Uri.parse(urlGenerateFile),
      headers: headers,
      body: utf8.encode(json.encode(body)),
    );
    if (response.statusCode == 200) {
      print('*****************');
      print('Si se generan los docs');
      print(response.body);
      print('*****************');
      print('DATOS');
      print(
        client.sdtNacionalidad,
      );
      debugPrint(jsonDecode(response.body)['status']);
    }
  }

  static Future<void> signCertificado(
      Map<String, String> headers, Map<String, dynamic> data) async {
    final c.Client client = data['client'];
    bodySign['signer_name_1'] = client.sdtPrimerNombre;
    bodySign['signer_name_2'] = client.sdtSegundoNombre;
    bodySign['signer_lastname_1'] = client.sdtPrimerApellido;
    bodySign['signer_lastname_2'] = client.sdtSegundoApellido;
    bodySign['signer_dni'] = client.sdtNumeroIdentificacion;
    bodySign['output_prefix'] = "/benefica/${data['cedula']}/firmados/";
    bodySign['doc_to_sign'] =
        's3://janus-afiliaciones-documents/benefica/${data['cedula']}/${data['cedula']}_certificado.pdf';
    bodySign['sign_page_number'] = '1';
    bodySign['sign_position'] = '550,230,650,250';
    final http.Response response = await http.post(
      Uri.parse(urlSignFile),
      headers: headers,
      body: utf8.encode(json.encode(bodySign)),
    );
    if (response.statusCode == 200) {
      debugPrint(jsonDecode(response.body)['status']);
    }
  }
}
