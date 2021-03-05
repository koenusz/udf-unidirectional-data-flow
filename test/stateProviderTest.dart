import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:udf/message.dart';
import 'package:udf/model.dart';
import 'package:udf/stateProvider.dart';
import 'package:udf/udfRouter.dart';

void main() {
  test("handle messages", () async {
    TestModelProvider.init();

    TestModelProvider.send(AddTestValue(3));
    var model = TestModelProvider.model();
    expect(model.value, equals(8));

    TestModelProvider.send(SubtractTestValue(2));
    model = TestModelProvider.model();
    expect(model.value, equals(6));
  });

  test("handle stacked messages ", () async {
    TestModelProvider.init();

    TestModelProvider.send(Stacked());
    var model = TestModelProvider.model();
    expect(model.value, equals(10));
  });

  Future<int> delayedInt(int value, int duration) async {
    await Future.delayed(Duration(seconds: duration));
    return value;
  }

  test("sendWhenCompletes future returns success", () async {
    TestModelProvider.init();
    TestModelProvider.sendWhenCompletes<int>(
      delayedInt(1, 0),
      (value) => SubtractTestValue(value),
    );
    await Future.delayed(Duration(seconds: 1));
    var model = TestModelProvider.model();
    expect(model.value, equals(4));
  });

  Future<int> delayedError(int value, int duration) async {
    print('Delay error for Future $value');
    throw Exception('Logout failed: user ID is invalid');
  }

  test("sendWhenCompletes future returns error", () async {
    TestModelProvider.init();
    TestModelProvider.sendWhenCompletes<dynamic>(
      delayedError(1, 0),
      (value) => SubtractTestValue(value),
      logMsg: "fail",
      onFailure: () => SubtractTestValue(2),
    );
    await Future.delayed(Duration(seconds: 1));
    var model = TestModelProvider.model();
    expect(model.value, equals(3));
  });

  test("handle stacked in the right order ", () async {
    TestModelProvider.init();

    TestModelProvider.send(StackedOrder());
    var model = TestModelProvider.model();
    expect(model.value, equals(27));
  });

  test("test navigation ", () async {
    TestModelProvider.init();

    RouterMock routerMock = RouterMock.mockRouter();

    TestModelProvider.navigate();
    verify(routerMock.navigateTo("routeName")).called(1);
  });
}

class TestModelProvider extends StateProvider<TestModel> {
  @protected
  TestModelProvider(TestModel model) : super(model);

  static send(Message<TestModel> msg) => StateProvider.send<TestModel, TestModelProvider>(msg);

  static sendWhenCompletes<FT>(
    Future<FT> future,
    Message<TestModel> Function(FT p1) onSuccess, {
    String? logMsg,
    Message<TestModel> Function()? onFailure,
  }) =>
      StateProvider.sendWhenCompletes<FT, TestModel, TestModelProvider>(
        future,
        onSuccess,
        logMsg: logMsg,
        onFailure: onFailure,
      );

  static navigate() => StateProvider.navigateTo<TestModelProvider>("routeName");

  static TestModel model() => StateProvider.model<TestModel, TestModelProvider>();

  factory TestModelProvider.init() => TestModelProvider(TestModel(5));
}

class TestModel extends Model<TestModel> {
  final int value;

  TestModel(this.value);

  TestModel copyWith({int? value}) {
    return TestModel(
      value ?? this.value,
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
  handle(model) {
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

class RouterMock extends Mock implements UDFRouter {
  static RouterMock mockRouter() {
    RouterMock mock = RouterMock();
    UDFRouter.mock(mock);
    return mock;
  }
}
