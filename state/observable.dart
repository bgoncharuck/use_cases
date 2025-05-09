/// - **Hot Stream In (events):** Incoming events (e.g., user interactions, data updates) are continuously fed
///   into the `Observable` through the `.event` sink. This stream of events is active
///   regardless of whether any listeners are observing the state.
///
/// - **Cold Output (state and notifier):**
///   - The current state of the `Observable` is directly accessible through the `.state` property. This is a
///     "cold" value in the sense that it only provides the current snapshot when accessed.
///   - Changes to the state are broadcast through the `.notifier`, which implements [Listenable]. Listeners
///     subscribing to the `.notifier` will be notified of subsequent state changes triggered by incoming events.
///
/// Example:
/*
class ObservableClassName extends ObservableController<EventType, StateType>
    implements ObservableInterface<EventType, StateType> {
  /// first state
  ObservableClassName() : super(const InitialState());

  @override
  Future<void> logic(EventType event) async {
    /// Logic

    if (event is InitialEvent {
      return _onInitialEvent(event);
    }
  }
}
*/

import 'dart:async';
import 'package:flutter/foundation.dart';

abstract class ObservableInterface<E, S> {
  void event(E event);
  Listenable get notifier;
  /// makes ValueNotifier state available only for reading outside of the class
  S get state;
}

abstract class ObservableController<E, S> {
  ObservableController(S initialState)
    : _states = ValueNotifier<S>(initialState) {
    _events.stream.listen(_handleEvent);
  }

  /// Must be overridden
  Future<void> logic(E event);

  final _events = StreamController<E>();
  final ValueNotifier<S> _states;

  Future<void> _handleEvent(E event) async => logic(event);
  void event(E event) {
    if (!_events.isClosed) _events.sink.add(event);
  }

  S get state => _states.value;
  Listenable get notifier => _states;

  /// can be used only inside the class and unavailable outside of it
  set state(S newState) {
    _states.value = newState;
  }

  void dispose() {
    _events.close();
    _states.dispose();
  }
}
