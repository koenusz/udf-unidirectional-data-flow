import 'package:udf/udfrouter.dart';

abstract class Message<T> {
  T handle(T model);
}

class NavigateToMessage<T> extends Message<T> {
  final String _routeName;

  NavigateToMessage(this._routeName);

  @override
  handle(model) {
    UDFRouter().navigateTo(_routeName);
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
    UDFRouter().back();
    return model;
  }
}

class RemoveAllAndNavigateToMessage<T> extends Message<T> {
  final String _routeName;

  RemoveAllAndNavigateToMessage(this._routeName);

  @override
  handle(model) {
    UDFRouter().removeAllAndNavigateTo(_routeName);
    return model;
  }

  @override
  String toString() {
    return 'RemoveAllAndNavigateToMessage{_routeName: $_routeName}';
  }
}
