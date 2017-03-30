// Copyright (c) 2017, Matthew Barbour. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:version/version.dart';

main() {
  Version currentVersion = new Version(1,0,3);
  Version latestVersion = Version.parse("2.1.0");

  if(latestVersion>currentVersion) {
    print("Update is available");
  }
}
