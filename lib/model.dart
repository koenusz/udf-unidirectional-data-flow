class Model {
  static Map<Type, Model> _instances = {};

  Model._internal();

  factory Model(Type type) {
    if (_instances.containsKey(type)) {
      return _instances[type];
    } else {
      var model = Model._internal();
      _instances[model.runtimeType] = model;
      return model;
    }
  }
}
