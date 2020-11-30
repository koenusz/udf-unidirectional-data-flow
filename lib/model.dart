class Model<T extends Model<T>> {
  static Map<Type, Model> _instances = {};

  Model._internal();

  factory Model() {
    if (_instances.containsKey(T.runtimeType)) {
      return _instances[T.runtimeType];
    } else {
      var model = Model<T>._internal();
      _instances[model.runtimeType] = model;
      return model;
    }
  }
}
