import 'package:flutter/widgets.dart';
import 'package:udf/stateProvider.dart';

class ViewNotifier<T extends StateProvider> extends InheritedNotifier<StateProvider> {
  ViewNotifier(
    T stateProvider,
    Widget child,
  ) : super(notifier: stateProvider, child: child);

  static T of<T extends StateProvider>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ViewNotifier<T>>()?.notifier as T;
  }
}
