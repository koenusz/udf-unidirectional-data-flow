import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:developer' as developer;

abstract class StateProvider<T> with ChangeNotifier {
  logger(String msg) {
    developer.log(msg, name: this.runtimeType.toString());
  }

  logError(String msg, Object error) {
    developer.log(msg, name: this.runtimeType.toString(), error: error);
  }

  static Map<Type, StateProvider> _instances = {};

  static StateProvider instance(Type type) =>
      _instances[type] ??
      (throw "No instance of type $type, make sure you create the StateProvider object before calling this method");

  bool _initialised = false;

  bool _resolving = false;

  Type modelType<T>() => T;

  T _model;

  T model() => _model;

  final Queue<Message> _messages = Queue();

  @protected
  StateProvider(T model) {
    _instances[this.runtimeType] = this;
    _model = model;
  }

  StateProvider<T> initMsg(Message msg) {
    if (!_initialised) {
      _initialised = true;
      return this.receive(msg);
    } else {
      return this;
    }
  }

  StateProvider<T> receive(Message msg) {
    logger("receiving: $msg");
    _messages.add(msg);
    _startResolving();
    return this;
  }

  StateProvider<T> sendWhenCompletes<FT>(Future<FT> future, Function handle, {String errorMessage}) {
    future.then(handle).catchError((error) => logError(errorMessage ?? "future failed", error));
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
    _model = msgToResolve.handle(this, msgToResolve, _model);
  }
}

abstract class Message<T, M extends Message<T, M>> {
  Type modelType<T>() => T;

  T handle(StateProvider<T> provider, M msg, T model);
}
