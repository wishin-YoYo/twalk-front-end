import 'package:flutter/foundation.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:collection/collection.dart';

void main() async {
  var map1 = {
    'a': {
      'a': {'a': 1},
    },
  };
  var map2 = {
    'a': {
      'a': {'a': 1},
    },
  };
  print((DeepCollectionEquality().equals(map1, map2)));
}
