import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Router {
  logger(String msg) {
    developer.log(msg, name: 'router');
  }

  Router._internal();

  NavigatorState _navigatorState;
  static Router _instance;
  bool initialised = false;

  static mock(routerMock) {
    if (kDebugMode) {
      _instance = routerMock;
    }
  }

  factory Router() {
    if (_instance == null) {
      _instance = Router._internal();
    }
    return _instance;
  }

  init(NavigatorState navigatorState) {
    if (initialised) {
      return null;
    }
    _navigatorState = navigatorState;
    initialised = true;
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
