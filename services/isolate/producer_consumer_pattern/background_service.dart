import 'dart:async';
import 'dart:isolate';

class BackgroundService<P, R> {
  late SendPort _taskSendPort;
  final R Function(P) _calculate;

  BackgroundService(this._calculate);

  Future<void> init({
    required ReceivePort bridgePort,
    required ReceivePort resultPort,
  }) async {
    await Isolate.spawn(_consumerIsolate, [bridgePort.sendPort, resultPort.sendPort, _calculate]);
    _taskSendPort = await bridgePort.first as SendPort;
    resultPort.listen((message) {
      if (message is R) {
        _resultStreamController.add(message);
      }
    });
  }

  void send(P data) {
    _taskSendPort.send(data);
  }

  final StreamController<R> _resultStreamController = StreamController.broadcast();
  Stream<R> get result => _resultStreamController.stream;

  void _consumerIsolate(List<dynamic> args) {
    final bridgeSendPort = args[0] as SendPort;
    final resultSendPort = args[1] as SendPort;
    final calculate = args[2] as R Function(P);
    final taskPort = ReceivePort();

    bridgeSendPort.send(taskPort.sendPort);

    taskPort.listen((message) {
      if (message is P) {
        final result = calculate(message);
        resultSendPort.send(result);
      }
    });
  }
}

class BackgroundServiceFactory<P, R> {
  Future<BackgroundService<P, R>> create(R Function(P) calculate) async {
    final bridgePort = ReceivePort();
    final resultPort = ReceivePort();
    final service = BackgroundService<P, R>(calculate);
    await service.init(
      bridgePort: bridgePort,
      resultPort: resultPort,
    );
    return service;
  }
}

Future<void> main() async {
  final factorialService = await BackgroundServiceFactory<int, int>().create(calculateFactorial);

  factorialService.result.listen((result) {
    print(result);
  });

  factorialService.send(4);
  factorialService.send(6);
}

int calculateFactorial(int number) {
  var factorial = 1;
  for (var i = 2; i <= number; i++) {
    factorial *= i;
  }
  return factorial;
}
