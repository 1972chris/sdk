// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.9

import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'completion_test.dart' as completion;
import 'feature_computer_test.dart' as feature_computer;

void main() {
  defineReflectiveSuite(() {
    completion.main();
    feature_computer.main();
  }, name: 'dart');
}
