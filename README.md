# version
[![version 1.0.2](https://img.shields.io/badge/pub-1.0.2-brightgreen.svg)](https://pub.dartlang.org/packages/version)
[![build status](https://api.travis-ci.org/dartalog/version_dart.svg)](https://travis-ci.org/dartalog/version_dart)

A dart library providing a Version object for comparing and incrementing version numbers in compliance with the Semantic Versioning spec at http://semver.org/

# Installation
In your `pubspec.yaml`:

```yaml
dependencies:
  version: ^1.0.0
```

## Usage

A simple usage example:

    import 'package:version/version.dart';
    
    void main() {
      Version currentVersion = new Version(1, 0, 3);
      Version latestVersion = Version.parse("2.1.0");
    
      if (latestVersion > currentVersion) {
        print("Update is available");
      }
    
      Version betaVersion = new Version(2, 1, 0, preRelease: ["beta"]);
      // Note: this test will return false, as pre-release versions are considered
      // lesser then a non-pre-release version that otherwise has the same numbers.
      if (betaVersion > latestVersion) {
        print("More recent beta available");
      }
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/dartalog/version_dart/issues
