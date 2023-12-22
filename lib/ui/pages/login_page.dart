import 'package:sapo_benefica/providers/provider_auth.dart';
import 'package:sapo_benefica/routes/routes.dart';
import 'package:sapo_benefica/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sapo_benefica/ui/pages/home/widgets/toast_notifications.dart';

import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: size.width * 0.5,
              child: SizedBox(
                height: size.height * 1,
                width: size.width * 0.5,
                child: SvgPicture.asset(
                  'assets/svg/fondo_azul.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const _BodyLogin()
          ],
        ),
      ),
    );
  }
}

class _BodyLogin extends StatefulWidget {
  const _BodyLogin({
    Key? key,
  }) : super(key: key);

  @override
  State<_BodyLogin> createState() => _BodyLoginState();
}

class _BodyLoginState extends State<_BodyLogin> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final provider = Provider.of<ProviderAuth>(context);
    return Stack(
      children: [
        Positioned(
            top: size.height * 0.2,
            left: size.width * 0.2,
            child: _sideLeft(size, provider)),
        Positioned(
            top: size.height * 0.2,
            left: size.width * 0.5,
            child: _sideRight(size))
      ],
    );
  }

  Widget _sideRight(Size size) {
    return Container(
      height: size.height * 0.65,
      width: size.width * 0.3,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
        color: ThemeApp.primary,
      ),
      child: Stack(
        children: [
          Positioned(
            top: size.height * 0.05,
            child: SizedBox(
              height: size.height * 0.5,
              width: size.width * 0.3,
              child: SvgPicture.asset(
                'assets/svg/imagen_give_me_5_blanca.svg',
                // fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _sideLeft(Size size, ProviderAuth provider) {
    return Container(
      height: size.height * 0.65,
      width: size.width * 0.3,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0XFFF4F7FC), width: 2),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), bottomLeft: Radius.circular(50)),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Positioned(
            top: size.height * 0.05,
            left: size.width * 0.03,
            child: SizedBox(
              height: size.height * 0.13,
              width: size.width * 0.25,
              child: SvgPicture.asset('assets/svg/logo_grupo_mancheno.svg'),
            ),
          ),
          Positioned(
            top: size.height * 0.27,
            left: size.width * 0.03,
            child: SizedBox(
              height: size.height * 0.2,
              width: size.width * 0.35,
              child: Stack(
                children: [
                  SizedBox(
                    height: size.height * 0.2,
                    width: size.width * 0.25,
                    child: Column(
                      children: [
                        _textfield(
                            false,
                            'Correo',
                            provider.emailController,
                            (p0) => null,
                            (p0) {},
                            const Icon(Icons.person, color: ThemeApp.secondary),
                            const SizedBox()),
                        _textfield(
                          provider.isVisible,
                          'Contraseña',
                          provider.passwordController,
                          (p0) => null,
                          (p0) {},
                          const Icon(
                            Icons.lock,
                            color: ThemeApp.secondary,
                          ),
                          IconButton(
                            onPressed: () {
                              provider.isVisible = !provider.isVisible;
                            },
                            icon: Icon(Icons.remove_red_eye,
                                color: !provider.isVisible
                                    ? ThemeApp.secondary
                                    : ThemeApp.borderSettings),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: size.height * 0.08),
            child: const LoadingButton(),
          ),
        ],
      ),
    );
  }

  Widget _textfield(
    bool isVisible,
    String text,
    TextEditingController controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    Widget? icon,
    Widget? suffixIcon,
  ) {
    return TextFormField(
      obscureText: isVisible,
      controller: controller,
      cursorColor: const Color(0XFF2A4D74),
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: icon,
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ThemeApp.borderSettings, width: 2)),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ThemeApp.borderSettings, width: 2)),
          hintText: text,
          hintStyle: const TextStyle(color: ThemeApp.secondary)),
      validator: validator,
      onChanged: onChanged,
    );
  }
}

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ProviderAuth providerLogin = Provider.of<ProviderAuth>(context);

    return RoundedLoadingButton(
      height: size.height * 0.06,
      width: size.width * 0.12,
      elevation: 10,
      color: const Color(0XFF2A4D74),
      controller: providerLogin.btnController,
      successColor: const Color(0XFF2A4D74),
      valueColor: Colors.white,
      borderRadius: 7,
      onPressed: () async {
        // Navigator.pushReplacementNamed(context, HomePage.routeName);
        if (providerLogin.emailController.text != "" &&
            providerLogin.passwordController.text != "") {
          providerLogin.btnController.start();

          // *Login AWS
          await providerLogin.awsCognitoLogin(
            providerLogin.emailController.text,
            providerLogin.passwordController.text,
          );

          if (providerLogin.loginOk) {
            // Set data user logued
            await providerLogin.getUserInformation();
            final Map<String, String> atributos = {};
            for (var i = 0; i < providerLogin.attributesUser.length; i++) {
              atributos[providerLogin.attributesUser[i].name!] =
                  providerLogin.attributesUser[i].value!;
            }
            try {
              // TODO : Check the control of this condition for the users
              if ((atributos['custom:sistema']!.split(', ').contains('sapo') &&
                      atributos['custom:cooperativa']!
                          .split(', ')
                          .contains('Benefica')) ||
                  atributos['custom:cooperativa']!
                      .split(', ')
                      .contains('Grupo Mancheno')) {
                Future.delayed(const Duration(milliseconds: 1500), () {
                  Navigator.restorablePopAndPushNamed(
                      context, RouteNames.home.url);
                });
              } else {
                ToastNotifications.showBadNotification(
                    msg: 'No tienes permisos para acceder a este sistema');
                providerLogin.signOutUser();
                providerLogin.btnController.reset();
              }
            } catch (e) {
              ToastNotifications.showBadNotification(
                  msg: 'No tienes permisos para acceder a este sistema');
              providerLogin.signOutUser();
              providerLogin.btnController.reset();
            }
          }
        } else {
          providerLogin.signOutUser();
          providerLogin.btnController.reset();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text("Login Error"),
                content: Text("Compruebe sus credenciales"),
              );
            },
          );
        }
      },
      child: SizedBox(
        height: size.height * 0.06,
        width: size.width * 0.12,
        child: Center(
          child: Text(
            'INICIA SESIÓN',
            style: TextStyle(
              color: const Color(0XFFFFFFFE),
              fontSize: size.width * 0.01,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
