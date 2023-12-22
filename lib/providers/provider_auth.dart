import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:sapo_benefica/data/models/user_model.dart';
import 'package:sapo_benefica/data/aws/secrest.dart';
import 'package:sapo_benefica/data/aws/user_service.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/toast_notifications.dart';
import 'package:flutter/material.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

class ProviderAuth with ChangeNotifier {
  final _userService = UserService(userPool);

  String? cooperativaUser;
  String? rolUser;
  late List<CognitoUserAttribute> attributesUser;
  String? ejecutivoEncargado;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  set isAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  User? _user = User();
  User get user => _user!;
  set user(User value) {
    _user = value;
    notifyListeners();
  }

  bool _isVisible = true;
  bool get isVisible => _isVisible;
  set isVisible(bool value) {
    _isVisible = value;
    notifyListeners();
  }

  bool _loginOk = false;
  bool get loginOk => _loginOk;
  set loginOk(bool value) {
    _loginOk = value;
    notifyListeners();
  }

  Future<bool> getAuthState() async {
    await _userService.init();
    isAuthenticated = (await _userService.checkAuthenticated())!;
    notifyListeners();
    // getUserInformation();s
    return _isAuthenticated;
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  Future<bool> awsCognitoLogin(String email, String password) async {
    String message = "";

    try {
      User? user = await _userService.login(email, password);
      if (user != null) {
        if (!user.confirmed!) {
          message = 'Por favor, confirme la cuenta de usuario';
          btnController.reset();
        } else {
          message = "Inicio de sesión exitoso";
          btnController.success();
          loginOk = true;
        }
      }
    } on CognitoClientException catch (e) {
      if (e.code == 'InvalidParameterException' ||
          e.code == 'NotAuthorizedException' ||
          e.code == 'UserNotFoundException' ||
          e.code == 'ResourceNotFoundException') {
        btnController.reset();

        message = e.message!;
      } else {
        btnController.reset();
        message = 'Algo salió mal, intente de nuevo';
      }
    } catch (e) {
      message = 'Algo salió mal, intente de nuevo';
      btnController.reset();
    }

    ToastNotifications.showGoodNotification(
      msg: message,
    );

    // notifyListeners();
    return loginOk;
  }

  Future<void> getUserInformation() async {
    await _userService.init();
    attributesUser = await _userService.getAttributesUser();
    _user = await _userService.getCurrentUser();
    debugPrint('user data\n$_user');
    notifyListeners();
  }

  // Sign Out User
  Future<void> signOutUser() async {
    await _userService.signOut();
    isAuthenticated = false;
    user = User();
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }
}
