import 'package:flutter/widgets.dart';
import 'package:udf/stateProvider.dart';

class ViewNotifier<T extends StateProvider> extends InheritedNotifier<StateProvider> {
  ViewNotifier({
    Key key,
    T stateProvider,
    @required Widget child,
  }) : super(key: key, notifier: stateProvider, child: child);

  static T of<T extends StateProvider>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ViewNotifier<T>>().notifier;
  }
}
