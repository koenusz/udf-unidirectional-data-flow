import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:udf/router.dart';

import 'message.dart';

abstract class StateProvider<T> with ChangeNotifier {
  logger(String msg) {
    developer.log(msg, name: this.runtimeType.toString() + "::" + this.rand.toString());
  }

  logError(String msg, Object error) {
    developer.log(msg, name: this.runtimeType.toString() + "::" + this.rand.toString(), error: error);
  }

  final rand = Random().nextInt(10000);

  static Map<Type, StateProvider> _instances = {};

  static StateProvider providerOf(Type type) =>
      _instances[type] ??
      (throw "No instance of type $type, make sure you create the StateProvider object before calling this method");

  navigateTo(String routeName) {
    this.receive(NavigateToMessage<T>(routeName));
  }

  bool _initialised = false;

  bool _resolving = false;

  T _model;

  T model() => _model;

  final Queue<Message> _messages = Queue();

  @protected
  StateProvider(T model) {
    _instances[this.runtimeType] = this;
    _model = model;
  }

  StateProvider<T> initMsg(Message<T> msg) {
    if (!_initialised) {
      _initialised = true;
      return this.receive(msg);
    } else {
      return this;
    }
  }

  StateProvider<T> receive(Message<T> msg) {
    logger("receiving: $msg");
    _messages.add(msg);
    _startResolving();
    return this;
  }

  StateProvider<T> sendWhenCompletes<FT>(Future<FT> future, Message<T> Function(FT) onSuccess,
      {String logMsg, Message<T> Function() onFailure}) {
    handle(input) => this.receive(onSuccess(input));
    future.then(handle).catchError((error) => {
          logError(logMsg ?? "future failed", error),
          if (onFailure != null) {this.receive(onFailure())},
        });
    return this;
  }

  void _startResolving() {
    if (_resolving) {
      return;
    } else {
      _resolving = true;
      while (_messages.isNotEmpty) {
        _resolveMessage();
      }
      notifyListeners();
      _resolving = false;
    }
  }

  void _resolveMessage() {
    var msgToResolve = _messages.first;
    logger("resolving: $msgToResolve");
    _messages.removeFirst();
    try {
      _model = msgToResolve.handle(_model);
      logger("handling done");
    } catch (e) {
      logError("handling error", e);
    }
  }
}
