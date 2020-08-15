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

  static Router instance() => _instance;

  static mock(routerMock) {
    if (kDebugMode) {
      _instance = routerMock;
    }
  }

  Router() {
    if (_instance != null) {
      throw Exception("there can be only one router");
    }
    _instance = this;
  }

  init(NavigatorState navigatorState) {
    if (initialised) {
      return null;
    }
    _navigatorState = navigatorState;
    initialised = true;
  }

  void navigateTo({String routeName, ScreenArguments arguments}) {
    logger("navigating to: $routeName");
    _navigatorState.pushNamed(routeName, arguments: arguments);
  }

  void back() {
    logger("popping of");
    _navigatorState.pop();
  }
}

abstract class ScreenArguments {}
