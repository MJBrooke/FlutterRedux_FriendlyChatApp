# FriendlyChatApp using Flutter_Redux

A version of the [Google Codelab 'Building Beautiful UI's with Flutter'](https://codelabs.developers.google.com/codelabs/flutter/#0) tutorial that uses:
* [Dart 2](https://www.dartlang.org/dart-2)
* [Redux](https://pub.dartlang.org/packages/redux#-readme-tab-) (3.0.0+ for Dart 2 support)
* [Flutter_Redux](https://pub.dartlang.org/packages/flutter_redux#-readme-tab-) (0.4.0+ for Dart 2 support)

The app represents a basic Chat UI that uses the latest Redux with Dart 2 for:
* Storing messages
* Creating new messages
* Displaying all messages

Additionally, it features a more complex Redux setup that a store with a single int, and Enums as actions.

This app shows you how to setup:
* Actions with payloads
* An immutable compound AppState object
* Multiple reducers combined together on a per-store variable basis

I created this because I couldn't find any complete examples of Redux 3.0.0 with Dart 2,
and I wanted to get a working example.

Others may find it useful when first learning the redux/flutter_redux libraries.
