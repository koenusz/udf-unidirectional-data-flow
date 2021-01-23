import 'package:udf/router.dart';

abstract class Message<T> {
  T handle(T model);
}

class NavigateToMessage<T> extends Message<T> {
  final String _routeName;

  NavigateToMessage(this._routeName);

  @override
  handle(model) {
    Router().navigateTo(routeName: _routeName);
    return model;
  }

  @override
  String toString() {
    return 'NavigateToMessage{_routeName: $_routeName}';
  }
}
