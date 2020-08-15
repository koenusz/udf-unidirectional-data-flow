import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:udf/stateProvider.dart';

void main() {
  test("handle messages", () async {
    var provider = TestModelProvider.init();

    provider.receive(AddTestValue(3));
    var model = provider.get();
    expect(model.value, equals(8));

    provider.receive(SubstractTestValue(2));
    model = provider.get();
    expect(model.value, equals(6));
  });

  test("handle stacked messages ", () async {
    var provider = TestModelProvider.init();

    provider.receive(Stacked());
    var model = provider.get();
    expect(model.value, equals(10));
    
  });

  test("handle stacked in the right order ", () async {
    var provider = TestModelProvider.init();

    provider.receive(StackedOrder());
    var model = provider.get();
    expect(model.value, equals(27));

  });
}

class TestModelProvider extends StateProvider<TestModel> {
  @protected
  TestModelProvider(TestModel model) : super(model);

  factory TestModelProvider.init() => TestModelProvider(TestModel(value: 5));
}

class TestModel {
  final int value;

  TestModel({this.value});

  TestModel copyWith({int value}) {
    return TestModel(
      value: value ?? this.value,
    );
  }
}

class Stacked extends Message<TestModel, Stacked> {
  Stacked();

  @override
  handle(StateProvider provider, Stacked msg, model) {
    provider.receive(AddTestValue(1));
    provider.receive(AddTestValue(1));
    provider.receive(AddTestValue(1));
    provider.receive(AddTestValue(1));
    provider.receive(AddTestValue(1));

    return model;
  }
}

class StackedOrder extends Message<TestModel, StackedOrder> {
  StackedOrder();

  @override
  handle(StateProvider provider, StackedOrder msg, model) {
    provider.receive(AddTestValue(1));
    provider.receive(TimesValue(2));
    provider.receive(AddTestValue(1));
    provider.receive(TimesValue(2));
    provider.receive(AddTestValue(1));

    return model;
  }
}

class TimesValue extends Message<TestModel, TimesValue> {
  final int value;

  TimesValue(this.value);

  @override
  handle(StateProvider provider, TimesValue msg, model) {
    int newval = model.value * msg.value;
    return model.copyWith(value: newval);
  }
}

class AddTestValue extends Message<TestModel, AddTestValue> {
  final int value;

  AddTestValue(this.value);

  @override
  handle(StateProvider provider, AddTestValue msg, model) {
    int newval = model.value + msg.value;
    return model.copyWith(value: newval);
  }
}

class SubstractTestValue extends Message<TestModel, SubstractTestValue> {
  final int value;

  SubstractTestValue(this.value);

  @override
  handle(StateProvider provider, SubstractTestValue msg, model) {
    int newval = model.value - msg.value;
    return model.copyWith(value: newval);
  }
}
