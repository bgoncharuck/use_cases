import 'dart:async';

class Flow<T> {
  final StreamController<T> _value = StreamController<T>.broadcast();
  T _latestValue;

  Flow(T value) : _latestValue = value {
    setValue(value);
  }

  Stream<T> get stream => _value.stream;

  void setValue(T value) {
    _latestValue = value;
    _value.add(value);
  }
  
  T get value => _latestValue;
}

mixin Flowable<T> {
  final StreamController<T> _value = StreamController<T>.broadcast();
  late T _latestValue;

  Stream<T> get stream => _value.stream;

  void setValue(T value) {
    _latestValue = value;
    _value.add(value);
  }

  T get value => _latestValue;
}

class CounterMixinExample with Flowable<int> {
  int get counter => value;

  void increment() {
    setValue(counter + 1);
  }

  CounterMixinExample(int value) : super() {
    setValue(value);
  }
}

class CounterCompositionExample {
  final Flow<int> _counter = Flow<int>(0);

  Stream<int> get counter => _counter.stream;

  void increment() {
    _counter.setValue(_counter.value + 1);
  }

  CounterCompositionExample(int value) {
    _counter.setValue(value);
  }
}

void main() {
  final counter = CounterMixinExample(0);

  counter.stream.listen((counter) {
    print(counter);
  });

  counter.increment();
  counter.increment();
}
