import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:udf/stateProvider.dart';

import 'stateProviderTest.dart';

void main() {
  testWidgets("instantiate viewNotifier", (WidgetTester tester) async {
    TestModelProvider.init();

    await tester.pumpWidget(App());

    final firstFinder = find.text('5');
    expect(firstFinder, findsOneWidget);

    TestModelProvider.send(AddTestValue(3));
    await tester.pumpAndSettle();
    final secondFinder = find.text('8');
    expect(secondFinder, findsOneWidget);
  });
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Test());
  }
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewNotifier<TestModelProvider>(
      StateProvider.providerOf<TestModelProvider>(TestModelProvider),
      TestView(),
    );
  }
}

class TestView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = ViewNotifier.model<TestModel, TestModelProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: Center(
        child: Text("${model.value}"),
      ),
    );
  }
}
