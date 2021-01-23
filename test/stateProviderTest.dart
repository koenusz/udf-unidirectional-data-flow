import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:udf/message.dart';
import 'package:udf/stateProvider.dart';

void main() {
  test("handle messages", () async {
    var provider = TestModelProvider.init();

    provider.receive(AddTestValue(3));
    var model = provider.model();
    expect(model.value, equals(8));

    provider.receive(SubtractTestValue(2));
    model = provider.model();
    expect(model.value, equals(6));
  });

  test("handle stacked messages ", () async {
    var provider = TestModelProvider.init();

    provider.receive(Stacked());
    var model = provider.model();
    expect(model.value, equals(10));
  });

  test("handle stacked in the right order ", () async {
    var provider = TestModelProvider.init();

    provider.receive(StackedOrder());
    var model = provider.model();
    expect(model.value, equals(27));
  });
}

class TestModelProvider extends StateProvider<TestModel> {
  @protected
  TestModelProvider(TestModel model) : super(model);

  static send(Message msg) => StateProvider.providerOf(TestModelProvider).receive(msg);

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

class Stacked extends Message<TestModel> {
  Stacked();

  @override
  handle(model) {
    TestModelProvider.send(AddTestValue(1));
    TestModelProvider.send(AddTestValue(1));
    TestModelProvider.send(AddTestValue(1));
    TestModelProvider.send(AddTestValue(1));
    TestModelProvider.send(AddTestValue(1));

    return model;
  }
}

class StackedOrder extends Message<TestModel> {
  StackedOrder();

  @override
  handle(model) {
    TestModelProvider.send(AddTestValue(1));
    TestModelProvider.send(TimesValue(2));
    TestModelProvider.send(AddTestValue(1));
    TestModelProvider.send(TimesValue(2));
    TestModelProvider.send(AddTestValue(1));

    return model;
  }
}

class TimesValue extends Message<TestModel> {
  final int value;

  TimesValue(this.value);

  @override
  handle(model) {
    int newVal = model.value * this.value;
    return model.copyWith(value: newVal);
  }
}

class AddTestValue extends Message<TestModel> {
  final int value;

  AddTestValue(this.value);

  @override
  handle( model) {
    int newVal = model.value + this.value;
    return model.copyWith(value: newVal);
  }
}

class SubtractTestValue extends Message<TestModel> {
  final int value;

  SubtractTestValue(this.value);

  @override
  handle(model) {
    int newVal = model.value - this.value;
    return model.copyWith(value: newVal);
  }
}
