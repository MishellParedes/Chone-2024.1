import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/ui/pages/home/home_page.dart';
import 'package:sapo_benefica/ui/pages/login_page.dart';
import 'package:sapo_benefica/providers/provider_auth.dart';
import 'package:flutter/material.dart';

abstract class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
            builder: (_) => const _RoutesWrapper(target: LoginPage()),
            settings: settings);
      case '/home':
        return MaterialPageRoute(
            builder: (_) => const _RoutesWrapper(target: HomePage()),
            settings: settings);
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                    body: SafeArea(
                        child: Center(
                  child: CircularProgressIndicator(),
                ))));
    }
  }
}

class _RoutesWrapper extends StatefulWidget {
  const _RoutesWrapper({required this.target});
  final Widget target;

  @override
  State<_RoutesWrapper> createState() => _RoutesWrapperState();
}

class _RoutesWrapperState extends State<_RoutesWrapper> {
  late Future<bool> future;
  final providerAuth = ProviderAuth();
  final providerHome = ProviderHome();

  @override
  void initState() {
    future = providerAuth.getAuthState();
    providerHome.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!) {
            return widget.target;
          } else {
            return const LoginPage();
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
