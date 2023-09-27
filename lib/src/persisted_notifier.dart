// ignore_for_file: avoid_public_notifier_properties
import 'dart:convert';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../riverpod_offline.dart';

class PersistedNotifier<T extends Serializable> extends Notifier<T> {
  final String boxName;
  final T defaultState;
  final T Function(Map<String, dynamic> json) fromJson;

  PersistedNotifier({
    required this.boxName,
    required this.defaultState,
    required this.fromJson,
  }) {
    loadPersistedState().then((persistedState) {
      if (persistedState != null) {
        state = persistedState;
      }
    });
  }

  @override
  T build() {
    return defaultState;
  }

  @override
  set state(T value) {
    super.state = value;
    persistSate(value);
  }

  Future<void> persistSate(T value) async {
    EasyDebounce.debounce(
        '${boxName}_notifier', const Duration(milliseconds: 300), () async {
      final box = await Hive.openBox<String>(boxName);
      box.put(boxName, jsonEncode(value.toJson()));
    });
  }

  Future<T?> loadPersistedState() async {
    final box = await Hive.openBox<String>(boxName);
    final jsonString = box.get(boxName);
    if (jsonString != null) {
      return fromJson(jsonDecode(jsonString));
    }
    return null;
  }
}
