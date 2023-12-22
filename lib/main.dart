import 'package:sapo_benefica/providers/provider_auth.dart';
import 'package:sapo_benefica/providers/provider_home.dart';
import 'package:sapo_benefica/routes/routes.dart';
import 'package:sapo_benefica/routes/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sapo_benefica/globals/globals.dart' as globals;

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProviderAuth()),
    ChangeNotifierProvider(create: (_) => ProviderHome()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: globals.isSapo ? 'SAPO BENEFICA' : 'GEMA BENEFICA',
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.login.url,
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
    );
  }
}
