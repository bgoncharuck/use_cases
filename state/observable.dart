import 'dart:async';
import 'package:flutter/foundation.dart';

abstract class ObservableInterface<E, S> {
  void event(E event);
  S get state;
  Listenable get notifier;
}

abstract class ObservableController<E, S> {
  ObservableController(S initialState)
    : _states = ValueNotifier<S>(initialState) {
    _events.stream.listen(_handleEvent);
  }

  // Must be overridden
  Future<void> logic(E event);

  final _events = StreamController<E>();
  final ValueNotifier<S> _states;

  Future<void> _handleEvent(E event) async => logic(event);
  void event(E event) {
    if (!_events.isClosed) _events.sink.add(event);
  }

  S get state => _states.value;
  Listenable get notifier => _states;
  set state(S newState) {
    _states.value = newState;
  }

  void dispose() {
    _events.close();
    _states.dispose();
  }
}
