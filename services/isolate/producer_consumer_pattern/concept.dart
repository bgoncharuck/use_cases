import 'dart:async';
import 'dart:isolate';

void main() async {
  final taskQueue = StreamController<int>();

  final resultReceivePort = ReceivePort(); // To receive results

  for (int i = 0; i < 4; i++) {
    Isolate.spawn(consumerIsolate, [taskQueue.stream, resultReceivePort.sendPort]);
  }

  // Add tasks to the queue
  for (int i = 1; i <= 10; i++) {
    taskQueue.add(i);
  }

  await taskQueue.close();

  // Receive and print results
  await for (final result in resultReceivePort) {
    print("Received result: $result");
  }
}

void consumerIsolate(List<dynamic> args) {
  final taskStream = args[0] as Stream<int>;
  final resultSendPort = args[1] as SendPort;

  final receivePort = ReceivePort();
  resultSendPort.send(receivePort.sendPort);

  receivePort.listen((message) {
    if (message is int) {
      final result = calculateFactorial(message);
      resultSendPort.send(result); // Send result back
    }
  });

  taskStream.listen((task) {
    receivePort.sendPort.send(task); // Start processing task
  });
}

int calculateFactorial(int number) {
  int factorial = 1;
  for (int i = 2; i <= number; i++) {
    factorial *= i;
  }
  return factorial;
}
