import 'dart:async';
import 'dart:isolate';

void main() async {
  final taskQueue = StreamController<int>();
  final resultReceivePort = ReceivePort();

  for (var i = 0; i < 4; i++) {
    await Isolate.spawn(consumerIsolate, [taskQueue.stream, resultReceivePort.sendPort]);
  }

  resultReceivePort.listen((message) {
    if (message is int) {
      print("Received result: $message");
    }
  });

  for (var i = 1; i <= 10; i++) {
    taskQueue.add(i);
  }

  await taskQueue.close();
}

void consumerIsolate(List<dynamic> args) {
  final taskStream = args[0] as Stream<int>;
  final resultSendPort = args[1] as SendPort;

  taskStream.listen((message) {
    final result = calculateFactorial(message);
    resultSendPort.send(result);
  });
}

int calculateFactorial(int number) {
  var factorial = 1;
  for (var i = 2; i <= number; i++) {
    factorial *= i;
  }
  return factorial;
}
