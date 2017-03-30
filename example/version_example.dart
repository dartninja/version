// Copyright (c) 2017, Matthew Barbour. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

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
