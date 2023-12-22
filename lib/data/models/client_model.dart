import 'package:flutter/material.dart';
import 'package:sapo_benefica/data/models/user_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/toast_notifications.dart';
import 'package:sapo_benefica/globals/globals.dart' as globals;

class Client {
  final String sdtCiudad;
  final String sdtIngresosMensuales;
  final String sdtPrimerNombre;
  final String sdtResultadodescripcion;
  final String sdtNacionalidad;
  final String sdtOcupacionDes;
  final String sdtTipoIdentificacion;
  final String sdtSegundoNombre;
  final String sdtTelefonoConvencional;
  double sdtValordebito;
  double sdtValordebitado;
  final String sdtPatrimonio;
  final String sdtProvincia;
  final String sdtEmail;
  final String sdtCallePrincipal;
  final String sdtResultadoindicador;
  final String sdtCanton;
  final String sdtFechaNacimientoCh;
  final String sdtGenero;
  final String sdtNumeroCuenta;
  final String sdtPrimerApellido;
  final String sdtNumeroIdentificacion;
  final String sdtTelefonoCelular;
  final String sdtSegundoApellido;
  final String sdtOcupacionCod;
  final String sdtOficina;
  final String sdtEstadoCivil;
  final String sdtNumeroCasa;
  final String sdtReferencia;

  /* final String apellidos;
  final String celular;
  final String convencional;
  final int edad;
  final String email;
  final String fechaNacimientoCh;
  final String id;
  final String identificacion;
  final String nombres;
  bool debitoExiste;
  final String debitoValor; */

  Client({
    this.sdtCiudad = '',
    this.sdtIngresosMensuales = '',
    this.sdtPrimerNombre = '',
    this.sdtResultadodescripcion = '',
    this.sdtNacionalidad = '',
    this.sdtOcupacionDes = '',
    this.sdtTipoIdentificacion = '',
    this.sdtSegundoNombre = '',
    this.sdtTelefonoConvencional = '',
    this.sdtValordebito = 0,
    this.sdtValordebitado = 0,
    this.sdtPatrimonio = '',
    this.sdtProvincia = '',
    this.sdtEmail = '',
    this.sdtCallePrincipal = '',
    this.sdtResultadoindicador = '',
    this.sdtCanton = '',
    this.sdtFechaNacimientoCh = '',
    this.sdtGenero = '',
    this.sdtNumeroCuenta = '',
    this.sdtPrimerApellido = '',
    this.sdtNumeroIdentificacion = '',
    this.sdtTelefonoCelular = '',
    this.sdtSegundoApellido = '',
    this.sdtOcupacionCod = '',
    this.sdtOficina = '',
    this.sdtEstadoCivil = '',
    this.sdtNumeroCasa = '',
    this.sdtReferencia = '',
    /* this.apellidos = '',
    this.celular = '',
    this.convencional = '',
    this.edad = 0,
    this.email = '',
    this.fechaNacimientoCh = '',
    this.id = '',
    this.identificacion = '',
    this.nombres = '',
    this.debitoExiste = false,
    this.debitoValor = '', */
  });

  static Client fromJson(Map<String, dynamic> data) {
    data = data['DATOS_SOCIO'];
    if (data['SDT_NUMERO_IDENTIFICACION'] == null) {
      throw Exception('No se encontraron datos del cliente');
    }
    try {
      data['SDT_VALORDEBITO'] =
          data['SDT_VALORDEBITO'].toString().replaceAll(',', '.');
      data['SDT_VALORDEBITO'] = double.parse(data['SDT_VALORDEBITO']);
    } catch (e) {
      ToastNotifications.showBadNotification(msg: 'Error de formato de débito');
    }
    /* try {
      final List<String> fecha = data['SDT_FECHA_NACIMIENTO_CH']
          .toString()
          .substring(0, 10)
          .split('-');
      data['SDT_FECHA_NACIMIENTO_CH'] = fecha[0] + fecha[1] + fecha[2];
    } catch (e) {
      ToastNotifications.showBadNotification(msg: 'Error de formato de fecha');
    } */
    return Client(
      sdtCiudad: data['SDT_CIUDAD'].toString(),
      sdtIngresosMensuales: data['SDT_INGRESOS_MENSUALES'].toString(),
      sdtPrimerNombre: data['SDT_PRIMER_NOMBRE'].toString(),
      sdtResultadodescripcion: data['SDT_RESULTADODESCRIPCION'].toString(),
      sdtNacionalidad: data['SDT_NACIONALIDAD'].toString(),
      sdtOcupacionDes: data['SDT_OCUPACION_DES'].toString(),
      sdtTipoIdentificacion: data['SDT_TIPO_IDENTIFICACION'].toString(),
      sdtSegundoNombre: data['SDT_SEGUNDO_NOMBRE'].toString(),
      sdtTelefonoConvencional: data['SDT_TELEFONO_CONVENCIONAL'].toString(),
      sdtValordebito: data['SDT_VALORDEBITO'],
      sdtValordebitado: data['SDT_VALORDEBITO'],
      sdtPatrimonio: data['SDT_PATRIMONIO'].toString(),
      sdtProvincia: data['SDT_PROVINCIA'].toString(),
      sdtEmail: data['SDT_EMAIL'].toString(),
      sdtCallePrincipal: data['SDT_CALLE_PRINCIPAL'].toString(),
      sdtResultadoindicador: data['SDT_RESULTADOINDICADOR'].toString(),
      sdtCanton: data['SDT_CANTON'].toString(),
      sdtFechaNacimientoCh: data['SDT_FECHA_NACIMIENTO_CH'].toString(),
      sdtGenero: data['SDT_GENERO'].toString(),
      sdtNumeroCuenta: data['SDT_NUMERO_CUENTA'].toString(),
      sdtPrimerApellido: data['SDT_PRIMER_APELLIDO'].toString(),
      sdtNumeroIdentificacion: data['SDT_NUMERO_IDENTIFICACION'].toString(),
      sdtTelefonoCelular: data['SDT_TELEFONO_CELULAR'].toString(),
      sdtSegundoApellido: data['SDT_SEGUNDO_APELLIDO'].toString(),
      sdtOcupacionCod: data['SDT_OCUPACION_COD'].toString(),
      sdtOficina: data['SDT_OFICINA'].toString(),
      sdtEstadoCivil: data['SDT_ESTADO_CIVIL'].toString(),
      sdtNumeroCasa: data['SDT_NUMERO_CASA'].toString(),
      sdtReferencia: data['SDT_REFERENCIA'].toString(),
    );
  }

  static Map<String, String> clientInBenefica(String numCed) {
    return {
      'operationName': 'queryBaseMadreBeneficasByIdIdentificacionIndex',
      'authMode': 'AMAZON_COGNITO_USER_POOLS',
      'query': '''query queryBaseMadreBeneficasByIdIdentificacionIndex {
        queryBaseMadreBeneficasByIdIdentificacionIndex(identificacion: "$numCed") {
          items {
            apellidos
            celular
            convencional
            edad
            email
            fechaNacimiento
            id
            identificacion
            nombres
            debitoExiste
            }
          }
        }''',
    };
  }

  static Map<String, String> clientInMufasa(String numCed) {
    /* return {
      'operationName': 'queryAfiliacionesByIdSociocedulaIndex',
      'authMode': 'AMAZON_COGNITO_USER_POOLS',
      'query': '''query queryAfiliacionesByIdSociocedulaIndex {
        queryAfiliacionesByIdSociocedulaIndex(socioCedula: "$numCed") {
          items {
            aseguradora
            canal
            cooperativa
            ejecutivo
            ejecutivoNombre
            ejecutivoPuntos
            fechaGestion
            id
            observacionGestion
            poliza
            resultadoGestion
            producto
            socioAgencia
            socioBeneficiarios
            socioCedula
            socioCelularAnterior
            socioCelularNuevo
            socioCuenta
            socioDebitoAdicional
            socioDebitoInicial
            socioDocumentosGenerados
            socioEdad
            socioEmailAnterior
            socioEmailNuevo
            socioEnfermedades
            socioEstadoInicial
            socioFechaNacimiento
            socioMAIL
            socioOpcion
            socioNombreCompleto
            socioPin
            socioPlanFinal
            socioPlanInicial
            socioSMS
            socioMAIL
            socioDiptico
            socioTipoBeneficiarios
            ejecutivoPuntos
            fechaGestion
            resultadoGestion
            observacionGestion
            socioFotografia
            socioTipo
            }
          }
        }''',
    }; */
    return {
      'operationName': 'queryAfiliacionesByIdSociocedulaIndex',
      'authMode': 'AMAZON_COGNITO_USER_POOLS',
      'query': '''query queryAfiliacionesByIdSociocedulaIndex {
        queryAfiliacionesByIdSociocedulaIndex(socioCedula: "$numCed") {
          items {
            aseguradora
            canal
            cooperativa
            ejecutivo
            ejecutivoNombre
            ejecutivoPuntos
            fechaGestion
            id
            observacionGestion
            poliza
            resultadoGestion
            producto
            socioAgencia
            socioBeneficiarios
            socioCedula
            socioCelularAnterior
            socioCelularNuevo
            socioCuenta
            socioDebitoAdicional
            socioDebitoInicial
            socioDocumentosGenerados
            socioEdad
            socioEmailAnterior
            socioEmailNuevo
            socioEnfermedades
            socioEstadoInicial
            socioFechaNacimiento
            socioMAIL
            socioOpcion
            socioNombreCompleto
            socioPin
            socioPlanFinal
            socioPlanInicial
            socioSMS
            socioMAIL
            socioDiptico
            socioTipoBeneficiarios
            ejecutivoPuntos
            fechaGestion
            resultadoGestion
            observacionGestion
            socioTipo
            }
          }
        }''',
    };
  }

  static Map<String, dynamic> afiliaciones(
      Map<String, dynamic> data, String operation) {
    if (operation == 'create') {
      return {
        "operationName": "createAfiliaciones",
        "query": '''mutation createAfiliaciones {
        createAfiliaciones(input: {
          canal: "${data['canal']}",
          aseguradora: "${data['aseguradora']}",
          poliza: "${data['poliza']}",
          producto: "${data['producto']}",
          cooperativa: "${data['cooperativa']}",
          ejecutivo: "${data['ejecutivo']}",
          ejecutivoNombre: "${data['ejecutivoNombre']}",
          socioCedula: "${data['socioCedula']}",
          socioCuenta: "${data['socioCuenta']}",
          socioNombreCompleto: "${data['socioNombreCompleto']}",
          socioFechaNacimiento: "${data['socioFechaNacimiento']}",
          socioEdad: "${data['socioEdad']}",
          socioEmailAnterior: "${data['socioEmailAnterior']}",
          socioEmailNuevo: "${data['socioEmailNuevo']}",
          socioCelularAnterior: "${data['socioCelularAnterior']}",
          socioCelularNuevo: "${data['socioCelularNuevo']}",
          socioAgencia: "${data['socioAgencia']}",
          socioEstadoInicial: "${data['socioEstadoInicial']}",
          socioPlanInicial: "${data['socioPlanInicial']}",
          socioDebitoInicial: "${data['socioDebitoInicial']}",
          socioEnfermedades: "${data['socioEnfermedades']}",
          socioBeneficiarios: "${data['socioBeneficiarios']}",
          socioOpcion: "${data['socioOpcion']}",
          socioPlanFinal: "${data['socioPlanFinal']}",
          socioDebitoAdicional: "${data['socioDebitoAdicional']}",
          socioPin: "${data['socioPin']}",
          socioDocumentosGenerados: "${data['socioDocumentosGenerados']}",
          socioSMS: "${data['socioSMS']}",
          socioMAIL: "${data['socioMAIL']}",
          socioDiptico: "${data['socioDiptico']}",
          socioTipoBeneficiarios: "${data['socioTipoBeneficiarios']}",
          ejecutivoPuntos: "${data['ejecutivoPuntos']}",
          fechaGestion: "${data['fechaGestion']}",
          resultadoGestion: "${data['resultadoGestion']}",
          observacionGestion: "${data['observacionGestion']}",
          socioFotografia: "${data['socioFotografia']}",
          socioTipo: "${data['socioTipo']}"
        }) {
            id
          }
      }''',
      };
    } else if (operation == 'update') {
      return {
        "operationName": "updateAfiliaciones",
        "query": '''mutation updateAfiliaciones {
        updateAfiliaciones(input: {
          id: "${data['id']}",
          canal: "${data['canal']}",
          aseguradora: "${data['aseguradora']}",
          poliza: "${data['poliza']}",
          producto: "${data['producto']}",
          cooperativa: "${data['cooperativa']}",
          ejecutivo: "${data['ejecutivo']}",
          ejecutivoNombre: "${data['ejecutivoNombre']}",
          socioCedula: "${data['socioCedula']}",
          socioCuenta: "${data['socioCuenta']}",
          socioNombreCompleto: "${data['socioNombreCompleto']}",
          socioFechaNacimiento: "${data['socioFechaNacimiento']}",
          socioEdad: "${data['socioEdad']}",
          socioEmailAnterior: "${data['socioEmailAnterior']}",
          socioEmailNuevo: "${data['socioEmailNuevo']}",
          socioCelularAnterior: "${data['socioCelularAnterior']}",
          socioCelularNuevo: "${data['socioCelularNuevo']}",
          socioAgencia: "${data['socioAgencia']}",
          socioEstadoInicial: "${data['socioEstadoInicial']}",
          socioPlanInicial: "${data['socioPlanInicial']}",
          socioDebitoInicial: "${data['socioDebitoInicial']}",
          socioEnfermedades: "${data['socioEnfermedades']}",
          socioBeneficiarios: "${data['socioBeneficiarios']}",
          socioOpcion: "${data['socioOpcion']}",
          socioPlanFinal: "${data['socioPlanFinal']}",
          socioDebitoAdicional: "${data['socioDebitoAdicional']}",
          socioPin: "${data['socioPin']}",
          socioDocumentosGenerados: "${data['socioDocumentosGenerados']}",
          socioSMS: "${data['socioSMS']}",
          socioMAIL: "${data['socioMAIL']}",
          socioDiptico: "${data['socioDiptico']}",
          socioTipoBeneficiarios: "${data['socioTipoBeneficiarios']}",
          ejecutivoPuntos: "${data['ejecutivoPuntos']}",
          fechaGestion: "${data['fechaGestion']}",
          resultadoGestion: "${data['resultadoGestion']}",
          observacionGestion: "${data['observacionGestion']}",
          socioFotografia: "${data['socioFotografia']}",
          socioTipo: "${data['socioTipo']}"
        }) {
            id
          }
      }''',
      };
    } else {
      return {};
    }
  }


  static Map<String, dynamic> clientAsesoria(
      Map<String, dynamic> data, User user) {
    initializeDateFormatting('es_ES', null);
    final String fechaDeHoy = DateFormat('dd-MM-yyyy HH:mm', 'es_ES')
        .format(DateTime.now())
        .toString();
    return {
      "operationName": "createAfiliaciones",
      "query": '''mutation createAfiliaciones {
        createAfiliaciones(input: {
          canal:"SAPO",
          aseguradora: "Seguros del Pichincha",
          poliza: "",
          producto: "Seguro de Vida",
          cooperativa: "Benefica",
          ejecutivo: "${user.email}",
          ejecutivoNombre: "${user.name}",
          socioCedula: "${data['cedula']}",
          socioCuenta: "${data['cuenta']}",
          socioNombreCompleto: "${data['nombre']}",
          socioFechaNacimiento: "${data['fechaNacimiento']}",
          socioEdad: "${data['edad']}",
          socioEmailAnterior: "${data['emailAnterior']}",
          socioEmailNuevo: "",
          socioCelularAnterior: "${data['celular']}",
          socioCelularNuevo: "",
          socioAgencia: "${data['agencia']}",
          socioEstadoInicial: "${data['estado']}",
          socioPlanInicial: "${data['plan']}",
          socioDebitoInicial: "${data['debito']}",
          socioEnfermedades: "",
          socioBeneficiarios: "",
          socioOpcion: "${data['opcion']}",
          socioPlanFinal: "",
          socioDebitoAdicional: "0.00",
          socioPin: "",
          socioDocumentosGenerados: "",
          socioSMS: "No",
          socioMAIL: "No",
          ejecutivoPuntos: "0",
          fechaGestion: "$fechaDeHoy",
          resultadoGestion: "Asesoría"}) {
            id
          }
      }''',
    };
  }


  static Map<String, dynamic> updateAnulmentClient(
      Map<String, dynamic> data, User user) {
    initializeDateFormatting('es_ES', null);
    final String fechaDeHoy = DateFormat('dd-MM-yyyy HH:mm', 'es_ES')
        .format(DateTime.now())
        .toString();
    return {
      "operationName": "updateAfiliaciones",
      "query": '''mutation updateAfiliaciones {
        updateAfiliaciones(input: {
          id: "${data['identificacion']}",
        ejecutivo: "${user.email}",
        ejecutivoNombre: "${user.name}",
        socioEstadoInicial: "${data['estadoInicial']}",
        socioPlanInicial: "${data['planInicial']}",
        socioDebitoInicial: "${data['debitoInicial']}",
        socioEnfermedades: "",
        socioBeneficiarios: "",
        socioOpcion: "${data['opcion']}",
        socioPlanFinal: "${data['planFinal']}",
        socioDebitoAdicional: "0.00",
        socioPin: "${data['pin']}",
        socioSMS: "Si",
        socioMAIL: "No",
        ejecutivoPuntos: "${data['puntosAsignar']}",
        fechaGestion: "$fechaDeHoy",
        resultadoGestion: "Gestión Exitosa",
                motivoAnulacion: "${data['motivoAnulacion']}"
                }) {
          id
        }
      }''',
    };
  }

  static Map<String, dynamic> createAnulmentClient(
      Map<String, dynamic> data, User user) {
    initializeDateFormatting('es_ES', null);
    final String fechaDeHoy = DateFormat('dd-MM-yyyy HH:mm', 'es_ES')
        .format(DateTime.now())
        .toString();
    debugPrint('Creating API Structure for ApiCreateAnulmentClient...');

    return {
      "operationName": "createAfiliaciones",
      "query": '''mutation createAfiliaciones {
      createAfiliaciones(input: {
        canal: "SAPO",
        aseguradora: "Seguros del Pichincha",
        poliza: "",
        producto: "Seguro de Vida",
        cooperativa: "Benefica",
        ejecutivo: "${user.email}",
        ejecutivoNombre: "${user.name}",
        socioCedula: "${data['cedula']}",
        socioCuenta: "${data['cuenta']}",
        socioNombreCompleto: "${data['nombre']}",
        socioFechaNacimiento: "${data['fechaNacimiento']}",
        socioEdad: "${data['edad']}",
        socioEmailAnterior: "${data['emailAnterior']}",
        socioEmailNuevo: "${data['emailNuevo']}",
        socioCelularAnterior: "${data['celularAnterior']}",
        socioCelularNuevo: "${data['celularNuevo']}",
        socioAgencia: "${data['agencia']}",
        socioEstadoInicial: "${data['estadoInicial']}",
        socioPlanInicial: "${data['planInicial']}",
        socioDebitoInicial: "${data['debitoInicial']}",
        socioEnfermedades: "",
        socioBeneficiarios: "",
        socioOpcion: "${data['opcion']}",
        socioPlanFinal: "${data['planFinal']}",
        socioDebitoAdicional: "0.00",
        socioPin: "${data['pin']}",
        socioDocumentosGenerados: "",
        socioSMS: "Si",
        socioMAIL: "No",
        ejecutivoPuntos: "1",
        fechaGestion: "$fechaDeHoy",
        resultadoGestion: "Gestión Exitosa",
        motivoAnulacion: "${data['motivoAnulacion']}"
        }) {
          id
        }
      }
      ''',
    };
  }

static Map<String, dynamic> createClient(
      Map<String, dynamic> data, User user) {
    initializeDateFormatting('es_ES', null);
    final String fechaDeHoy = DateFormat('dd-MM-yyyy HH:mm', 'es_ES')
        .format(DateTime.now())
        .toString();
    return {
      "operationName": "createAfiliaciones",
      "query": '''mutation createAfiliaciones {
      createAfiliaciones(input: {
        canal:"SAPO",
        aseguradora: "Seguros del Pichincha",
        poliza: "",
        producto: "Seguro de Vida",
        cooperativa: "Benefica",
        ejecutivo: "${user.email}",
        ejecutivoNombre: "${user.name}",
        socioCedula: "${data['cedula']}",
        socioCuenta: "${data['cuenta']}",
        socioNombreCompleto: "${data['nombre']}",
        socioFechaNacimiento: "${data['fechaNacimiento']}",
        socioEdad: "${data['edad']}",
        socioEmailAnterior: "${data['emailAnterior']}",
        socioEmailNuevo: "${data['emailNuevo']}",
        socioCelularAnterior: "${data['celularAnterior']}",
        socioCelularNuevo: "${data['celularNuevo']}",
        socioAgencia: "${data['agencia']}",
        socioEstadoInicial: "${data['estadoInicial']}",
        socioPlanInicial: "${data['planInicial']}",
        socioDebitoInicial: "${data['debitoInicial']}",
        socioEnfermedades: "${data['enfermedades']}",
        socioBeneficiarios: "",
        socioOpcion: "${data['opcion']}",
        socioPlanFinal: "${data['planFinal']}",
        socioDebitoAdicional: "${data['debitoAdicional']}",
        socioPin: "${data['pin']}",
        socioDocumentosGenerados: "",
        socioSMS: "Si",
        socioMAIL: "No",
        ejecutivoPuntos: "${data['puntosAsignar']}",
        fechaGestion: "$fechaDeHoy",
        resultadoGestion: "Gestión Exitosa",
        socioDiptico: "${data['numeroDiptico']}",
        resultadoGestion: "Gestión Exitosa",

        }) {
          id
        }
      }''',
    };
  }

  static Map<String, dynamic> updateClient(
      Map<String, dynamic> data, User user) {
    initializeDateFormatting('es_ES', null);
    final String fechaDeHoy = DateFormat('dd-MM-yyyy HH:mm', 'es_ES')
        .format(DateTime.now())
        .toString();
    return {
      "operationName": "updateAfiliaciones",
      "query": '''mutation updateAfiliaciones {
      updateAfiliaciones(input: {
        id: "${data['identificacion']}",
        canal:"SAPO",
        aseguradora: "Seguros del Pichincha",
        poliza: "",
        producto: "Seguro de Vida",
        cooperativa: "Benefica",
        ejecutivo: "${user.email}",
        ejecutivoNombre: "${user.name}",
        socioCedula: "${data['cedula']}",
        socioCuenta: "${data['cuenta']}",
        socioNombreCompleto: "${data['nombre']}",
        socioFechaNacimiento: "${data['fechaNacimiento']}",
        socioEdad: "${data['edad']}",
        socioEmailAnterior: "${data['emailAnterior']}",
        socioEmailNuevo: "${data['emailNuevo']}",
        socioCelularAnterior: "${data['celularAnterior']}",
        socioCelularNuevo: "${data['celularNuevo']}",
        socioAgencia: "${data['agencia']}",
        socioEstadoInicial: "${data['estadoInicial']}",
        socioPlanInicial: "${data['planInicial']}",
        socioDebitoInicial: "${data['debitoInicial']}",
        socioEnfermedades: "${data['enfermedades']}",
        socioBeneficiarios: "",
        socioOpcion: "${data['opcion']}",
        socioPlanFinal: "${data['planFinal']}",
        socioDebitoAdicional: "${data['debitoAdicional']}",
        socioPin: "${data['pin']}",
        socioDocumentosGenerados: "",
        socioSMS: "Si",
        socioMAIL: "No",
        ejecutivoPuntos: "${data['puntosAsignar']}",
        fechaGestion: "$fechaDeHoy",
        resultadoGestion: "Gestión Exitosa",
        socioDiptico: "${data['numeroDiptico']}"
        }) {
          id
        }
      }''',
    };
  }

  static Map<String, dynamic> createDebitClient(
      Map<String, dynamic> data, User user) {
    initializeDateFormatting('es_ES', null);
    final String fechaDeHoy = DateFormat('dd-MM-yyyy HH:mm', 'es_ES')
        .format(DateTime.now())
        .toString();
    return {
      "operationName": "createAfiliaciones",
      "query": '''mutation createAfiliaciones {
        createAfiliaciones(input: {
          canal:"SAPO",
          aseguradora: "Seguros del Pichincha",
          poliza: "",
          producto: "Seguro de Vida",
          cooperativa: "Benefica",
          ejecutivo: "${user.email}",
          ejecutivoNombre: "${user.name}",
          socioCedula: "${data['cedula']}",
          socioCuenta: "${data['cuenta']}",
          socioNombreCompleto: "${data['nombre']}",
          socioFechaNacimiento: "${data['fechaNacimiento']}",
          socioEdad: "${data['edad']}",
          socioEmailAnterior: "${data['emailAnterior']}",
          socioEmailNuevo: "${data['emailNuevo']}",
          socioCelularAnterior: "${data['celularAnterior']}",
          socioCelularNuevo: "${data['celularNuevo']}",
          socioAgencia: "${data['agencia']}",
          socioEstadoInicial: "${data['estadoInicial']}",
          socioPlanInicial: "${data['planInicial']}",
          socioDebitoInicial: "${data['debitoInicial']}",
          socioEnfermedades: "${data['enfermedades']}",
          socioBeneficiarios: "",
          socioOpcion: "${data['opcion']}",
          socioPlanFinal: "${data['planFinal']}",
          socioDebitoAdicional: "${data['debitoAdicional']}",
          socioPin: "${data['pin']}",
          socioDocumentosGenerados: "",
          socioSMS: "Si",
          socioMAIL: "No",
          ejecutivoPuntos: "${data['puntosAsignar']}",
          fechaGestion: "$fechaDeHoy",
          resultadoGestion: "Sin débito",
          observacionGestion:"${data['observacionDebito']}",
          }) {
            id
          }
        }''',
    };
  }

  static Map<String, dynamic> updateDebitClient(
      Map<String, dynamic> data, User user) {
    initializeDateFormatting('es_ES', null);
    final String fechaDeHoy = DateFormat('dd-MM-yyyy HH:mm', 'es_ES')
        .format(DateTime.now())
        .toString();
    return {
      "operationName": "updateAfiliaciones",
      "query": '''mutation updateAfiliaciones {
        updateAfiliaciones(input: {
          id: "${data['id']}",
          canal:"SAPO",
          aseguradora: "Seguros del Pichincha",
          poliza: "",
          producto: "Seguro de Vida",
          cooperativa: "Benefica",
          ejecutivo: "${user.email}",
          ejecutivoNombre: "${user.name}",
          socioCedula: "${data['cedula']}",
          socioCuenta: "${data['cuenta']}",
          socioNombreCompleto: "${data['nombre']}",
          socioFechaNacimiento: "${data['fechaNacimiento']}",
          socioEdad: "${data['edad']}",
          socioEmailAnterior: "${data['emailAnterior']}",
          socioEmailNuevo: "${data['emailNuevo']}",
          socioCelularAnterior: "${data['celularAnterior']}",
          socioCelularNuevo: "${data['celularNuevo']}",
          socioAgencia: "${data['agencia']}",
          socioEstadoInicial: "${data['estadoInicial']}",
          socioPlanInicial: "${data['planInicial']}",
          socioDebitoInicial: "${data['debitoInicial']}",
          socioEnfermedades: "${data['enfermedades']}",
          socioBeneficiarios: "",
          socioOpcion: "${data['opcion']}",
          socioPlanFinal: "${data['planFinal']}",
          socioDebitoAdicional: "${data['debitoAdicional']}",
          socioPin: "${data['pin']}",
          socioDocumentosGenerados: "",
          socioSMS: "Si",
          socioMAIL: "No",
          ejecutivoPuntos: "${data['puntosAsignar']}",
          fechaGestion: "$fechaDeHoy",
          resultadoGestion: "Sin débito",
          observacionGestion:"${data['observacionDebito']}",
          }) {
            id
          }
        }''',
    };
  }

// create a json map return for the class Client

  Map toJson() => {
        'sdtCiudad': sdtCiudad,
        'sdtIngresosMensuales': sdtIngresosMensuales,
        'sdtPrimerNombre': sdtPrimerNombre,
        'sdtResultadodescripcion': sdtResultadodescripcion,
        'sdtNacionalidad': sdtNacionalidad,
        'sdtOcupacionDes': sdtOcupacionDes,
        'sdtTipoIdentificacion': sdtTipoIdentificacion,
        'sdtSegundoNombre': sdtSegundoNombre,
        'sdtTelefonoConvencional': sdtTelefonoConvencional,
        'sdtValordebito': sdtValordebito,
        'sdtValordebitado': sdtValordebitado,
        'sdtPatrimonio': sdtPatrimonio,
        'sdtProvincia': sdtProvincia,
        'sdtEmail': sdtEmail,
        'sdtCallePrincipal': sdtCallePrincipal,
        'sdtResultadoindicador': sdtResultadoindicador,
        'sdtCanton': sdtCanton,
        'sdtFechaNacimientoCh': sdtFechaNacimientoCh,
        'sdtGenero': sdtGenero,
        'sdtNumeroCuenta': sdtNumeroCuenta,
        'sdtPrimerApellido': sdtPrimerApellido,
        'sdtNumeroIdentificacion': sdtNumeroIdentificacion,
        'sdtTelefonoCelular': sdtTelefonoCelular,
        'sdtSegundoApellido': sdtSegundoApellido,
        'sdtOcupacionCod': sdtOcupacionCod,
        'sdtOficina': sdtOficina,
        'sdtEstadoCivil': sdtEstadoCivil,
        'sdtNumeroCasa': sdtNumeroCasa,
        'sdtReferencia': sdtReferencia
      };
}
