import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Router {
  logger(String msg) {
    developer.log(msg, name: 'router');
  }

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
      _instance = Router();
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

  void navigateTo({String routeName}) {
    logger("navigating to: $routeName");
    _navigatorState.pushNamed(routeName);
  }

  void back() {
    logger("popping of");
    _navigatorState.pop();
  }
}
