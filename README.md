# version

A dart library providing a Version object for comparing and incrementing version numbers in compliance with the Semantic Versioning spec at http://semver.org/

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
