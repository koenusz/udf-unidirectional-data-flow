import 'package:udf/router.dart';

abstract class Message<T> {
  T handle(T model);
}

class NavigateToMessage<T> extends Message<T> {
  final String _routeName;

  NavigateToMessage(this._routeName);

  @override
  handle(model) {
    Router().navigateTo(_routeName);
    return model;
  }

  @override
  String toString() {
    return 'NavigateToMessage{_routeName: $_routeName}';
  }
}

class NavigateBackMessage<T> extends Message<T> {
  @override
  handle(model) {
    Router().back();
    return model;
  }
}

class RemoveAllAndNavigateToMessage<T> extends Message<T> {
  final String _routeName;

  RemoveAllAndNavigateToMessage(this._routeName);

  @override
  handle(model) {
    Router().removeAllAndNavigateTo(_routeName);
    return model;
  }

  @override
  String toString() {
    return 'RemoveAllAndNavigateToMessage{_routeName: $_routeName}';
  }
}
