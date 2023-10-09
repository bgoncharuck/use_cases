import 'dart:isolate';

void main() async {
  final resultPort = ReceivePort();
  late SendPort taskSendPort;

  for (var i = 0; i < 4; i++) {
    await Isolate.spawn(consumerIsolate, [resultPort.sendPort]);
  }

  resultPort.listen((message) {
    if (message is SendPort) {
      taskSendPort = message;
      sendTasks(taskSendPort);
    }
    if (message is int) {
      print("Received result: $message");
    }
  });
}

void sendTasks(SendPort taskSendPort) {
  for (var i = 1; i <= 10; i++) {
    taskSendPort.send(i);
  }
}

void consumerIsolate(List<dynamic> args) {
  final resultSendPort = args[0] as SendPort;
  final taskPort = ReceivePort();

  resultSendPort.send(taskPort.sendPort);

  taskPort.listen((message) {
    if (message is int) {
      final result = calculateFactorial(message);
      resultSendPort.send(result);
    }
  });
}

int calculateFactorial(int number) {
  var factorial = 1;
  for (var i = 2; i <= number; i++) {
    factorial *= i;
  }
  return factorial;
}
