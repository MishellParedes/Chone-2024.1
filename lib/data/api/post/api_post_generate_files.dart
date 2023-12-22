import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sapo_benefica/data/api/global_api.dart';
import 'package:http/http.dart' as http;
import 'package:sapo_benefica/data/models/client_model.dart' as c;

class ApiGenerateFiles {
  static Future<dynamic> generateFiles(Map<String, dynamic> data) async {
    try {
      // Obtenemos el token de acceso
      final String token = await generateToken();

      // Creamos el encabezado para las siguientes peticiones
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Generamos los documentos
      await generateAuthBroker(headers, data);
      await generateAuthData(headers, data);
      await generateAuthDebit(headers, data);
      await generateCertificado(headers, data);
      //todo removed the commented line after the enrolamiento is ready
      // await generateEnrolamiento(headers, data);

      // Firmamos los documentos
      await signAuthBroker(headers, data);
      await signAuthData(headers, data);
      await signAuthDebit(headers, data);
      await signCertificado(headers, data);
      //todo removed the commented line after the enrolamiento is ready
      // await signEnrolamiento(headers, data);
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

  static Future<void> generateAuthBroker(
      Map<String, String> headers, Map<String, dynamic> data) async {
    final c.Client client = data['client'];
    var fechaToday = DateFormat('dd-MM-yyyy', 'es_ES').format(DateTime.now());
    final Map<String, String> dictionaryData = {'lugar_fecha': fechaToday};
    final Map<String, String> body = {
      'template_file': 'auth_broker.pdf',
      'template_bucket': 'siniestros-documents-bucket/benefica/',
      'dictionary_data': jsonEncode(dictionaryData),
      'output_file': '${client.sdtNumeroIdentificacion}_auth_broker.pdf',
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
      debugPrint(jsonDecode(response.body)['status']);
    }
  }

  static Future<void> generateAuthData(
      Map<String, String> headers, Map<String, dynamic> data) async {
    final c.Client client = data['client'];
    var fechaToday = DateFormat('dd-MM-yyyy', 'es_ES').format(DateTime.now());
    final Map<String, String> dictionaryData = {'lugar_fecha': fechaToday};
    final Map<String, String> body = {
      'template_file': 'auth_data.pdf',
      'template_bucket': 'siniestros-documents-bucket/benefica/',
      'dictionary_data': jsonEncode(dictionaryData),
      'output_file': '${client.sdtNumeroIdentificacion}_auth_data.pdf',
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
      debugPrint(jsonDecode(response.body)['status']);
    }
  }

  static Future<void> generateAuthDebit(
      Map<String, String> headers, Map<String, dynamic> data) async {
    final c.Client client = data['client'];
    var fechaToday = DateFormat('dd-MM-yyyy', 'es_ES').format(DateTime.now());
    final Map<String, String> dictionaryData = {
      'lugar_fecha': fechaToday,
      'nombre_completo':
          '${client.sdtPrimerNombre} ${client.sdtSegundoNombre} ${client.sdtPrimerApellido} ${client.sdtSegundoApellido}',
      'numero_cuenta': client.sdtNumeroCuenta,
      'aseguradora': data['aseguradora'],
      'identificacion': client.sdtNumeroIdentificacion,
      'valor_opcion': data['valor_opcion'],
      'poliza': '1944',
    };
    final Map<String, String> body = {
      'template_file': 'auth_debit.pdf',
      'template_bucket': 'siniestros-documents-bucket/benefica/',
      'dictionary_data': jsonEncode(dictionaryData),
      'output_file': '${client.sdtNumeroIdentificacion}_auth_debit.pdf',
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
      debugPrint(jsonDecode(response.body)['status']);
    }
  }

  static Future<void> generateCertificado(
      Map<String, String> headers, Map<String, dynamic> data) async {
    final c.Client client = data['client'];
    var fechaToday = DateFormat('dd-MM-yyyy', 'es_ES').format(DateTime.now());

    final String fechaInicioVigencia = data['fechaInicioVigencia'];

    var selectedPlan = data["plan"];

    var opcion1;
    var opcion2;
    var opcion3;
    var opcion4;
    var opcion5;
    var opcion6;
    var opcion7;

    if (selectedPlan.contains('Básico')) {
      opcion1 = "X";
      opcion2 = "";
      opcion3 = "";
      opcion4 = "";
      opcion5 = "";
      opcion6 = "";
      opcion7 = "";
    } else if (selectedPlan.contains('1')) {
      opcion1 = "";
      opcion2 = "X";
      opcion3 = "";
      opcion4 = "";
      opcion5 = "";
      opcion6 = "";
      opcion7 = "";
    } else if (selectedPlan.contains('2')) {
      opcion1 = "";
      opcion2 = "";
      opcion3 = "X";
      opcion4 = "";
      opcion5 = "";
      opcion6 = "";
      opcion7 = "";
    } else if (selectedPlan.contains('3')) {
      opcion1 = "";
      opcion2 = "";
      opcion3 = "";
      opcion4 = "X";
      opcion5 = "";
      opcion6 = "";
      opcion7 = "";
    } else if (selectedPlan.contains('4')) {
      opcion1 = "";
      opcion2 = "";
      opcion3 = "";
      opcion4 = "";
      opcion5 = "X";
      opcion6 = "";
      opcion7 = "";
    } else if (selectedPlan.contains('5')) {
      opcion1 = "";
      opcion2 = "";
      opcion3 = "";
      opcion4 = "";
      opcion5 = "";
      opcion6 = "X";
      opcion7 = "";
    }
    final Map<String, String> dictionaryData = {
      'nombre_completo':
          '${client.sdtPrimerNombre} ${client.sdtSegundoNombre} ${client.sdtPrimerApellido} ${client.sdtSegundoApellido}',
      'direccion': client.sdtCallePrincipal,
      'identificacion': client.sdtNumeroIdentificacion,
      'fecha_inicio': fechaInicioVigencia,
      'numero_cuenta': client.sdtNumeroCuenta,
      'cuenta': client.sdtNumeroCuenta,
      'fecha_final': "",
      'email': client.sdtEmail,
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
      'canton': client.sdtCanton,
      'nacionalidad': client.sdtNacionalidad,
      'ocupacion': client.sdtOcupacionDes,
      'provincia': client.sdtProvincia,
      'opcion_basica': opcion1,
      'opcion_1': opcion2,
      'opcion_2': opcion3,
      'opcion_3': opcion4,
      'opcion_4': opcion5,
      'opcion_5': opcion6,
    };
    String cert = '';
    if (data['plan'] == 'Opción 1 Socio + Familia') {
      cert = 'certificado_1.pdf';
    } else {
      cert = 'certificado_2.pdf';
    }

    final Map<String, String> body = {
      'template_file': cert,
      'template_bucket': 'siniestros-documents-bucket/benefica/',
      'dictionary_data': jsonEncode(dictionaryData),
      'output_file': '${client.sdtNumeroIdentificacion}_certificado.pdf',
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
      debugPrint(jsonDecode(response.body)['status']);
    }
  }

  static Future<void> generateEnrolamiento(
      Map<String, String> headers, Map<String, dynamic> data) async {
    final c.Client client = data['client'];
    final Map<String, String> dictionaryData = {
      'Contratante': 'Cooperativa Benefica',
      'Nombres y Apellidos':
          '${client.sdtPrimerNombre} ${client.sdtSegundoNombre} ${client.sdtPrimerApellido} ${client.sdtSegundoApellido}',
      'CI  Pagemarte': client.sdtNumeroIdentificacion,
      'Fecha de Nacimiento': client.sdtFechaNacimientoCh,
      'Estado Civil': client.sdtEstadoCivil,
      'Edad': client.sdtFechaNacimientoCh,
      'Ciudad': client.sdtCiudad,
      'Ciudad_2': client.sdtCanton,
      'Enfermedad': data['enfermedades'],
      'USTED POSEE OTROS SEGUROS': '',
      'No': '',
      'Monto AseguradoRow1': '',
      'RamoRow1': '',
      'Fecha de VigenciaRow1': '',
      'Monto AseguradoRow2': '',
      'RamoRow2': '',
      'Fecha de VigenciaRow2': '',
      'Monto AseguradoRow3': '',
      'RamoRow3': '',
      'Fecha de VigenciaRow3': '',
      'Apellidos y NombresRow1': '',
      'ParentescoRow1': '',
      'Porcentaje Row1': '',
      'Apellidos y NombresRow2': '',
      'ParentescoRow2': '',
      'Porcentaje Row2': '',
      'Apellidos y NombresRow3': '',
      'ParentescoRow3': '',
      'Porcentaje Row3': '',
      'Apellidos y NombresRow4': '',
      'ParentescoRow4': '',
      'Porcentaje Row4': '',
      'Apellidos y NombresRow5': '',
      'ParentescoRow5': '',
      'Porcentaje Row5': '',
      'Apellidos y NombresRow6': '',
      'ParentescoRow6': '',
      'Porcentaje Row6': '',
      'Apellidos y NombresRow7': '',
      'ParentescoRow7': '',
      'Porcentaje Row7': '',
      'Seguros del Pichincha': '',
      'Asegurado': '',
      'Direccion Domicilio': '',
      'Direccion Comercial': '',
      'Telefono': '',
      'Telefono_2': '',
      'Fecha del Diagnostico': '',
      'CompaniaRow1': '',
      'CompaniaRow2': '',
      'CompaniaRow3': '',
      'Si': '',
      'Ocupacion Especifica': '',
    };
    final Map<String, String> body = {
      'template_file': 'enrolamiento.pdf',
      'template_bucket': 'siniestros-documents-bucket/benefica/',
      'dictionary_data': jsonEncode(dictionaryData),
      'output_file': '${client.sdtNumeroIdentificacion}_enrolamiento.pdf',
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
      debugPrint(jsonDecode(response.body)['status']);
    }
  }

  static Future<void> signAuthBroker(
      Map<String, String> headers, Map<String, dynamic> data) async {
    final c.Client client = data['client'];
    bodySign['signer_name_1'] = client.sdtPrimerNombre;
    bodySign['signer_name_2'] = client.sdtSegundoNombre;
    bodySign['signer_lastname_1'] = client.sdtPrimerApellido;
    bodySign['signer_lastname_2'] = client.sdtSegundoApellido;
    bodySign['signer_dni'] = client.sdtNumeroIdentificacion;
    bodySign['output_prefix'] =
        "/benefica/${client.sdtNumeroIdentificacion}/firmados/";
    bodySign['doc_to_sign'] =
        "s3://janus-afiliaciones-documents/benefica/${client.sdtNumeroIdentificacion}/${client.sdtNumeroIdentificacion}_auth_broker.pdf";
    bodySign["sign_position"] = "250,160,650,250";
    bodySign["sign_page_number"] = "1";
    final http.Response response = await http.post(
      Uri.parse(urlSignFile),
      headers: headers,
      body: utf8.encode(json.encode(bodySign)),
    );
    if (response.statusCode == 200) {
      debugPrint(jsonDecode(response.body)['status']);
    }
  }

  static Future<void> signAuthData(
      Map<String, String> headers, Map<String, dynamic> data) async {
    final c.Client client = data['client'];
    bodySign['doc_to_sign'] =
        "s3://janus-afiliaciones-documents/benefica/${client.sdtNumeroIdentificacion}/${client.sdtNumeroIdentificacion}_auth_data.pdf";
    bodySign["sign_page_number"] = "3";
    bodySign["sign_position"] = "250,360,650,250";
    final http.Response response = await http.post(
      Uri.parse(urlSignFile),
      headers: headers,
      body: utf8.encode(json.encode(bodySign)),
    );
    if (response.statusCode == 200) {
      debugPrint(jsonDecode(response.body)['status']);
    }
  }

  static Future<void> signAuthDebit(
      Map<String, String> headers, Map<String, dynamic> data) async {
    final c.Client client = data['client'];
    bodySign['doc_to_sign'] =
        "s3://janus-afiliaciones-documents/benefica/${client.sdtNumeroIdentificacion}/${client.sdtNumeroIdentificacion}_auth_debit.pdf";
    bodySign["sign_page_number"] = "1";
    bodySign["sign_position"] = "250,160,650,250";
    final http.Response response = await http.post(
      Uri.parse(urlSignFile),
      headers: headers,
      body: utf8.encode(json.encode(bodySign)),
    );
    if (response.statusCode == 200) {
      debugPrint(jsonDecode(response.body)['status']);
    }
  }

  static Future<void> signCertificado(
      Map<String, String> headers, Map<String, dynamic> data) async {
    final c.Client client = data['client'];
    bodySign['doc_to_sign'] =
        "s3://janus-afiliaciones-documents/benefica/${client.sdtNumeroIdentificacion}/${client.sdtNumeroIdentificacion}_certificado.pdf";
    bodySign["sign_position"] = "390,190,320,390";
    bodySign["sign_page_number"] = "5";
    final http.Response response = await http.post(
      Uri.parse(urlSignFile),
      headers: headers,
      body: utf8.encode(json.encode(bodySign)),
    );
    if (response.statusCode == 200) {
      debugPrint(jsonDecode(response.body)['status']);
    }
  }

  static Future<void> signEnrolamiento(
      Map<String, String> headers, Map<String, dynamic> data) async {
    final c.Client client = data['client'];
    bodySign['doc_to_sign'] =
        "s3://janus-afiliaciones-documents/benefica/${client.sdtNumeroIdentificacion}/${client.sdtNumeroIdentificacion}_enrolamiento.pdf";
    bodySign["sign_position"] = "370,330,650,250";
    bodySign["sign_page_number"] = "2";
    final http.Response response = await http.post(
      Uri.parse(urlSignFile),
      headers: headers,
      body: utf8.encode(json.encode(bodySign)),
    );
    if (response.statusCode == 200) {
      debugPrint(jsonDecode(response.body)['status']);
    }
  }

  static Future sendEmail(Map<String, dynamic> data) async {
    final String direccionAuthBroker =
        "https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/benefica/${data['cedula']}/firmados/${data['cedula']}_auth_broker.pdf";
    final String direccionAuthData =
        "https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/benefica/${data['cedula']}/firmados/${data['cedula']}_auth_data.pdf";
    final String direccionAuthDebit =
        "https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/benefica/${data['cedula']}/firmados/${data['cedula']}_auth_debit.pdf";
    final String direccionCertificado =
        "https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/benefica/${data['cedula']}/firmados/${data['cedula']}_certificado.pdf";
    final String direccionEnrolamiento =
        "https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/benefica/${data['cedula']}/firmados/${data['cedula']}_enrolamiento.pdf";
    const String serviceId = 'service_orlhyck';
    String templateId = "d-28c1fc25da7d45deb1b6e77caec2ee50";
    final Uri urlSendGrid = Uri.parse(
        'https://us-central1-bubo-force.cloudfunctions.net/function-emailing-system/sendGridGM');
    const String token = 'hlACSAbxfhfruyvg9g4ql5463738';

    Map<String, String> headersEmailJS = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    var saludoHere = "BIENVENIDO/A";
    var socioHere = "Estimado/a Socio/a";

    var fechaToday = DateFormat('dd-MM-yyyy', 'es_ES').format(DateTime.now());
    var fechaToYear = "01/11/2024";

    // print("GENERO 2 " + genero);

    // if (genero == "M") {
    //   saludoHere = "BIENVENIDO";
    //   socioHere = "Estimado Socio";
    // } else if (genero == "F") {
    //   saludoHere = "BIENVENIDA";
    //   socioHere = "Estimada Socia";
    // }

    Map<String, dynamic> bodySendGrid = {
      "subject": "Afiliación de Fondo Mortuorio",
      "nameUser": data['nombre'],
      "templateID": "d-28c1fc25da7d45deb1b6e77caec2ee50",
      "fromEmail": "tuamigo@grupomancheno.com",
      "toEmail": data['email'],
      "message": "test",
      "welcome_ctrl": saludoHere,
      "client_ctrl": socioHere,
      "client_name": data['nombre'],
      "plan": data['plan'],
      "period_start": fechaToday,
      "period_end": fechaToYear,
      "auth_broker_url": direccionAuthBroker,
      //"auth_data_url": direccionAuthData,
      "auth_debit_url": direccionAuthDebit,
      "cert_url": direccionCertificado,
    };

    http.Response response;

    try {
      response = await http.post(
        urlSendGrid,
        headers: headersEmailJS,
        body: jsonEncode(bodySendGrid),
      );
      // print('email ${response.body}');
      if (response.statusCode == 202) {
        print(
          'Email enviado correctamente.',
        );
      } else {
        print(
          response.body.toString(),
        );
      }
    } catch (e) {
      print('email error $e');
      print(
        e.toString(),
      );
    }
  }

  Future sendEmailRegularizacion(email, cedula, nombre, plan, genero) async {
    initializeDateFormatting('es_ES', null).then((_) => null);
    print("About to send email");

    var direccionAutorizacion =
        "https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/santaana_2023/$cedula/firmados/${cedula}_auth_debit.pdf";
    var direccionVida =
        "https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/santaana_2023/$cedula/firmados/${cedula}_certificado.pdf";

    var direccionAsistencia =
        "https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/santaana_2023/$cedula/firmados/${cedula}_auth_broker.pdf";

    var direccionAutorizacionDatos =
        "https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/santaana_2023/$cedula/firmados/${cedula}_auth_data.pdf";
    print("SENDING");

    const String serviceId = 'service_orlhyck';
    String templateId = "d-28c1fc25da7d45deb1b6e77caec2ee50";
    final Uri urlSendGrid = Uri.parse(
        'https://us-central1-bubo-force.cloudfunctions.net/function-emailing-system/sendGridGM');
    const String token = 'hlACSAbxfhfruyvg9g4ql5463738';

    Map<String, String> headersEmailJS = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    var saludoHere = "BIENVENIDO/A";
    var socioHere = "Estimado/a Socio/a";

    var fechaToday = "01/11/2023";
    var fechaToYear = "01/11/2024";

    // print("GENERO 2 " + genero);

    // if (genero == "M") {
    //   saludoHere = "BIENVENIDO";
    //   socioHere = "Estimado Socio";
    // } else if (genero == "F") {
    //   saludoHere = "BIENVENIDA";
    //   socioHere = "Estimada Socia";
    // }

    Map<String, dynamic> bodySendGrid = {
      "subject": "Afiliación de Fondo Mortuorio",
      "nameUser": nombre,
      "templateID": "d-28c1fc25da7d45deb1b6e77caec2ee50",
      "fromEmail": "tuamigo@grupomancheno.com",
      "toEmail": email,
      "message": "test",
      "welcome_ctrl": saludoHere,
      "client_ctrl": socioHere,
      "client_name": nombre,
      "plan": plan,
      "period_start": fechaToday,
      "period_end": fechaToYear,
      "auth_broker_url": direccionAsistencia,
      "auth_data_url": direccionAutorizacionDatos,
      "auth_debit_url": direccionAutorizacion,
      "cert_url": direccionVida,
    };

    http.Response response;

    try {
      response = await http.post(
        urlSendGrid,
        headers: headersEmailJS,
        body: jsonEncode(bodySendGrid),
      );
      // print('email ${response.body}');
      if (response.statusCode == 202) {
        print(
          'Email enviado correctamente.',
        );
      } else {
        print(
          response.body.toString(),
        );
      }
    } catch (e) {
      print('email error $e');
      print(
        e.toString(),
      );
    }
  }
}
