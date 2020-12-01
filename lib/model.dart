abstract class Model<T extends Model<T>> {
  static Map<Type, Model> _instances = {};

  static modelOf(Type type) {
    if (_instances.containsKey(type)) {
      return _instances[type];
    } else {
      throw Exception("model if type: $type is null");
    }
  }

  /// Updating the model requires creating new instances of it since it should be immutable by design. Therefore the
  /// Model needs a generative constructor and not a factory.
  Model() {
    _instances[T.runtimeType] = this;
  }
}
