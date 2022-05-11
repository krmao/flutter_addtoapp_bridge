## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/), a specialized package that includes platform-specific implementation code for Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.

## [Create Flutter Plugin Project](https://docs.flutter.dev/development/packages-and-plugins/developing-packages#step-1-create-the-package-1)

```
flutter create --org com.codesdancing.flutter.addtoapp.bridge --template=plugin --platforms=android,ios -a kotlin -i objc flutter_addtoapp_bridge=
```

## Open example/android or example/ios

> build example flutter before open example/ios, don't just open flutter_addtoapp_bridge/android or flutter_addtoapp_bridge/ios.

```
cd example
flutter build ios --no-codesign -v
```

## Waiting for another flutter command to release the startup lock..

```
killall -9 dart
```

## Format dart code

```shell
flutter format .
```

## Flutter doc

```shell
~/fvm/versions/2.13.0-0.3.pre/bin/cache/dart-sdk/bin/resources/dartdoc
```

## Publish

```shell
flutter pub publish --dry-run
flutter pub publish
```