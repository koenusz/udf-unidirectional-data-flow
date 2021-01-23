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

* removed viewNotifier.of - The viewnotifier needs to be used otherwise the screen does not get
    redrawn.

## [0.0.10] - 12-01-2021

* added method to the router to reset the navigation stack.

## [0.0.11] - 18-01-2021

* simplified handling method.
* updated sendWhenCompletes with error message option
* simplified/improved typing of the message
* updated the docs to reflect this simplification.

## [0.0.12] - 23-01-2021

* added navigation method tot he stateprovider to standardise the way navigation is done.

## [0.0.13] - 23-01-2021

* added navigation back method to the stateprovider.
* removeAllAndNavigateTo added for logging out.