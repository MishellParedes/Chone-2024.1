import 'package:sapo_benefica/ui/pages/home/home_page.dart';
import 'package:sapo_benefica/ui/pages/login_page.dart';
import 'package:flutter/material.dart';

enum RouteNames {
  home,
  login,
}

/// Gets the url string for the given [RouteNames]
extension RouteUrls on RouteNames {
  String get url =>
      {
        RouteNames.home: '/home',
        RouteNames.login: '/login',
      }[this] ??
      '/home';
}

Map<String, Widget Function(BuildContext)> routes = {
  '/': (_) => const HomePage(),
  RouteNames.home.url: (context) => const HomePage(),
  RouteNames.login.url: (context) => const LoginPage(),
};
