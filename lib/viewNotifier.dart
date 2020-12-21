import 'package:flutter/widgets.dart';
import 'package:udf/stateProvider.dart';

class ViewNotifier<T extends StateProvider> extends InheritedNotifier<StateProvider> {
  ViewNotifier({
    Key key,
    T stateProvider,
    @required Widget child,
  }) : super(key: key, notifier: stateProvider, child: child);
  
}
