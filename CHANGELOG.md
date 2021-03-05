## [0.0.1] - 15-08-2020

* Model class to hold state
* StateProvider that can update your model
* Router to do navigation

## [0.0.2] - 30-08-2020

* ViewNotifier to remove the dependency on the provider package


## [0.0.3] - 30-08-2020

* Router removed arguments
* Router improved with factory method

## [0.0.4] - 30-08-2020

* Router construction fix

## [0.0.5] - 30-11-2020

* Model construction with a factory method

## [0.0.6] - 30-11-2020

* Model uses generic type

## [0.0.6] - 30-11-2020

* Model needs a generative constructor

## [0.0.7] - 30-11-2020

* Model is abstract

## [0.0.8] - 21-12-2020

* make sendWhenCompletes more type safe
* removed viewNotifier.of - use StateProvider.providerOf
* added init abstract method on the model
* added copyWith abstract method on the model
* added a bit more documentation

## [0.0.9] - 02-01-2021

* removed viewNotifier.of - The ViewNotifier needs to be used otherwise the screen does not get
    redrawn.

## [0.0.10] - 12-01-2021

* added method to the router to reset the navigation stack.

## [0.0.11] - 18-01-2021

* simplified handling method.
* updated sendWhenCompletes with error message option
* simplified/improved typing of the message
* updated the docs to reflect this simplification.

## [0.0.12] - 23-01-2021

* added navigation method tot he StateProvider to standardise the way navigation is done.

## [0.0.13] - 23-01-2021

* added navigation back method to the StateProvider.
* removeAllAndNavigateTo added for logging out.

## [0.0.14] - 5-02-2021

* bug fix StateProvider.sendWhenCompletes: when the onFailure argument is null do not try to send a message.

## [0.0.15] - 5-03-2021

* upgrade to dart 2.12, use null safety.
* removed the initMsg, model is initialised through the StateProvider constructor.

## [0.0.16] - 5-03-2021

* key is not needed in ViewNotifier

## [0.0.17] - 5-03-2021

* StateProvider, providerOf needs to be more strict with its typing

## [0.0.18] - 5-03-2021

* StateProvider, providerOf needs to be more strict with its typing
* Refactored the VIewNotifier to provide the model.
* added test for the viewNotifier

## [0.0.19] - 5-03-2021

* changed name sendWhenCompletes => receiveWhenCompletes for consistency.

## [0.0.20] - 5-03-2021

* removed unnecessary cast
* added a test for navigate
* refactored the static functions so the implementations require
* added test for sendWhenCompletes