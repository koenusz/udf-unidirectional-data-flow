import 'package:flutter/widgets.dart';
import 'package:udf/stateProvider.dart';
import 'model.dart';

class ViewNotifier<T extends StateProvider> extends InheritedNotifier<StateProvider> {
  ViewNotifier(
    T stateProvider,
    Widget child,
  ) : super(notifier: stateProvider, child: child);

  static M model<M extends Model<M>, T extends StateProvider<M>>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ViewNotifier<T>>()!.notifier!.model();
}
