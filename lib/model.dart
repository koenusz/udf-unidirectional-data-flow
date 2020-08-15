class Model {
  static Map<Type, Model> _instances = {};

  static Model modelOf(Type type) {
    if (!_instances.containsKey(type)) {
      throw Exception("no instance of $type");
    }
    return _instances[type];
  }

  Model() {
    _instances[this.runtimeType] = this;
  }
}
