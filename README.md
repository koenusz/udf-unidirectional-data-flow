# udf

A package that enables you to use a Unidirectional Data Flow, inspired by the Elm and Erlang/otp
languages and platform.

## setting up

It is important to initialise your providers and model before you run your app, otherwise there
might be nullpointers.
```
    void main() {
      initAppState();
      runApp(ScannerApp());
    }

    void initAppState() {
      LoginModelProvider(LoginModel.init());
      MenuModelProvider(MenuModel.init());
    }
```

## Router
The router allows you to navigate between screens. All the views require a routeName string to
identify them for the router. To enable the routing functionality you need to place a widget in the
widget tree that enables the routing.

example:
```
    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
            title: 'My amazing app',
            home: RouterWidget(),
            routes: {
              Login.routeName: (context) => Login(), //all your views need to be added here
              Menu.routeName: (context) => Menu(),
            });
      }
    }

    class RouterWidget extends StatelessWidget {
      final Router router = Router();

      RouterWidget({
        Key key,
      }) : super(key: key);

      @override
      Widget build(BuildContext context) {
        router.init(Navigator.of(context));
        return Login(); //return the view where you want to start
      }
    }
```

This allows you to navigate as such in your app.

example:
```
    RaisedButton(
      child: Text("Login"),
      onPressed: () => {
        Router().navigateTo(routeName: Menu.routeName),
      },
    ),
```

The router is cached, so calling the constructor a second time will retrieve the same instance that
you created the first time.

## Package structure

### Model
Immutable class that contains your data. Make sure to use final keyword to make sure your data
stays consistent. Updating the Model data is by creating a new copy of it with the copyWith method.
Data consistency is one of the most important things to prevent bugs in your app. The type system is
a good tool to make certain bugs impossible to occur. Make sure as many inconsistent states are
disallowed in your app by using the type system smartly. (Make impossible states impossible)
[https://www.youtube.com/watch?v=IcgmSRJHu_8&ab_channel=elm-conf]

example:
```
    class LoginModel extends Model<LoginModel> {
      final String email;
      final String password;

      LoginModel._(this.email, this.password);

      static LoginModel init() {
        return LoginModel._("", "");
      }

      LoginModel copyWith({String email, String password}) {
        return LoginModel._(email ?? this.email, password ?? this.password);
      }

      @override
      String toString() {
        return 'LoginModel{email: $email, password: $password}';
      }
    }
```
bonus: adding a proper toString override will make debugging your app a lot easier.

### ViewNotifier
Changes made to the model most of the time require your app to render these changes. To enable this
you need to place a viewNotifier in your widget tree.

```
  @override
  Widget build(BuildContext context) {
    return ViewNotifier<MenuModelProvider>(
      stateProvider: StateProvider.providerOf(MenuModelProvider),
      child: MenuView(),
    );
  }
```

This enables the using data in your views like this:

```
    class MenuView extends StatelessWidget {
      @override
      Widget build(BuildContext context) {

        var provider = StateProvider.providerOf(MenuModelProvider);
        MenuModel model = provider.model();

        return Scaffold(
          appBar: AppBar(
            title: Text("menuView"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(model.user.email),
                RaisedButton(child: Text("Menu"), onPressed: () => {}),
              ],
            ),
          ),
        );
      }
    }
```


### Message
An Immutable class that is the relay for any of the app's functionality. Its handle method defines
how the app state is updated.

example:
```
    class EmailChangedMessage extends Message<LoginModel, EmailChangedMessage> {

      final String email;

      EmailChangedMessage(this.email);

      @override
      LoginModel handle(StateProvider<LoginModel> provider, EmailChangedMessage msg, LoginModel model) {
        return model.copyWith(email: msg.email);
      }

      @override
      String toString() {
        return 'EmailChangedMessage{email: $email}';
      }
    }
```
bonus: adding a proper toString override will make debugging your app a lot easier.

### StateProvider
Managing class that handles Messages and updates your Model.

There is not much you need to do to instantiate the provider. It basically only needs to know its
own name and what model it will use.

```
    class LoginModelProvider extends StateProvider<LoginModel> {
      LoginModelProvider(LoginModel model) : super(model);
    }
```

## Sending messages

### receive
This is done by calling the receive method on the stateProvider. The receive method takes a Message
object and executes the handle method on the message data provided. Messages are resolved in the
order in which they are received.

example:
```
    class LoginView extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        var provider = StateProvider.providerOf(LoginModelProvider);
        var model = provider.model();

        return Scaffold(
          appBar: AppBar(
            title: Text("Login"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyWidgets.textField(
                  "email",
                  "enter your email",
                  (email) => {provider.receive(EmailChangedMessage(email))},
                ),
                RaisedButton(
                  child: Text("Login"),
                  onPressed: () => {
                    Router().navigateTo(routeName: Menu.routeName),
                  },
                ),
              ],
            ),
          ),
        );
      }
    }
```

bonus:
```
  static Widget textField(String label, String hint, ValueChanged<String> onChanged) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: TextField(
          decoration: InputDecoration(labelText: label, hintText: hint, fillColor: Colors.white), onChanged: onChanged),
    );
  }
```

### sendWhenCompletes
Sometimes you would like to trigger something in your app on a reaction to some stimulus. For
instance when you receive a response from an Api. This method handles this usecase by executing the
future (1st argument) and afterwards either sending a message to the provider or logging an
(Optional) Message.

example:
```
    stateProvider.sendWhenCompletes(
      API.getEmployees(),
      (employees) => EmployeesReceivedMessage(employees),
      errorMessage: "fetching the employees failed",
    );
```

### passing data between views

Each view should have exactly one model and one provider related to that view. Passing data between
view is as simple as retrieving the provider related to the view that you want to pass data to and
sending it a message. This will never result in re-rendering your current view because the other
provider is not added to the notifier in your current widget tree.

```
    class MenuView extends StatelessWidget {
      @override
      Widget build(BuildContext context) {

        ...

        var provider = StateProvider.providerOf(PaymentModelProvider);
        provider.receive(PaymentMessage(amount: 10, currency: EURO));

        ...
      }
    }
```