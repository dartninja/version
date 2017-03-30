// Copyright (c) 2017, Matthew Barbour. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Provides version objects to enforce conformance to the Semantic Versioning 2.0 spec. The spec can be read at http://semver.org/
library version;

class Version {
  static final RegExp _versionRegex =
      new RegExp(r"^([\d\.]+)(\-([0-9A-Za-z\-\.]+))?(\+([0-9A-Za-z\-\.]+))?$");

  /// The major number of the version, incremented when making breaking changes.
  final int major;

  /// The minor number of the version, incremented when adding new functionality in a backwards-compatible manner.
  final int minor;

  /// The patch number of the version, incremented when making backwards-compatible bug fixes.
  final int patch;

  /// Build information relevant to the version. Does not contribute to sorting.
  final String build;

  final List<String> _preRelease;

  /// Creates a new instance of [Version].
  ///
  /// [major], [minor], and [patch] are all required, all must be greater than 0 and not null, and at least one must be greater than 0.
  /// [preRelease] is optional, but if specified must be a [List] of [String] and must not be null.
  /// [build] is optional, but if specified must be a [String]. must contain only , and must not be null.
  /// Throes an [ArgumentError] if any of these conditions are violated.
  Version(this.major, this.minor, this.patch,
      {List<String> preRelease: const <String>[], this.build: ""})
      : _preRelease = preRelease {
    if (this.major == null) throw new ArgumentError("major must not be null");
    if (this.minor == null) throw new ArgumentError("minor must not be null");
    if (this.patch == null) throw new ArgumentError("patch must not be null");
    if (this._preRelease == null)
      throw new ArgumentError("preRelease must not be null");
    if (this.build == null) throw new ArgumentError("build must not be null");

    if (major < 0 || minor < 0 || patch < 0) {
      throw new ArgumentError("Version numbers must be greater than 0");
    }
    if (major == 0 && minor == 0 && patch == 0) {
      throw new ArgumentError(
          "At least one component of the version number must be greater than 0");
    }
  }

  @override
  int get hashCode {
    int hash = 1;
    hash = hash * 17 + major;
    hash = hash * 23 + minor;
    hash = hash * 13 + patch;
    // TODO: hash up the other version elements
    return hash;
  }

  /// Pre-release information segments.
  List<String> get preRelease => new List<String>.from(_preRelease);

  bool operator <(dynamic o) => o is Version && _compare(this, o) < 0;

  bool operator <=(dynamic o) => o is Version && _compare(this, o) <= 0;

  @override
  bool operator ==(dynamic o) => o is Version && _compare(this, o) == 0;

  bool operator >(dynamic o) => o is Version && _compare(this, o) > 0;

  bool operator >=(dynamic o) => o is Version && _compare(this, o) >= 0;

  /// Increments the [major] version number.
  ///
  /// Also resets the [minor] and [patch] numbers to 0, and clears the [build] and [preRelease] information.
  Version incrementMajor() => new Version(this.major + 1, 0, 0);
  /// Increments the [minor] version number.
  ///
  /// Also resets the [patch] number to 0, and clears the [build] and [preRelease] information.
  Version incrementMinor() => new Version(this.major, this.minor + 1, 0);
  /// Increments the [patch] version number.
  ///
  /// Also clears the [build] and [preRelease] information.
  Version incrementPatch() =>
      new Version(this.major, this.minor, this.patch + 1);

  @override
  String toString() {
    final StringBuffer output = new StringBuffer("$major.$minor.$patch");
    if (_preRelease.isNotEmpty) {
      output.write("-${_preRelease.join('.')}");
    }
    if (build != null && build.trim().length > 0) {
      output.write("+${build.trim()}");
    }
    return output.toString();
  }

  static bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (dynamic e) => null) != null;
  }

  /// Creates a [Version] instance from a string.
  ///
  /// The string must conform to the specification at http://semver.org/
  /// Throws [FormatException] if the string is empty or does not conform to the spec.
  static Version parse(String versionString) {
    if (versionString == null || versionString.trim().length == 0)
      throw new FormatException("Cannot parse empty string into version");

    if (!_versionRegex.hasMatch(versionString))
      throw new FormatException("Not a properly formatted version string");

    final Match m = _versionRegex.firstMatch(versionString);
    final String version = m.group(1);

    int major, minor, patch;
    final List<String> parts = version.split(".");
    major = int.parse(parts[0]);
    if (parts.length > 1) {
      minor = int.parse(parts[1]);
      if (parts.length > 2) {
        patch = int.parse(parts[2]);
      }
    }

    final String preReleaseString = m.group(3) ?? "";
    List<String> preReleaseList = <String>[];
    if (preReleaseString.trim().length > 0)
      preReleaseList = preReleaseString.split(".");

    final String build = m.group(5) ?? "";

    return new Version(major ?? 0, minor ?? 0, patch ?? 0,
        build: build, preRelease: preReleaseList);
  }

  static int _compare(Version a, Version b) {
    if (a.major > b.major) return 1;
    if (a.major < b.major) return -1;

    if (a.minor > b.minor) return 1;
    if (a.minor < b.minor) return -1;

    if (a.patch > b.patch) return 1;
    if (a.patch < b.patch) return -1;

    if (a.preRelease.isEmpty) {
      if (b.preRelease.isEmpty) {
        return 0;
      } else {
        return 1;
      }
    } else if (b.preRelease.isEmpty) {
      return -1;
    } else {
      int preReleaseMax = a.preRelease.length;
      if (b.preRelease.length > a.preRelease.length) {
        preReleaseMax = b.preRelease.length;
      }

      for (int i = 0; i < preReleaseMax; i++) {
        if (b.preRelease.length <= i) {
          return 1;
        } else if (a.preRelease.length <= i) {
          return -1;
        }

        if (a.preRelease[i] == b.preRelease[i]) continue;

        final bool aNumeric = _isNumeric(a.preRelease[i]);
        final bool bNumeric = _isNumeric(b.preRelease[i]);

        if (aNumeric && bNumeric) {
          final double aNumber = double.parse(a.preRelease[i]);
          final double bNumber = double.parse(b.preRelease[i]);
          if (aNumber > bNumber) {
            return 1;
          } else {
            return -1;
          }
        } else if (bNumeric) {
          return 1;
        } else if (aNumeric) {
          return -1;
        } else {
          return a.preRelease[i].compareTo(b.preRelease[i]);
        }
      }
    }
    return 0;
  }
}
