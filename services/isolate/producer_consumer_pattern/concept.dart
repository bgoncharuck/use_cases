import 'dart:async';
import 'dart:isolate';

void main() async {
  final taskQueue = StreamController<int>();

  for (int i = 0; i < 4; i++) {
    Isolate.spawn(consumerIsolate, taskQueue.sink);
  }

  // Add tasks to the queue
  for (int i = 1; i <= 10; i++) {
    taskQueue.add(i);
  }

  await Future.delayed(Duration(seconds: 1)); // Give time for processing

  await taskQueue.close();
}

void consumerIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((message) {
    if (message is StreamSink<int>) {
      final taskStream = Stream<int>.fromStreamSink(message);
      taskStream.listen((task) {
        final result = calculateFactorial(task);
        print("Task $task: Result $result");
      });
    }
  });
}

int calculateFactorial(int number) {
  int factorial = 1;
  for (int i = 2; i <= number; i++) {
    factorial *= i;
  }
  return factorial;
}
