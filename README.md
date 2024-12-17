# Flutter JSONata Package

A Flutter package that provides JSONata query language support for data transformation and querying.

## Features

- Execute JSONata queries on JSON data
- Transform and filter JSON data
- Supports complex querying operations
- Custom function registration
- Error handling and validation
- Platform support for both Android and iOS

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_jsonata: ^1.0.0
```

### Android Setup

1. Add the JitPack repository to your `android/build.gradle` file:

```gradle
allprojects {
    repositories {
        ...
        maven { url 'https://jitpack.io' }
    }
}
```

2. For release configuration, update your `android/app/build.gradle` file's `buildTypes` section:

```gradle
buildTypes {
    release {
        minifyEnabled true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
}
```

2. Create a file named `proguard-rules.pro` in the `android/app` directory and add the following content:

```proguard
#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class de.prosiebensat1digital.** { *; }
```

## Usage

### Basic Usage

```dart
import 'package:flutter_jsonata/flutter_jsonata.dart';

void main() async {
  // Initialize Jsonata
  final jsonata = Jsonata(data: '{"name": "John", "age": 30}');
  
  // Simple property access
  final result = await jsonata.evaluate(expression: r'$.name');
  print(result.data); // Output: John
  
  // Don't forget to dispose
  jsonata.dispose();
}
```

### Advanced Querying Examples

#### Array Filtering
```dart
final jsonata = Jsonata(data: '[1, 2, 3, 4, 5]');
final result = await jsonata.evaluate(expression: r'$[$ >= 3]');
// Result: [3, 4, 5]
```

#### Object Transformation
```dart
final jsonata = Jsonata(data: '''
{
  "firstName": "John",
  "lastName": "Doe",
  "age": 30
}
''');

final result = await jsonata.evaluate(expression: r'''
{
  "fullName": $.firstName & " " & $.lastName,
  "isAdult": $.age >= 18
}
''');
// Result: {"fullName": "John Doe", "isAdult": true}
```

#### Array Mapping
```dart
final jsonata = Jsonata(data: '''
{
  "numbers": [1, 2, 3, 4, 5]
}
''');

final result = await jsonata.evaluate(expression: r'$.numbers.(10 * $)');
// Result: [10, 20, 30, 40, 50]
```

### Error Handling

```dart
final jsonata = Jsonata(data: '{"name": "John"}');
final result = await jsonata.evaluate(expression: r'$.age');

if (result.isError) {
  print('Error: ${result.error}');
} else {
  print('Result: ${result.data}');
}
```

### Expression Validation

```dart
final jsonata = Jsonata();
final isValid = await jsonata.validateExpression(r'$.name');
print(isValid); // true or false
```

### Custom Functions

```dart
final jsonata = Jsonata(
  data: '{"numbers": [1, 2, 3, 4, 5]}',
  functions: {
    'mySum': '''
      function(array) {
        return array.reduce((acc, val) => acc + val, 0);
      }
    '''
  },
);

final result = await jsonata.evaluate(expression: r'$sum($.numbers)');
// Result: 15
```

## License

This package is available under the MIT License.