# JsonAta Flutter

## Instalation

```yaml
dependencies:
  flutter_js: 0.1.0+0
```

### Android

Add Android dependency `implementation "com.github.fast-development.android-js-runtimes:fastdev-jsruntimes-jsc:0.3.4"`

Change the minimum Android sdk version to 21 (or higher) in your `android/app/build.gradle` file.

```gradle
minSdkVersion 21
```

Setup of proguard to release builds: setup your android/app/proguard-rules.pro file
with the content bellow.

> Remember to merge with another configurations needed for
others plugins your app uses.

```proguard-rules.pro
#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class de.prosiebensat1digital.** { *; }
```

Also add these lines to your `android -> buildTypes -> release` section of android/app/build.gradle file:

```gradle
 minifyEnabled true
  useProguard true

  proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
```

## Usage

```dart
var jsonAta = JsonAta();
var result = await jsonAta.execute(
  expression: "$.name",
  jsonData: '{"name": "John Doe"}'
);
print(result); // Result: John Doe```
