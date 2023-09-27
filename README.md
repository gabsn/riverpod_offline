Persist riverpod state offline using Hive

## Features

✅ Persist state even when app is killed
✅ Debounce I/O disk operations to improve performances
❌ Support other stores than Hive

## Getting started

Make sure to init Hive before using this package:

```dart
Hive.initFlutter();
```

## Usage

1. Define a state class:

```dart
part 'counter_state.freezed.dart';
part 'counter_state.g.dart';

@freezed
class CountersState with _$CountersState implements Serializable {
  const factory CountersState({
    @Default(0) int counter,
  }) = _CountersState;

  factory CountersState.fromJson(Map<String, dynamic> json) =>
      _$CountersStateFromJson(json);
}
```

2. Write your provider:

```dart
part 'counter_provider.g.dart';

@riverpod
class Counter extends _$Counter with PersistedState<CounterState> {
  @override
  String get boxName => 'Counter';

  @override
  CountersState fromJson(Map<String, dynamic> json) =>
      CountersState.fromJson(json);

  @override
  CountersState build() {
    // Load previous persisted state from disk
    loadPersistedState();
    return const CountersState();
  }

  // Add any state mutations below
  increment() {
    state = state.copyWith(counter: state.counter + 1);
  }
}
```

3. Use the provider like you usually do:

```dart
// Rebuilds UI everytime counter changes
final state = ref.watch(counterProvider.select((s) => s.counter));
print(state.counter);
```

If you don't want to use code generation, you can also use the following syntax:

```dart
class CounterNotifier extends PersistedNotifier<CounterState> {
  CounterNotifier({
    required super.boxName,
    required super.defaultState,
    required super.fromJson,
  });

  // Add any state mutations below
  increment() {
    state = state.copyWith(counter: state.counter + 1);
  }
}

final counterProvider = NotifierProvider<CounterNotifier, CounterState>(
  () => CounterNotifier(
    boxName: 'Counter',
    defaultState: const CounterState(length: 0),
    fromJson: CounterState.fromJson,
  ),
);
```
