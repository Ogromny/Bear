# Bear
A simple web framework in Dart

## Features
* GET, POST, PATCH, PUT, DELETE Http methods
* Variable parameters 
* Middlewares

## Installation
> add in your pubspec.yaml
```yaml
dependencies:
  bear: any
```

## Usage
```dart
final bear = Bear();

bear.get("/", (BearContext c) {
  c.response
    ..write("Bear rocks!")
    ..close();
}
...

bear.listen();
```

## Documentation
https://ogromny.github.io/Bear/bear/bear-library.html

## Roadmap
#### 0.4
- [x] Total rewrite

#### 0.3
- [x] Static files support

#### 0.2
- [x] MimeTypes
- [x] Middlewares

#### 0.1
- [x] GET, POST, PATCH, PUT, DELETE
- [x] variable parameters

## Contact
In *French* or in *English*
> ogromnycoding@gmail.com
