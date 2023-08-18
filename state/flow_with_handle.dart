import 'dart:async';

class Flow<T> {
  final StreamController<T> _streamController = StreamController<T>.broadcast();

  Stream<T> get stream => _streamController.stream;

  void emit(T event) {
    _streamController.add(event);
  }

  void handle(void Function(T event) handler) {
    _streamController.stream.listen(handler);
  }
}

class CounterCompositionExample {
  final Flow<int> _flow = Flow<int>();

  Stream<int> get stream => _flow.stream;

  void increment() {
    _flow.emit(1);
  }

  void decrement() {
    _flow.emit(-1);
  }

  void handle() {
    _flow.handle((event) {
      print(event);
    });
  }
}

void main() {
  final example = CounterCompositionExample();
  
  example.stream.listen((event) {
    print(event);
  });

  example.increment();
  example.decrement();
}
