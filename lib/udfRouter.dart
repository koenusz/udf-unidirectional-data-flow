import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UDFRouter {
  logger(String msg) {
    developer.log(msg, name: 'router');
  }

  UDFRouter._internal();

  late final NavigatorState _navigatorState;
  static UDFRouter _instance = UDFRouter._internal();

  static mock(routerMock) {
    if (kDebugMode) {
      _instance = routerMock;
    }
  }

  factory UDFRouter() {
    return _instance;
  }

  init(NavigatorState navigatorState) {
    _navigatorState = navigatorState;
  }

  void navigateTo(String routeName) {
    logger("navigating to: $routeName");
    _navigatorState.pushNamed(routeName);
  }

  void back() {
    logger("popping of");
    _navigatorState.pop();
  }

  /// Remove all from the navigation stack and go to route. this method empties out the navigation stack and puts
  /// the "routedTo" view on top. This feature is especially useful for instance for logging out.
  void removeAllAndNavigateTo(String routeName) {
    _navigatorState.pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }
}
