import 'dart:collection';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:udf/model.dart';

import 'message.dart';

abstract class StateProvider<M> with ChangeNotifier {
  logger(String msg) {
    developer.log(
      msg,
      name: this.runtimeType.toString() + "::" + this.rand.toString(),
    );
  }

  logError(String msg, Object error, {StackTrace? stacktrace}) {
    developer.log(msg,
        name: this.runtimeType.toString() + "::" + this.rand.toString(), error: error, stackTrace: stacktrace);
  }

  final rand = Random().nextInt(10000);

  static Map<Type, StateProvider> _instances = {};

  static T providerOf<T extends StateProvider>(Type type) {
    if (type == StateProvider) {
      throw "It is not possible to provide an abstract StateProvider, "
          "make sure to properly substitute the generic type for a subtype like: "
          "providerOf<MyModelProvider>(MyModelProvider) ";
    }
    return _instances[type] as T? ??
        (throw "No instance of type $type, make sure you create the StateProvider object before calling this method");
  }

  static M model<M extends Model<M>, T extends StateProvider<M>>() => providerOf<T>(T)._model;

  static navigateTo<T extends StateProvider>(String routeName) => providerOf<T>(T)._navigateTo(routeName);

  _navigateTo(String routeName) {
    this._receive(NavigateToMessage<M>(routeName));
  }

  static StateProvider<M> send<M extends Model<M>, T extends StateProvider<M>>(Message<M> msg) =>
      providerOf<T>(T)._receive(msg);

  StateProvider<M> _receive(Message<M> msg) {
    logger("receiving: $msg");
    _messages.add(msg);
    _startResolving();
    return this;
  }

  bool _resolving = false;

  M _model;

  M _internalModel() => _model;

  final Queue<Message> _messages = Queue();

  StateProvider(this._model) {
    _instances[this.runtimeType] = this;
  }

  static sendWhenCompletes<FT, M extends Model<M>, T extends StateProvider<M>>(
    Future<FT> future,
    Message<M> Function(FT p1) onSuccess, {
    String? errMsg,
    Message<M> Function(String? msg)? onFailure,
  }) {
    var x = providerOf<T>(T)._receiveWhenCompletes(
      future,
      onSuccess,
      errMsg: errMsg,
      onFailure: onFailure,
    );
    return x;
  }

  StateProvider<M> _receiveWhenCompletes<FT>(
    Future<FT> future,
    Message<M> Function(FT) onSuccess, {
    String? errMsg,
    Message<M> Function(String? msg)? onFailure,
  }) {
    handle(input) => this._receive(onSuccess(input));

    future.then(handle).catchError(
      (error, sTrace) {
        String msg = error.runtimeType == String
            ? error
            : errMsg ?? "there was no error response, implement errMsg to provide a default error message";

        if (onFailure != null) {
          this._receive(onFailure(msg));
        } else {
          logError(errMsg ?? "future failed, implement onFailure to handle the error", error, stacktrace: sTrace);
          throw error;
        }
        return this;
      },
    );
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
    // logger("resolving: $msgToResolve");
    _messages.removeFirst();
    try {
      _model = msgToResolve.handle(_model);
      // logger("handling done");
    } catch (e) {
      logError("handling error", e);
    }
  }

  void dispose() {
    super.dispose();
  }
}

class ViewNotifier<T extends StateProvider> extends InheritedNotifier<StateProvider> {
  ViewNotifier(
    T stateProvider,
    Widget child,
  ) : super(notifier: stateProvider, child: child);

  static M model<M extends Model<M>, T extends StateProvider<M>>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ViewNotifier<T>>()!.notifier!._internalModel();
  }
}
