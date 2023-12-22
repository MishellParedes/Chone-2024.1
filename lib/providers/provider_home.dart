import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sapo_benefica/data/aws/aws_secrets.dart';
import 'package:sapo_benefica/data/aws/notification_controller.dart';
import 'package:sapo_benefica/data/aws/user_service.dart';
import 'package:sapo_benefica/data/models/user_model.dart';
import 'package:sapo_benefica/data/repository/repository_aws.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sapo_benefica/data/models/client_model.dart';
import 'package:sapo_benefica/data/models/plans_model.dart';
import 'package:sapo_benefica/providers/provider_auth.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/dialog_asegurability.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/dialog_dependents.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/dialog_payment.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/toast_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sapo_benefica/globals/globals.dart' as globals;

class ProviderHome with ChangeNotifier {
  final ProviderAuth providerAuth = ProviderAuth();

  void init() async {
    await getTablePlans();
  }

  /// Bandera para controlar si se han guardado los dependientes
  bool _dependentsSaved = false;
  bool get dependentsSaved => _dependentsSaved;
  set dependentsSaved(bool value) {
    _dependentsSaved = value;
    notifyListeners();
  }

  var reasonToAnulment = "El socio no autorizó el débito";

  List _dependentsName = [TextEditingController()];
  List get dependentsName => _dependentsName;
  set dependentsName(List value) {
    _dependentsName = value;
    notifyListeners();
  }

  List _dependentsRelation = ['HIJO/A'];
  List get dependentsRelation => _dependentsRelation;
  set dependentsRelation(List value) {
    _dependentsRelation = value;
    notifyListeners();
  }

  List _dependentsAge = ['100 %'];
  List get dependentsAge => _dependentsAge;
  set dependentsAge(List list) {
    _dependentsAge = list;
    notifyListeners();
  }

  /// Bandera que controla la visibilidad de la interfaz que contiene la información de la cédula ingresada
  bool _cedLength10 = false;
  bool get cedLength10 => _cedLength10;
  void changeCedLength10(bool cedLength10) {
    _cedLength10 = cedLength10;
    notifyListeners();
  }

  /// Valor de la pantalla que debe de mostrarse en la interfaz
  int _screen = 1;
  int get screen => _screen;
  void changeScreen(int screen) {
    _screen = screen;
    notifyListeners();
  }

  /// Bandera para controlar si se ha seleccionado el envío de pin
  bool _pinSended = false;
  bool get pinSended => _pinSended;
  void changePinSended(bool pinSended) {
    _pinSended = pinSended;
    notifyListeners();
  }

  /// Bandera controla si se anulará el plan con el otro número de teléfono
  bool _anulPlan = false;
  bool get anulPlan => _anulPlan;
  set anulPlan(bool value) {
    _anulPlan = value;
    notifyListeners();
  }

  /// Bandera para controlar si el pin es válido
  bool _pinValidating = false;
  bool get pinValidating => _pinValidating;
  void changePinValidating(bool pinValidating) {
    _pinValidating = pinValidating;
    notifyListeners();
  }

  /// Tiempo para la validación del pin
  Duration _myDuration = const Duration(minutes: 10);
  Duration get myDuration => _myDuration;
  void changeMyDuration(Duration myDuration) {
    _myDuration = myDuration;
    notifyListeners();
  }

  /// Bandera que controla la carga de las apis
  int _isFetching = 0;
  int get isFetching => _isFetching;
  set isFetching(int value) {
    _isFetching = value;
    notifyListeners();
  }

  /// Bandera que controla el botón para obtener el díptico
  bool _isDipticoSelect = false;
  bool get isDipticoSelect => _isDipticoSelect;
  set isDipticoSelect(bool value) {
    _isDipticoSelect = value;
    notifyListeners();
  }

  /// Bandera que si tiene otro número de teléfono
  bool _haveAnotherPhone = false;
  bool get haveAnotherPhone => _haveAnotherPhone;
  void changeHaveAnotherPhone(bool haveAnotherPhone) {
    _haveAnotherPhone = haveAnotherPhone;
    notifyListeners();
  }

  TextEditingController _pinController = TextEditingController();
  get pinController => _pinController;
  set pinController(value) => _pinController = value;

  /// Formulario para ingresar el número de cédula
  final formSearchNumCed = FormGroup({
    'num_ced': FormControl<String>(value: ''),
  });
  String get numCed => formSearchNumCed.control('num_ced').value;

  /// Formulario para ingresar nuevos datos del cliente
  final formGroupSecondStep = FormGroup({
    'nuevo_celular': FormControl<String>(value: ''),
    'nuevo_correo': FormControl<String>(value: ''),
  });
  String get nuevoCelular => formGroupSecondStep.control('nuevo_celular').value;
  String get nuevoCorreo => formGroupSecondStep.control('nuevo_correo').value;
  String get numeroDiptico =>
      formGroupSecondStep.control('numero_diptico').value;

  /// Estructura del formulario para la terjeta de asegurabilidad
  final formAsegurability = FormGroup({
    'haveDisease': FormControl<bool>(value: false),
    'diseaseName': FormControl<String>(value: ''),
  });
  bool get haveDisease => formAsegurability.control('haveDisease').value;
  String get diseaseName => formAsegurability.control('diseaseName').value;
  set diseaseName(String value) =>
      formAsegurability.control('diseaseName').value = value;

  final formPayment = FormGroup({
    'paymentYearly': FormControl<bool>(value: false),
  });

  bool get paymentMethod => formPayment.control('paymentYearly').value;

  /// Mapa de variables calculables del sistema
  Map<String, dynamic> systemVariables = {
    'client': Client,
    'selectedPlan': 0,
    'puntosAsignar': 0,
    'plansToShow': [],
    'countdownTimer': Timer,
    'pinValidado': 0,
    'socioFechaNacimiento': DateTime,
    'valueToDebit': 0.0,
    'fechaInicioVigencia': '',
    'tipoTransaccion': '',
    'edadClient': 0.0,
    'clientInDB': '',
    'estadoAnteriorInDB': '',
    'clientNewPhone': '',
    'clientNewEmail': '',
    'screen': 'Inicio',
    'errorDebito': '',
    'puntosAcumulados': 0,
    'idEjecutivo': '',
    'nombreEjecutivo': '',
    'enfermedades': '',
    'enfermedadGuardada': false,
    'mufasa': Map<String, dynamic>,
    'formaPago': "Mensual"
  };

  /// Mapa de banderas del sistema
  Map<String, bool> systemFlags = {
    'clientExistsInDB': false,
    'clientPlanMajor': false,
    'clientAdvisory': false,
    'clientCanceled': false,
  };

  /// Mapa de las expresiones regulares del sistema
  Map<String, RegExp> systemRegex = {
    'email': RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'),
    'age': RegExp(
      r'^'
      r'(?<day>[0-9]{1,2})'
      r'/'
      r'(?<month>[0-9]{1,2})'
      r'/'
      r'(?<year>[0-9]{4,})'
      r'$',
    ),
  };

  /// Método para iniciar el conteo regresivo del pin
  void startTimer() {
    changeMyDuration(const Duration(minutes: 10));
    systemVariables['countdownTimer'] =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  /// Método para detener el conteo regresivo del pin
  void stopTimer() {
    if (pinSended) {
      try {
        changePinSended(false);
        systemVariables['countdownTimer']!.cancel();
      } catch (e) {
        null;
      }
    }
  }

  /// Método para reducir el tiempo de la cuenta regresiva
  void setCountDown() {
    const reduceSecondsBy = 1;
    final seconds = myDuration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      stopTimer();
    } else {
      changeMyDuration(Duration(seconds: seconds));
    }
  }

  /// Método para validar la cédula ingresada
  Future<void> validateNumCed() async {
    changeScreen(-1);
    systemVariables['selectedPlan'] = -1;
    if (numCed.length != 10) {
      restarSapo();
      return;
    }
    changeCedLength10(true);
    final dynamic responseClient = await AWSRepository.queryPersona(numCed);
    if (responseClient == 'Error') {
      changeCedLength10(false);
      return;
    }
    systemVariables['client'] = responseClient;
    final dynamic responseMufasa =
        await AWSRepository.queryClientInMufasa(numCed);
    if (responseMufasa == 'Error') {
      changeCedLength10(false);
      return;
    }
    systemVariables['debito'] = systemVariables['client'].sdtValordebitado;
    if (responseMufasa != "No Existe") {
      systemVariables['planFinalMufasa'] = responseMufasa['socioPlanFinal'];
    }
    setSystemFlags(responseMufasa);
  }

  /// Método enviar el flujo hacia la selección de un plan
  Future<void> planSelected(plan, BuildContext context) async {
    systemVariables['enfermedades'] = '';
    if ([4, 5].contains(plan)) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const DialogAsegurability(),
      );
      if (systemVariables['enfermedadGuardada'] == false) {
        return;
      }
    }
    systemVariables['screen'] = 'Plan Seleccionado';
    dependentsSaved = false;
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const DialogDependents(),
    );
    if (!dependentsSaved) {
      return;
    }

    changeScreen(-1);
    systemVariables['selectedPlan'] = plan;
    systemVariables['screen'] = 'Plan Seleccionado';
    calculateValueToDebit(plan);
    systemVariables['puntosAsignar'] = await getPoints();
    changeHaveAnotherPhone(false);
    changeScreen(2);
  }

  /// Métodop para enviar el flujo a la anulación de un plan
  Future<void> cancelPlan() async {
    changeScreen(-1);
    systemVariables['screen'] = 'Anulación';
    systemVariables['selectedPlan'] = getPlanIndex();
    systemVariables['tipoTransaccion'] = 'Anulación';
    systemVariables['valueToDebit'] = 0.0;
    systemVariables['puntosAsignar'] = await getPoints();
    systemVariables['valueToCredit'] =
        (Plan.plans[getPlanIndex()]['values'][DateTime.now().month - 1]);
    changeScreen(2);
  }

  /// Método para establecer las banderas del sistema
  void setSystemFlags(dynamic mufasa) {
    systemVariables['edadClient'] = calculateAge();
    systemVariables['clientInDB'] = '';
    systemVariables['estadoAnteriorInDB'] = '';
    systemFlags['clientExistsInDB'] = false;
    systemFlags['clientPlanMajor'] = false;
    systemFlags['clientAdvisory'] = false;
    systemFlags['clientCanceled'] = false;
    if (mufasa == "No Existe") {
      debugPrint('Cliente no registrado en la base de datos');
    } else {
      debugPrint('Cliente encontrado: ${mufasa['id']}');
      systemVariables['clientNewPhone'] = mufasa['socioCelularNuevo'];
      systemVariables['mufasa'] = mufasa;
      systemFlags['clientExistsInDB'] = true;
      systemVariables['clientInDB'] = mufasa['id'];
      systemVariables['estadoAnteriorInDB'] = mufasa['socioEstadoInicial'];
      if (mufasa['resultadoGestion'] == 'Gestión Exitosa') {
        if (mufasa['socioOpcion'] == 'Anulación') {
          debugPrint('Cliente con anulación');
          systemVariables['client'].sdtValordebitado = 0.00;
          systemFlags['clientCanceled'] = true;
          mufasa['socioPlanFinal'] = 'Sin plan';
        } else {
          /* systemVariables['client'].sdtValordebitado =
              mufasa['socioPlanFinal'] != ''
                  ? getPlanValue(mufasa['socioPlanFinal'])
                  : Plan.plans[getPlanIndex()]['values']
                      [DateTime.now().month - 1]; */
          if (mufasa['socioPlanFinal'] == 'Opción 5') {
            debugPrint('Cliente con el mejor plan disponible');
            systemFlags['clientPlanMajor'] = true;
          }
        }
      } else {
        debugPrint('Cliente en asesoría');
        systemFlags['clientExistsInDB'] = false;
        systemFlags['clientAdvisory'] = true;
      }
    }
    calculatePlansToShow();
    if (systemVariables['plansToShow'].isEmpty) {
      debugPrint('Cliente con el mejor plan disponible');
      systemFlags['clientPlanMajor'] = true;
    }
    changeScreen(1);
  }

  /// Método para calcular los planes a mostrar
  void calculatePlansToShow() {
    systemVariables['plansToShow'] = [];
    final double debito = systemFlags['clientCanceled'] == false
        ? Plan.plans[getPlanIndex()]['value']
        : 0;
    for (var i = 0; i <= 1; i++) {
      if (validatePlanRules(Plan.plans[i]['rules'])) {
        if (systemFlags['clientExistsInDB'] == true) {
          if (systemFlags['clientCanceled'] == true) {
            systemVariables['plansToShow'] = [0, 1];
          } else {
            if (systemVariables['planFinalMufasa'].contains("Opción 1")) {
              systemVariables['plansToShow'] = [1];
            } else if (systemVariables['planFinalMufasa']
                .contains("Opción 2")) {
              systemVariables['plansToShow'] = [1];
            } else if (systemVariables['planFinalMufasa']
                .contains("Opción 3")) {
              systemVariables['plansToShow'] = [0];
            }
          }
        } else if (systemFlags['clientExistsInDB'] == false) {
          if (systemVariables['client'].sdtValordebitado == 0) {
            systemVariables['plansToShow'] = [0, 1];
          } else {
            systemVariables['plansToShow'] = [0, 1];
          }
        }
      }
    }
    if (systemFlags['clientExistsInDB'] == true &&
        systemVariables['client'].sdtValordebitado != 0 &&
        systemFlags['clientCanceled'] == false) {
      systemVariables['plansToShow'].remove(getPlanIndex());
    }
  }

  /// Método para calcular el valor a debitar
  void calculateValueToDebit(int plan) {
    initializeDateFormatting('es_ES', null).then((_) => null);
    print("CALC VALUE TO DEBIT");
    print("VALORES " +
        systemVariables['valueToDebit'].toString() +
        " " +
        (systemVariables['client'].sdtValordebitado + 0.00).toString());

    if (systemVariables['client'].sdtValordebitado == 0) {
      systemVariables['tipoTransaccion'] = 'Plan Nuevo';
      systemVariables['valueToDebit'] = Plan.plans[plan]['values']
              [DateTime.now().month - 1]
          .toStringAsFixed(2);
      if (systemVariables['formaPago'] == "Anual") {
        var valorMensual = systemVariables['valueToDebit'];
        var valorAnual = double.parse(valorMensual) * 12;
        systemVariables['valueToDebit'] = valorAnual.toStringAsFixed(2);
      }
    } else {
      systemVariables['valueToDebit'] = (Plan.plans[plan]['values']
              [DateTime.now().month - 1])
          .toStringAsFixed(2);
      if (systemVariables['formaPago'] == "Anual") {
        var valorMensual = systemVariables['valueToDebit'];
        var valorAnual = double.parse(valorMensual) * 12;
        systemVariables['valueToDebit'] = valorAnual.toStringAsFixed(2);
      }

      if (systemVariables['valueToDebit'] != '0.00') {
        systemVariables['tipoTransaccion'] = 'Cambio de Plan';

        if (getPlanName() ==
            Plan.plans[systemVariables['selectedPlan']]['name']) {
          systemVariables['tipoTransaccion'] = 'Regularización';
          systemVariables['valueToDebit'] = '0.00';
          systemVariables['valueToCredit'] = '0.00';
        }
      } else {
        systemVariables['tipoTransaccion'] = 'Regularización';
        systemVariables['valueToDebit'] = '0.00';
        systemVariables['valueToCredit'] = '0.00';
      }
    }
    if (systemVariables['valueToDebit'] != '0.00') {
      systemVariables['fechaInicioVigencia'] =
          DateFormat('dd-MM-yyyy', 'es_ES').format(DateTime.now());
      systemVariables['fechaFinVigencia'] = '01/11/2024';
      //systemVariables['fechaFinVigencia'] = DateFormat('dd-MM-yyyy', 'es_ES')
      //.format(DateTime.now().add(Duration(days: 366)));
    } else {
      systemVariables['fechaInicioVigencia'] = '01/11/2023';
    }
  }

  /// Método para calcular la edad del cliente con respecto a '01-01-2023'
  double calculateAge() {
    String queryClientBirthday = DateTime.parse(
            '${systemVariables['client'].sdtFechaNacimientoCh}T000000')
        .toString()
        .split(' ')[0];
    List dmyTemp = queryClientBirthday.split('-');

    String dmyString = '${dmyTemp[2]}/${dmyTemp[1]}/${dmyTemp[0]}';

    final RegExpMatch? match = systemRegex['age']!.firstMatch(dmyString);
    if (match == null) {
      throw const FormatException('calculateAge: invalid date format');
    }
    final DateTime myDateTime = DateTime(
      int.parse(match.namedGroup('year').toString()),
      int.parse(match.namedGroup('month').toString()),
      int.parse(match.namedGroup('day').toString()),
    );
    systemVariables['socioFechaNacimiento'] =
        myDateTime.toString().substring(0, 10);
    final Duration dateToday =
        DateTime.parse('2023-01-01').difference(myDateTime);
    return double.parse((dateToday.inDays / 365).toStringAsFixed(2));
  }

  /// Método para obtener la edad del cliente en años, meses y días
  List<int> calculateAgeRule() {
    try {
      // Obtener la fecha de nacimiento del cliente
      final String date = systemVariables['client'].sdtFechaNacimientoCh;
      // Convertir la fecha de nacimiento del cliente a DateTime
      final DateTime birthdate = DateTime(int.parse(date.substring(0, 4)),
          int.parse(date.substring(4, 6)), int.parse(date.substring(6, 8)));
      // Obtenemos la fecha de validación según las reglas de negocio
      final DateTime currentDate = DateTime.parse('2023-01-01');
      // Realizamos los cálculos
      int years = currentDate.year - birthdate.year;
      int months = currentDate.month - birthdate.month;
      int days = currentDate.day - birthdate.day;
      // Si los días son negativos, restamos un mes
      if (days < 0) {
        days += _daysInMonth(birthdate.month, birthdate.year);
        months--;
      }
      // Si los meses son negativos, restamos un año
      if (months < 0) {
        months += 12;
        years--;
      }
      // Si el proceso se realizó correctamente, imprimimos los valores y retornamos los valores
      debugPrint('CLIENT - Years: $years, Months: $months, Days: $days');
      return [years, months, days];
    } catch (e) {
      // Si hubo errores, mostramos un mensaje de error y retornamos una lista vacía
      ToastNotifications.showBadNotification(
          msg: 'Error al obtener la fecha de nacimiento del cliente');
      return [];
    }
  }

  /// Método para obtener los días de un mes
  int _daysInMonth(int month, int year) {
    switch (month) {
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      case 2:
        return _isLeapYear(year) ? 29 : 28;
      default:
        return 31;
    }
  }

  /// Método para comprobar si el año es bisiesto
  bool _isLeapYear(int year) {
    return year % 400 == 0 || (year % 100 != 0 && year % 4 == 0);
  }

  /// Método para generar el pin y enviarlo al cliente
  Future<void> generatePin(context) async {
    // validar correo con expresion regular
    if (nuevoCorreo != '' && systemVariables['screen'] == 'Plan Seleccionado') {
      final RegExp exp = RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if (!exp.hasMatch(nuevoCorreo)) {
        ToastNotifications.showBadNotification(
            msg: 'Ingrese un correo electrónico válido');
        return;
      }
      systemVariables['clientNewEmail'] = nuevoCorreo;
    }

    // await showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (context) => const DialogPayment(),
    // );
    // todo comment out this line after done testing
    if (nuevoCelular != '') {
      // if (true) {
      NotificationController().sendSMS(
          '/send-otp',
          // todo comment out this line after done testing
          OtpController().generateCode(numCed).toString(),
          nuevoCelular);
      // OtpController().generateCode(numCed).toString(),
      // "0992987687");
    } else {
      NotificationController().sendSMS(
          '/send-otp',
          OtpController().generateCode(numCed).toString(),
          systemVariables['client'].sdtTelefonoCelular);
    }
    debugPrint(OtpController().generateCode(numCed).toString());
    changePinSended(true);
    startTimer();
  }

  Future<void> validatePIN(pin) async {
    changePinValidating(true);
    if (OtpController().verifyCode(int.parse(pin), numCed)) {
      systemVariables['pinValidado'] = pin;
      debugPrint('Pin validado para realizar: ${systemVariables['screen']}');
      if (systemVariables['screen'] == 'Plan Seleccionado') {
        if (['Plan Nuevo'].contains(systemVariables['tipoTransaccion'])) {
          await makeDebit();
        } else if (['Cambio de Plan']
            .contains(systemVariables['tipoTransaccion'])) {
          debugPrint('Cambio de plan...');
          // systemVariables['valueToCredit'] =
          //     (Plan.plans[getPlanIndex()]['values'][DateTime.now().month - 1]);

          systemVariables['valueToCredit'] =
              systemVariables['client'].sdtValordebitado.toString();
          // systemVariables['valueToDebit'] =
          //   (Plans.listPlanValues[plan]).toStringAsFixed(2);
          debugPrint(systemVariables['valueToCredit']);
          debugPrint(systemVariables['valueToDebit']);
          await makeCredit();
          await makeDebit();
        }
        await generateClient();
        await generateFilesAndSendEmail();
      } else if (systemVariables['screen'] == 'Anulación') {
        await generateAnulmentClient();
        pinController.text = '';
      }
      final dynamic response = await AWSRepository.updatePointsUser(
          systemVariables['idEjecutivo'],
          systemVariables['puntosAcumulados'] +
              systemVariables['puntosAsignar']);
      if (response == 'Error') {
        ToastNotifications.showBadNotification(
            msg:
                'Error al actualizar los puntos del ejecutivo ${systemVariables['nombreEjecutivo']}');
      }
      debugPrint('Puntos actualizados: $response');
      changeScreen(3);
    } else {
      ToastNotifications.showBadNotification(msg: 'PIN Incorrecto');
      pinController.text = '';
    }
    changePinValidating(false);
  }

  /// Metodo para retornar los minutos y segundos del timer del pin
  String timerPIN(String s) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final String minutes = strDigits(myDuration.inMinutes.remainder(60));
    final String seconds = strDigits(myDuration.inSeconds.remainder(60));
    switch (s) {
      case 'm':
        return minutes;
      case 's':
        return seconds;
    }
    return '';
  }

  /// Método para finalizar cualquier gestión
  void giveMeFive() {
    formSearchNumCed.control('num_ced').value = '';
    restarSapo();
  }

  /// Método para establecer el sistema en el modo inicial
  void restarSapo() {
    anulPlan = false;
    changeHaveAnotherPhone(false);
    systemVariables['clientNewPhone'] = '';
    systemVariables['clientNewEmail'] = '';
    systemFlags['clientExistsInDB'] = false;
    systemFlags['clientAdvisory'] = false;
    systemFlags['clientPlanMajor'] = false;
    pinController.text = '';
    formGroupSecondStep.control('nuevo_celular').value = '';
    formGroupSecondStep.control('nuevo_correo').value = '';
    formAsegurability.control('haveDisease').value = false;
    formAsegurability.control('diseaseName').value = '';
    formPayment.control('paymentYearly').value = false;
    changePinValidating(false);
    changeCedLength10(false);
    anulPlan = false;
    systemVariables['formaPago'] = "Mensual";
    systemVariables['valueToCredit'] = '0.00';
    stopTimer();
    reasonToAnulment = "El socio no autorizó el débito";
  }

  /// Retorna el valor debitado en formato con coma y dos decimales
  String getDecimalFormat(value) {
    if (value == 0) {
      return '0';
    }
    List valueSplit = value.toString().split('.');
    if (valueSplit.length == 1) {
      return valueSplit[0] + ',00';
    }
    String decimals;
    try {
      decimals = valueSplit[1];
    } catch (e) {
      decimals = '00';
    }
    if (decimals.length == 1) {
      return valueSplit[0] + ',' + decimals + '0';
    }
    return valueSplit[0] + ',' + decimals;
  }

  /// Retorna el index del plan según el valor debitado
  int getPlanIndex() {
    final double debito = systemVariables['client'].sdtValordebitado;
    for (int i = 0; i < Plan.plans.length; i++) {
      if (Plan.plans[i]['values'].contains(debito)) {
        return i;
      }
    }
    return 0;
  }

  /// Retorna el nombre del plan según el valor debitado
  String getPlanName() {
    final double debito = systemVariables['client'].sdtValordebitado;
    for (int i = 0; i < Plan.plans.length; i++) {
      if (Plan.plans[i]['values'].contains(debito)) {
        return Plan.plans[i]['name'];
      }
    }
    if (systemFlags['clientExistsInDB'] == true) {
      if (systemFlags["clientCanceled"] == true) {
        return 'Sin plan';
      } else {
        return systemVariables['planFinalMufasa'].split(" - ")[0];
      }
    }
    return 'Sin plan';
  }

  /// Retorna el valor del plan según el nombre del plan
  double getPlanValue(String plan) {
    for (int i = 0; i < Plan.plans.length; i++) {
      if (plan == Plan.plans[i]['name']) {
        return Plan.plans[i]['values'][DateTime.now().month - 1];
      }
    }
    return 0.00;
  }

  String getTextRegularized(int n) {
    print(systemFlags['clientExistsInDB']);
    print(systemVariables['client'].sdtValordebitado);
    print(systemFlags['clientCanceled']);
    print(systemFlags['clientAdvisory']);
    print(systemFlags['clientExistsInDB']);

    if (systemFlags['clientExistsInDB'] == false &&
        systemVariables['client'].sdtValordebitado == 0) {
      return n == 1
          ? '¡Usuario Sin Seguro!'
          : n == 2
              ? 'Todavía no tiene un Seguro de vida'
              : '0';
    } else if (systemFlags['clientCanceled'] == true) {
      return n == 1
          ? '¡Usuario con Anulación!'
          : n == 2
              ? 'Usted anuló su Seguro de vida'
              : '0';
    } else if (systemFlags['clientAdvisory'] == false &&
        systemFlags['clientExistsInDB'] == true) {
      if (systemFlags['clientPlanMajor'] == true) {
        return n == 1
            ? '¡Usuario en Plan ${getPlanName()} Regularizado!'
            : n == 2
                ? 'Usted se encuentra regularizado'
                : '12';
      }
      return n == 1
          ? '¡Usuario Regularizado!'
          : n == 2
              ? ''
              : '12';
    }
    return n == 1
        ? '¡Usuario No Regularizado!'
        : n == 2
            ? 'Todavía no ha regularizado su Seguro de vida'
            : '0';
  }

  String getNumCedEncode(String numCed) {
    var n = int.parse(numCed);
    const String digits =
        "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String result = "";
    while (n > 0) {
      result = digits[n % digits.length] + result;
      n = n ~/ digits.length;
    }
    return result;
  }

  Future<void> downloadFile(String numCed) async {
    bool response = await launchUrl(
      Uri.parse(
        'https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/benefica/$numCed/firmados/anulacion_$numCed.pdf',
      ),
      webOnlyWindowName: '_blank',
    );
    if (!response) {
      ToastNotifications.showBadNotification(
          msg: 'No se pudo descargar el archivo');
    }
  }

  Future<void> downloadFiles(int index) async {
    final String cedula = systemVariables['client'].sdtNumeroIdentificacion;
    final List<String> urls = <String>[
      'https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/benefica/$cedula/firmados/${cedula}_auth_broker.pdf',
      //'https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/benefica/$cedula/firmados/${cedula}_auth_data.pdf',
      'https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/benefica/$cedula/firmados/${cedula}_auth_debit.pdf',
      'https://janus-afiliaciones-documents.s3.us-east-2.amazonaws.com/benefica/$cedula/firmados/${cedula}_certificado.pdf',
    ];
    final List<String> names = <String>[
      'la Autorización de Broker',
      //'la Autorización de Datos',
      'la Autorización de Débito',
      'el Certificado',
    ];

    bool response = await launchUrl(
      Uri.parse(
        urls[index],
      ),
      webOnlyWindowName: '_blank',
    );
    if (!response) {
      ToastNotifications.showBadNotification(
          msg: 'No se pudo descargar ${names[index]}');
    }
  }

  /// Método para obtener los puntos a asignar
  Future<int> getPoints() async {
    await providerAuth.getUserInformation();
    final dynamic responsePointsUser =
        await AWSRepository.pointsUser(providerAuth.user.email!);
    if (responsePointsUser == 'Error') {
      ToastNotifications.showBadNotification(
          msg: 'Error al consultar pointsUser \'${providerAuth.user.email}\'');
      return 0;
    }
    debugPrint('Puntos actuales: ${responsePointsUser['puntos_acumulados']}');
    systemVariables['puntosAcumulados'] =
        responsePointsUser['puntos_acumulados'];
    systemVariables['nombreEjecutivo'] =
        responsePointsUser['nombre'].toString().split(' ')[0];
    systemVariables['idEjecutivo'] = responsePointsUser['id'];
    final dynamic responsequeryPoints = await AWSRepository.queryPoints(
        Plan.plans[systemVariables['selectedPlan']]['name'],
        systemVariables['tipoTransaccion']);
    if (responsequeryPoints == 'Error') {
      ToastNotifications.showBadNotification(
          msg:
              'Error al consultar queryPoints \'${Plan.plans[systemVariables['selectedPlan']]['name']}\' \'${systemVariables['tipoTransaccion']}\'');
      return 0;
    }
    debugPrint('Puntos a asignar: ${int.parse(responsequeryPoints['puntos'])}');
    return int.parse(responsequeryPoints['puntos']);
  }

  /// Método para enviar el débito a realizar al cliente
  Future<void> makeDebit() async {
    final dynamic response = await AWSRepository.generateDebit(
      systemVariables['client'].sdtNumeroIdentificacion ?? '',
      systemVariables['client'].sdtNumeroCuenta ?? '',
      systemVariables['valueToDebit'].toString().replaceAll(',', '.'),
    );
    print(response);
    if (response == 'Error') {
      ToastNotifications.showBadNotification(
          msg: 'Error al realizar el débito');
      return;
    }

    if (response['ProcesaDebitoResult']['ODBS_RESULTADO_DESCRIPCION'] == 'OK') {
      await generateClient();
    } else {
      systemVariables['errorDebito'] =
          response['ProcesaDebitoResult']['ODBS_RESULTADO_DESCRIPCION'];
      systemVariables['screen'] = 'Débito incorrecto';
      await generateIncorrectDebitClient();
    }
  }

  /// Método para enviar el crédito a realizar al cliente

  Future makeCredit() async {
    print("about to do the credit operation");
    final dynamic responseCredit = await AWSRepository.generateCredit(
      systemVariables['client'].sdtNumeroIdentificacion ?? '',
      systemVariables['client'].sdtNumeroCuenta ?? '',
      systemVariables['valueToCredit'].toString().replaceAll(',', '.'),
    );

    if (responseCredit == 'Error') {
      ToastNotifications.showBadNotification(
          msg: 'Error al realizar el crédito a la cuenta');
      return;
    }
    if (responseCredit['ProcesaCreditoResult']['ODBS_RESULTADO_INDICADOR'] ==
        '200') {
      return "OK";
    } else {
      systemVariables['errorDebito'] = "ERROR CREDITO " +
          responseCredit['ProcesaCreditoResult']['ODBS_RESULTADO_DESCRIPCION'];
      systemVariables['screen'] = 'Débito incorrecto';
      await generateIncorrectDebitClient();
    }
  }

  /// Método para generar el registro del cliente en la base de datos
  Future<void> generateClient() async {
    if (systemFlags['clientExistsInDB'] == true) {
      final dynamic response = await AWSRepository.updateClient({
        'identificacion': systemVariables['clientInDB'],
        'cedula': systemVariables['client'].sdtNumeroIdentificacion,
        'nombre':
            '${systemVariables['client'].sdtPrimerNombre} ${systemVariables['client'].sdtPrimerApellido} ${systemVariables['client'].sdtSegundoApellido}',
        'cuenta': systemVariables['client'].sdtNumeroCuenta,
        'fechaNacimiento': systemVariables['socioFechaNacimiento'],
        'edad': systemVariables['edadClient'],
        'emailAnterior': systemVariables['client'].sdtEmail,
        'emailNuevo': formGroupSecondStep.control('nuevo_correo').value,
        'celularAnterior': systemVariables['client'].sdtTelefonoCelular,
        'celularNuevo': nuevoCelular,
        'agencia': systemVariables['client'].sdtOficina,
        'estadoInicial': systemVariables['estadoAnteriorInDB'],
        'planInicial': getPlanName(),
        'debitoInicial': systemVariables['client'].sdtValordebitado,
        'opcion': systemVariables['tipoTransaccion'],
        'planFinal': systemVariables['selectedPlan'] != -1
            ? Plan.plans[systemVariables['selectedPlan']]['name']
            : '',
        'debitoAdicional': systemVariables['valueToDebit'],
        'pin': systemVariables['pinValidado'],
        'puntosAsignar': systemVariables['puntosAsignar'],
        'enfermedades': systemVariables['enfermedades'],
      });
      if (response == 'Error') {
        ToastNotifications.showBadNotification(
            msg: 'Error al actualizar cliente');
      } else {
        debugPrint('Cliente actualizado: $response');
      }
    } else {
      final dynamic response = await AWSRepository.createClient({
        'cedula': systemVariables['client'].sdtNumeroIdentificacion,
        'nombre':
            '${systemVariables['client'].sdtPrimerNombre} ${systemVariables['client'].sdtPrimerApellido} ${systemVariables['client'].sdtSegundoApellido}',
        'cuenta': systemVariables['client'].sdtNumeroCuenta,
        'fechaNacimiento': systemVariables['socioFechaNacimiento'],
        'edad': systemVariables['edadClient'],
        'emailAnterior': systemVariables['client'].sdtEmail,
        'emailNuevo': formGroupSecondStep.control('nuevo_correo').value,
        'celularAnterior': systemVariables['client'].sdtTelefonoCelular,
        'celularNuevo': nuevoCelular,
        'agencia': systemVariables['client'].sdtOficina,
        'estadoInicial': systemVariables['client'].sdtValordebitado == 0
            ? 'Sin Seguro'
            : 'Sin Regularizar',
        'planInicial': getPlanName(),
        'debitoInicial': systemVariables['client'].sdtValordebitado,
        'opcion': systemVariables['tipoTransaccion'],
        'planFinal': systemVariables['selectedPlan'] != -1
            ? Plan.plans[systemVariables['selectedPlan']]['name']
            : '',
        'debitoAdicional': systemVariables['valueToDebit'],
        'pin': systemVariables['pinValidado'],
        'puntosAsignar': systemVariables['puntosAsignar'],
        'enfermedades': systemVariables['enfermedades'],
      });
      if (response == 'Error') {
        ToastNotifications.showBadNotification(msg: 'Error al crear cliente');
      } else {
        debugPrint('Cliente creado: $response');
        systemVariables['clientInDB'] = response;
      }
    }
  }

  Future<void> generateIncorrectDebitClient() async {
    if (systemFlags['clientExistsInDB'] == true) {
      final dynamic response = await AWSRepository.updateIncorrectDebitClient({
        'id': systemVariables['clientInDB'],
        'cedula': systemVariables['client'].sdtNumeroIdentificacion,
        'nombre':
            '${systemVariables['client'].sdtPrimerNombre} ${systemVariables['client'].sdtPrimerApellido} ${systemVariables['client'].sdtSegundoApellido}',
        'cuenta': systemVariables['client'].sdtNumeroCuenta,
        'fechaNacimiento': systemVariables['socioFechaNacimiento'],
        'edad': systemVariables['edadClient'],
        'emailAnterior': systemVariables['client'].sdtEmail,
        'emailNuevo': formGroupSecondStep.control('nuevo_correo').value,
        'celularAnterior': systemVariables['client'].sdtTelefonoCelular,
        'celularNuevo': nuevoCelular,
        'agencia': systemVariables['client'].sdtOficina,
        'estadoInicial': systemVariables['client'].sdtValordebitado == 0
            ? 'Sin Seguro'
            : 'Sin Regularizar',
        'planInicial': getPlanName(),
        'debitoInicial': systemVariables['client'].sdtValordebitado,
        'opcion': systemVariables['tipoTransaccion'],
        'planFinal': systemVariables['selectedPlan'] != -1
            ? Plan.plans[systemVariables['selectedPlan']]['name']
            : '',
        'debitoAdicional': systemVariables['valueToDebit'],
        'pin': systemVariables['pinValidado'],
        'puntosAsignar': '0',
        'enfermedades': systemVariables['enfermedades'],
        'observacionDebito': systemVariables['errorDebito']
      });
      if (response == 'Error') {
        ToastNotifications.showBadNotification(
            msg: 'Error al actualizar el débito incorrecto del cliente');
      } else {
        debugPrint('Cliente débito incorrecto actualizado: $response');
      }
    } else {
      final dynamic response = await AWSRepository.createIncorrectDebitClient({
        'cedula': systemVariables['client'].sdtNumeroIdentificacion,
        'nombre':
            '${systemVariables['client'].sdtPrimerNombre} ${systemVariables['client'].sdtPrimerApellido} ${systemVariables['client'].sdtSegundoApellido}',
        'cuenta': systemVariables['client'].sdtNumeroCuenta,
        'fechaNacimiento': systemVariables['socioFechaNacimiento'],
        'edad': systemVariables['edadClient'],
        'emailAnterior': systemVariables['client'].sdtEmail,
        'emailNuevo': formGroupSecondStep.control('nuevo_correo').value,
        'celularAnterior': systemVariables['client'].sdtTelefonoCelular,
        'celularNuevo': nuevoCelular,
        'agencia': systemVariables['client'].sdtOficina,
        'estadoInicial': systemVariables['client'].sdtValordebitado == 0
            ? 'Sin Seguro'
            : 'Sin Regularizar',
        'planInicial': getPlanName(),
        'debitoInicial': systemVariables['client'].sdtValordebitado,
        'opcion': systemVariables['tipoTransaccion'],
        'planFinal': systemVariables['selectedPlan'] != -1
            ? Plan.plans[systemVariables['selectedPlan']]['name']
            : '',
        'debitoAdicional': systemVariables['valueToDebit'],
        'pin': systemVariables['pinValidado'],
        'puntosAsignar': '0',
        'enfermedades': systemVariables['enfermedades'],
        'observacionDebito': systemVariables['errorDebito']
      });
      if (response == 'Error') {
        ToastNotifications.showBadNotification(
            msg: 'Error al crear el débito incorrecto del cliente');
      } else {
        debugPrint('Cliente débito incorrecto creado: $response');
      }
    }
  }

  /// Método para enviar cliente a asesoría
  Future<void> sendAdvisory() async {
    systemVariables['screen'] = 'Asesoría';
    changeScreen(-1);
    final dynamic response = await AWSRepository.createClientAsesoria({
      'cedula': systemVariables['client'].sdtNumeroIdentificacion,
      'nombre':
          '${systemVariables['client'].sdtPrimerNombre} ${systemVariables['client'].sdtPrimerApellido} ${systemVariables['client'].sdtSegundoApellido}',
      'cuenta': systemVariables['client'].sdtNumeroCuenta,
      'fechaNacimiento': systemVariables['socioFechaNacimiento'],
      'edad': systemVariables['edadClient'],
      'email': systemVariables['client'].sdtEmail,
      'celular': systemVariables['client'].sdtTelefonoCelular,
      'agencia': systemVariables['client'].sdtOficina,
      'estado': systemVariables['client'].sdtValordebitado == 0
          ? 'Sin Seguro'
          : 'Sin Regularizar',
      'plan': getPlanName(),
      'debito': systemVariables['client'].sdtValordebitado,
      'opcion': 'Asesoría'
    });
    if (response == 'Error') {
      ToastNotifications.showBadNotification(
          msg: 'Ocrrió un error al enviar a asesoría');
    } else {
      debugPrint('Cliente asesoría: $response');
    }
    changeScreen(3);
  }

  /// Metodo para generar el registro de anulación del cliente en la base de datos
  Future<void> generateAnulmentClient() async {
    debugPrint("Process anulment started");
    if (systemFlags['clientExistsInDB'] == true) {
      debugPrint("Anulment for client in DB");
      final dynamic response = await AWSRepository.updateAnulmentClient({
        'identificacion': systemVariables['clientInDB'],
        'estadoInicial': systemVariables['client'].sdtValordebitado == 0
            ? 'Sin Seguro'
            : 'Sin Regularizar',
        'planInicial': getPlanName(),
        'debitoInicial': systemVariables['client'].sdtValordebitado,
        'opcion': systemVariables['tipoTransaccion'],
        'planFinal': systemVariables['selectedPlan'] != -1
            ? Plan.plans[systemVariables['selectedPlan']]['name']
            : '',
        'pin': systemVariables['pinValidado'],
        'puntosAsignar': systemVariables['puntosAsignar']
      });
      if (response == 'Error') {
        debugPrint("Error in Anulment for client in DB");
        ToastNotifications.showBadNotification(
            msg: 'Error al actualizar anulación del cliente');
      } else {
        debugPrint('Cliente anulación actualizado: $response');
      }
    } else {
      debugPrint("Anulment for client NOT in the DB");
      final dynamic response = await AWSRepository.createAnulmentClient({
        'cedula': systemVariables['client'].sdtNumeroIdentificacion,
        'nombre':
            '${systemVariables['client'].sdtPrimerNombre} ${systemVariables['client'].sdtPrimerApellido} ${systemVariables['client'].sdtSegundoApellido}',
        'cuenta': systemVariables['client'].sdtNumeroCuenta,
        'fechaNacimiento': systemVariables['socioFechaNacimiento'],
        'edad': systemVariables['edadClient'],
        'emailAnterior': systemVariables['client'].sdtEmail,
        'emailNuevo': formGroupSecondStep.control('nuevo_correo').value,
        'celularAnterior': systemVariables['client'].sdtTelefonoCelular,
        'celularNuevo': nuevoCelular,
        'agencia': systemVariables['client'].sdtOficina,
        'estadoInicial': systemVariables['client'].sdtValordebitado == 0
            ? 'Sin Seguro'
            : 'Sin Regularizar',
        'planInicial': getPlanName(),
        'debitoInicial': systemVariables['client'].sdtValordebitado,
        'opcion': systemVariables['tipoTransaccion'],
        'planFinal': systemVariables['selectedPlan'] != -1
            ? Plan.plans[systemVariables['selectedPlan']]['name']
            : '',
        'pin': systemVariables['pinValidado'],
        'motivoAnulacion': reasonToAnulment
      });
      if (response == 'Error') {
        debugPrint("Error in Anulment for client NOT in the DB");
        ToastNotifications.showBadNotification(
            msg: 'Error al crear anulación del cliente');
      } else {
        debugPrint('Cliente anulación creado: $response');
      }
    }
    debugPrint("Creating anulment file process started");
    final dynamic response = await AWSRepository.generateAnulmentFile({
      'nombrePersona':
          '${systemVariables['client'].sdtPrimerNombre} ${systemVariables['client'].sdtPrimerApellido} ${systemVariables['client'].sdtSegundoApellido}',
      'cedulaPersona': systemVariables['client'].sdtNumeroIdentificacion,
      'pin': systemVariables['pinValidado'],
      'valor_debitado': systemVariables['client'].sdtValordebitado,
      'cuenta': systemVariables['client'].sdtNumeroCuenta,
      // todo replace for the actual data of the plan
      'plan': "PLAN VIDA",
      'motivo_anulacion': reasonToAnulment,
    });
    if (response == 'Error') {
      ToastNotifications.showBadNotification(
          msg: 'Error al generar archivo de anulación');
    } else {
      debugPrint('Archivo de anulación generado: $response');
    }
    debugPrint("Creating anulment file process finished");
    // await makeCredit();
    Client client = systemVariables['client'];
    var responseFirma = await AWSRepository.signAnulmentFile({
      'client': client,
      'nombrePersona':
          '${systemVariables['client'].sdtPrimerNombre} ${systemVariables['client'].sdtPrimerApellido} ${systemVariables['client'].sdtSegundoApellido}',
      'cedulaPersona': systemVariables['client'].sdtNumeroIdentificacion,
      'pin': systemVariables['pinValidado'],
      'valor_debitado': systemVariables['client'].sdtValordebitado,
      'cuenta': systemVariables['client'].sdtNumeroCuenta,
      'plan': ""
    });
    if (response == 'Error') {
      ToastNotifications.showBadNotification(
          msg: 'Error al generar archivo de anulación');
    } else {
      debugPrint('Archivo de anulación generado: $response');
    }
    await downloadFile(systemVariables['client'].sdtNumeroIdentificacion ?? '');
  }

  Future<void> getTablePlans() async {
    final dynamic response = await AWSRepository.getTableFormat();
    if (response == 'Error') {
      ToastNotifications.showBadNotification(
          msg: 'Error al obtener de tabla de planes');
    }
  }

  Future<void> generateFilesAndSendEmail() async {
    Client client = systemVariables['client'];
    final dynamic response = await AWSRepository.generateFiles({
      'email': systemVariables['clientNewEmail'] == ''
          ? client.sdtEmail
          : systemVariables['clientNewEmail'],
      'nombre':
          "${client.sdtPrimerNombre} ${client.sdtSegundoNombre} ${client.sdtPrimerApellido} ${client.sdtSegundoApellido}",
      'genero': client.sdtGenero,
      'fechaInicio': systemVariables['fechaInicioVigencia'],
      'fechaFin': '01/11/2024',
      'cedula': numCed,
      'client': client,
      'aseguradora': systemVariables['nombreEjecutivo'],
      'fechaInicioVigencia': systemVariables['fechaInicioVigencia'],
      'plan': Plan.plans[systemVariables['selectedPlan']]['name'],
      'enfermedades': systemVariables['enfermedades'],
      'valor_opcion':
          systemVariables['valueToDebit'].toString().replaceAll(',', '.'),
      'dependents': getDependents(),
    });
    if (response == 'Error') {
      ToastNotifications.showBadNotification(
          msg: 'Error al generar los certificados');
    }
    AWSRepository.sendEmail({
      'email': systemVariables['clientNewEmail'] == ''
          ? client.sdtEmail
          : systemVariables['clientNewEmail'],
      'cedula': client.sdtNumeroIdentificacion,
      'nombre':
          "${client.sdtPrimerNombre} ${client.sdtSegundoNombre} ${client.sdtPrimerApellido} ${client.sdtSegundoApellido}",
      'genero': client.sdtGenero,
      'plan': Plan.plans[systemVariables['selectedPlan']]['name'],
      'fechaInicio': systemVariables['fechaInicioVigencia'],
      'fechaFin': '01/11/2024',
    });
  }

  /// Validación de las relgs de los planes
  bool validatePlanRules(Map<String, dynamic> plan) {
    List<int> age = calculateAgeRule();
    List rulesMin = [];
    List rulesMax = [];
    // Comprobamos si el cliente existe en la base de datos
    if (systemVariables['debito'] != 0 &&
        !['Asesoría', 'Plan Nuevo', 'Anulación']
            .contains(systemVariables['opcion'])) {
      rulesMin = plan['min_age_old'];
      rulesMax = plan['max_age_old'];
    } else {
      rulesMin = plan['min_age_new'];
      rulesMax = plan['max_age_new'];
    }

    if (age[0] < rulesMin[0] || age[0] > rulesMax[0]) {
      return false;
    }
    if ((age[0] <= rulesMin[0] && age[1] < rulesMin[1]) ||
        (age[0] >= rulesMax[0] && age[1] > rulesMax[1])) {
      return false;
    }
    if ((age[0] <= rulesMin[0] &&
            age[1] <= rulesMin[1] &&
            age[2] < rulesMin[2]) ||
        (age[0] >= rulesMax[0] &&
            age[1] >= rulesMax[1] &&
            age[2] > rulesMax[2])) {
      return false;
    }
    return true;
  }

  Future<void> updateBenefit() async {
    changeScreen(-1);
    final dynamic response = await AWSRepository.updateClientBenefit({
      'id': systemVariables['clientInDB'],
      'socioBeneficiarios': getDependentsName(),
      'socioTipoBeneficiarios': getDependentsRelation(),
    });
    if (response == 'Error') {
      ToastNotifications.showBadNotification(
          msg: 'Error al actualizar beneficiarios');
    } else {
      debugPrint('Beneficiarios actualizados: $response');
    }
    Client client = systemVariables['client'];
    await AWSRepository.generateCertificate({
      'cedula': client.sdtNumeroIdentificacion,
      'client': systemVariables['client'],
      'mufasa': systemVariables['mufasa'],
      'dependents': getDependents(),
    });

    await AWSRepository.sendEmail({
      'email': systemVariables['mufasa']['socioEmailNuevo'] == ''
          ? systemVariables['mufasa']['socioEmailAnterior']
          : systemVariables['mufasa']['socioEmailNuevo'],
      'cedula': client.sdtNumeroIdentificacion,
      'nombre':
          '${client.sdtPrimerNombre} ${client.sdtSegundoNombre} ${client.sdtPrimerApellido} ${client.sdtSegundoApellido}',
      'genero': client.sdtGenero,
      'plan': systemVariables['mufasa']['socioPlanFinal'],
      'fechaInicio':
          systemVariables['mufasa']['socioOpcion'] == 'Regularización'
              ? '01/11/2023'
              : systemVariables['mufasa']['fechaGestion']
                  .toString()
                  .substring(0, 10)
                  .replaceAll('-', '/'),
      'fechaFin': '01/11/2024',
    });
    changeScreen(3);
  }

  List beneficiariosList = [TextEditingController()];
  List beneficiariosParentezcoList = ['HIJO/A'];
  List beneficiariosPorcentajeList = ['100 %'];
  String socioBeneficiarios = '';
  String socioTipoBeneficiarios = '';

  bool validateBenefitiaries() {
    socioBeneficiarios = '';
    socioTipoBeneficiarios = '';
    bool isValid = true;
    for (int i = 0; i < beneficiariosList.length; i++) {
      socioBeneficiarios +=
          '${beneficiariosList[i].text}${i == beneficiariosList.length - 1 ? '' : ', '}';
      socioTipoBeneficiarios +=
          '${beneficiariosParentezcoList[i]}${i == beneficiariosList.length - 1 ? '' : ', '}';
      if (beneficiariosList[i].text == '') {
        isValid = false;
        break;
      }
    }
    return isValid;
  }

  Future<void> updateClientBenefit() async {
    final dynamic response = await AWSRepository.updateClientBenefit({
      'client': systemVariables['clientInDB'],
      'listNames': socioBeneficiarios,
      'listRelations': socioTipoBeneficiarios,
    });
    if (response == 'Error') {
      ToastNotifications.showBadNotification(
          msg: 'Error al actualizar beneficiarios');
    } else {
      debugPrint('Beneficiarios actualizados: $response');
    }
    socioBeneficiarios = '';
    socioTipoBeneficiarios = '';
    changeScreen(3);
  }

  Map<String, dynamic> data = {};
  Future<void> generateData() async {
    final UserService userService = UserService(AmazonConstant.userPool);
    final User? user = await userService.getCurrentUser();
    Client client = systemVariables['client'];
    /* data = {
      'id': '',
      'aseguradora': 'Seguros del Pichincha',
      'canal': "${globals.isSapo ? "SAPO" : "GEMA"},
      'cooperativa': 'Benefica',
      'ejecutivo': user!.email,
      'ejecutivoNombre': user.name,
      'ejecutivoPuntos': '0',
      'fechaGestion': DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
      'observacionGestion': '',
      'poliza': '1930',
      'producto': 'Seguro de Vida',
      'resultadoGestion': 'Gestión Exitosa',
      'socioAgencia': client.sdtOficina,
      'socioBeneficiarios': '',
      'socioCedula': client.sdtNumeroIdentificacion,
      'socioCelularAnterior': client.sdtTelefonoCelular,
      'socioCelularNuevo': nuevoCelular,
      'socioCuenta': client.sdtNumeroCuenta,
      'socioDebitoAdicional': systemVariables['valueToDebit'],
      'socioDebitoInicial': client.sdtValordebitado,
      'socioDiptico': '',
      'socioDocumentosGenerados':
          ['Plan Seleccionado', 'Anulación'].contains(systemVariables['screen'])
              ? 'Sí'
              : 'No',
      'socioEdad': calculateAge(),
      'socioEmailAnterior': client.sdtEmail,
      'socioEmailNuevo': nuevoCorreo,
      'socioEnfermedades': '',
      'socioEstadoInicial': '',
      'socioFechaNacimiento': systemVariables['socioFechaNacimiento'],
      'socioMAIL': systemVariables['screen'] == 'Plan Seleccionado' &&
              (client.sdtEmail.isNotEmpty || nuevoCorreo.isNotEmpty)
          ? 'Sí'
          : 'No',
      'socioNombreCompleto':
          '${client.sdtPrimerNombre} ${client.sdtSegundoNombre} ${client.sdtPrimerApellido} ${client.sdtSegundoApellido}',
      'socioOpcion': systemVariables['tipoTransaccion'],
      'socioPin': systemVariables['pinValidado'],
      'socioPlanFinal': systemVariables['selectedPlan'] != -1
          ? Plan.plans[systemVariables['selectedPlan']]['name']
              .replaceAll("\n", " - ")
          : '',
      'socioPlanInicial': getPlanName(),
      'socioSMS': ['Plan Seleccionado', 'Anulación']
                  .contains(systemVariables['screen']) &&
              (client.sdtTelefonoCelular.isNotEmpty ||
                  nuevoCelular.isNotEmpty) &&
              !haveAnotherPhone
          ? 'Sí'
          : 'No',
      'socioTipoBeneficiarios': '',
      'socioFotografia': numeroDiptico,
      'socioTipo': '',
    }; */
    data = {
      'id': '',
      'aseguradora': 'Seguros del Pichincha',
      'canal': globals.isSapo ? 'SAPO' : 'GEMA',
      'cooperativa': 'Benefica',
      'ejecutivo': user!.email,
      'ejecutivoNombre': user.name,
      'ejecutivoPuntos': '0',
      'fechaGestion': DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
      'observacionGestion': '',
      'poliza': '2195',
      'producto': 'Seguro de Vida',
      'resultadoGestion': 'Gestión Exitosa',
      'socioAgencia': client.sdtOficina,
      'socioBeneficiarios': '',
      'socioCedula': client.sdtNumeroIdentificacion,
      'socioCelularAnterior': client.sdtTelefonoCelular,
      'socioCelularNuevo': nuevoCelular,
      'socioCuenta': client.sdtNumeroCuenta,
      'socioDebitoAdicional': systemVariables['valueToDebit'],
      'socioDebitoInicial': client.sdtValordebitado,
      'socioDiptico': '',
      'socioDocumentosGenerados':
          ['Plan Seleccionado', 'Anulación'].contains(systemVariables['screen'])
              ? 'Sí'
              : 'No',
      'socioEdad': calculateAge(),
      'socioEmailAnterior': client.sdtEmail,
      'socioEmailNuevo': nuevoCorreo,
      'socioEnfermedades': '',
      'socioEstadoInicial': '',
      'socioFechaNacimiento': systemVariables['socioFechaNacimiento'],
      'socioMAIL': systemVariables['screen'] == 'Plan Seleccionado' &&
              (client.sdtEmail.isNotEmpty || nuevoCorreo.isNotEmpty)
          ? 'Sí'
          : 'No',
      'socioNombreCompleto':
          '${client.sdtPrimerNombre} ${client.sdtSegundoNombre} ${client.sdtPrimerApellido} ${client.sdtSegundoApellido}',
      'socioOpcion': systemVariables['tipoTransaccion'],
      'socioPin': systemVariables['pinValidado'],
      'socioPlanFinal': systemVariables['selectedPlan'] != -1
          ? Plan.plans[systemVariables['selectedPlan']]['name']
              .replaceAll("\n", " - ")
          : '',
      'socioPlanInicial': getPlanName(),
      'socioSMS': ['Plan Seleccionado', 'Anulación']
                  .contains(systemVariables['screen']) &&
              (client.sdtTelefonoCelular.isNotEmpty ||
                  nuevoCelular.isNotEmpty) &&
              !haveAnotherPhone
          ? 'Sí'
          : 'No',
      'socioTipoBeneficiarios': '',
      'socioTipo': '',
    };
    if (systemFlags['clientExistsInDB'] == true) {
      data['id'] = systemVariables['clientInDB'];
      data['socioEstadoInicial'] = systemVariables['estadoAnteriorInDB'];
    } else {
      data['id'] = '';
      data['socioEstadoInicial'] =
          client.sdtValordebitado == 0 ? 'Sin Seguro' : 'Sin Regularizar';
    }
    if (systemVariables['screen'] == 'Débito incorrecto') {
      data['resultadoGestion'] = 'Sin débito';
      data['observacionGestion'] = systemVariables['errorDebito'];
    } else if (systemVariables['screen'] == 'Asesoría') {
      data['resultadoGestion'] = 'Asesoría';
    }
  }

  bool validateDialog() {
    // Validar que solo exista un ESPOSO/A
    int count = 0;
    for (int i = 0; i < dependentsRelation.length; i++) {
      if (dependentsRelation[i] == 'ESPOSO/A') {
        count++;
        if (count > 1) {
          ToastNotifications.showBadNotification(
              msg: 'Solo puede registrar un ESPOSO/A');
          return false;
        }
      }
    }

    for (TextEditingController i in dependentsName) {
      if (i.text.isEmpty) {
        ToastNotifications.showBadNotification(
            msg: 'El nombre no puede estar vacío');
        return false;
      }
      if (i.text.length < 3) {
        ToastNotifications.showBadNotification(
            msg: 'El nombre debe tener al menos 3 caracteres');
        return false;
      }
      if (i.text.split(' ').length != 4) {
        ToastNotifications.showBadNotification(
            msg: 'Debe ingresar ambos nombres y apellidos');
        return false;
      } else {
        for (int j = 0; j < i.text.split(' ').length; j++) {
          if (i.text.split(' ')[j].length < 3) {
            ToastNotifications.showBadNotification(
                msg:
                    'El ${j == 0 ? 'primer nombre' : j == 1 ? 'segundo nombre' : j == 2 ? 'primer apellido' : 'segundo apellido'} debe tener al menos 3 caracteres');
            return false;
          }
        }
      }
    }
    return true;
  }

  void addItemDependent() {
    if (dependentsName.length < 5) {
      var beneficiariosListNew = dependentsName;
      var beneficiariosParentezcoListNew = dependentsRelation;
      var beneficiariosPorcentajeListNew = dependentsAge;
      beneficiariosListNew.add(TextEditingController());
      beneficiariosParentezcoListNew.add('HIJO/A');
      beneficiariosPorcentajeListNew.add('100 %');
      dependentsName = beneficiariosListNew;
      dependentsRelation = beneficiariosParentezcoListNew;
      var porcentaje = (100 / beneficiariosListNew.length).toStringAsFixed(2);
      for (var i = 0; i < beneficiariosListNew.length; i++) {
        beneficiariosPorcentajeListNew
            .replaceRange(i, i + 1, ['$porcentaje %']);
      }
      dependentsAge = beneficiariosPorcentajeListNew;
    } else {
      ToastNotifications.showBadNotification(
          msg: 'No se puede añadir más beneficiarios');
    }
  }

  void removeItemDependent() {
    var beneficiariosListNew = dependentsName;
    var beneficiariosParentezcoListNew = dependentsRelation;
    var beneficiariosPorcentajeListNew = dependentsAge;
    beneficiariosListNew.removeLast();
    beneficiariosParentezcoListNew.removeLast();
    beneficiariosPorcentajeListNew.removeLast();
    dependentsName = beneficiariosListNew;
    dependentsRelation = beneficiariosParentezcoListNew;
    var porcentaje = (100 / beneficiariosListNew.length).toStringAsFixed(2);
    for (var i = 0; i < beneficiariosListNew.length; i++) {
      beneficiariosPorcentajeListNew.replaceRange(i, i + 1, ['$porcentaje %']);
    }
    dependentsAge = beneficiariosPorcentajeListNew;
  }

  Future<void> updateDependents() async {
    var beneficiariosName = [];
    for (var i = 0; i < dependentsName.length; i++) {
      beneficiariosName.add(dependentsName[i].text);
    }
    systemVariables['beneficiariosListProvider'] = beneficiariosName.toString();
    systemVariables['beneficiariosParentezcoListProvider'] =
        dependentsRelation.toString();
  }

  void changeDependentsRelation(int index, String? newValue) {
    var beneficiariosParentezcoListNew = dependentsRelation;
    beneficiariosParentezcoListNew.replaceRange(index, index + 1, [newValue!]);
    dependentsRelation = beneficiariosParentezcoListNew;
  }

  changeReasonToAnulment(String? newValue) {
    reasonToAnulment = newValue.toString();
    notifyListeners();
  }

  final List<String> dependentsRelationship = <String>[
    'ABUELO/A',
    'AHIJADO/A',
    'ALBACEA',
    'AMIGO/A',
    'APODERADO/A',
    'BISABUELO/A',
    'BISNIETO/A',
    'COMADRE',
    'COMPADRE',
    'CONTINGENTE',
    'CONTRATANTE',
    'CONVIVIENTE',
    'CUÑADO/A',
    'EMPLEADO/A',
    'EMPLEADOR/A',
    'ESPOSO/A',
    'EXESPOSO/A',
    'HEREDERO/A',
    'HEMANASTRO/A',
    'HERMANO/A',
    'HIJASTRO/A',
    'HIJO/A ADOPTIVO/A',
    'HIJO/A',
    'MADRASTRA',
    'MADRE',
    'MADRINA',
    'NIETO/A',
    'NO DEFINIDO',
    'NOVIO/A',
    'NUERA',
    'PADRASTRO',
    'PADRE',
    'PADRINO',
    'PRIMO/A',
    'PRIMO/A POLITICO/A',
    'SOBRINO/A',
    'SOCIO/A',
    'SUEGRO/A',
    'TATARANIETO/A',
    'TIO/A',
    'TIO POLITICO/A',
    'TITULAR/A',
    'TUTOR/A',
    'VECINO/A',
    'YERNO/A',
  ];

  String getDependentsName() {
    String dependents = '';
    for (int i = 0; i < dependentsName.length; i++) {
      dependents +=
          '${dependentsName[i].text}${dependentsName.length > i + 1 ? ', ' : ''}';
    }
    return dependents;
  }

  String getDependentsRelation() {
    String dependents = '';
    for (int i = 0; i < dependentsRelation.length; i++) {
      dependents +=
          '${dependentsRelation[i]}${dependentsRelation.length > i + 1 ? ', ' : ''}';
    }
    return dependents;
  }

  List<Map<String, String>> getDependents() {
    List<Map<String, String>> dependents = [];
    if (dependentsName[0].text != '') {
      for (int i = 0; i < dependentsName.length; i++) {
        dependents.add({
          'name': dependentsName[i].text,
          'relationship': dependentsRelation[i],
          'age': dependentsAge[i],
        });
      }
    }
    while (dependents.length < 5) {
      dependents.add({
        'name': '',
        'relationship': '',
        'age': '',
      });
    }
    return dependents;
  }

  Future<void> getDipticoNumber() async {
    if (numeroDiptico != '') {
      return;
    }
    // if (!pinSended) {
    //   ToastNotifications.showBadNotification(
    //       msg: 'Debe generar el pin que se incluirá en el díptico');
    //   return;
    // }
    isFetching = 1;
    dynamic result = await AWSRepository.selectDiptico(getNumCedEncode(numCed));
    if (result == "Error") {
      ToastNotifications.showBadNotification(
          msg: 'Error al obtener fotografia');
      isFetching = 0;
      return;
    }
    formGroupSecondStep.control('numero_diptico').value = result["url"];
    isDipticoSelect = true;
    isFetching = 0;
  }
}
