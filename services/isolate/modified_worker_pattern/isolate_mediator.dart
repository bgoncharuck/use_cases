import 'dart:isolate';
import 'package:flutter/services.dart';

Future _isolateMainFuncExample(dynamic connector) async {
  /// Common isolate service init
  BackgroundIsolateBinaryMessenger.ensureInitialized(connector['isolate_root_token']! as RootIsolateToken);
  final ReceivePort isolateRecieverPort = ReceivePort();
  SendPort? sendPort;
  (connector['isolate_send_port']! as SendPort).send(isolateRecieverPort.sendPort);

  /// Your init
  const cookie = 'oreo';

  await for (final message in isolateRecieverPort) {
    /// Common isolate service send port
    if (message is SendPort) {
      sendPort = message;
    }

    if (message is Map) {
      /// Do stuff here
      sendPort?.send(cookie);
    }
  }
}

Future<IsolateMediator> createIsolateMediator({
  required int id,
  required String label,
  required Future Function(dynamic connector) isolateMainFunc,
  required Function() onKill,
}) async {
  final ReceivePort connectorPort = ReceivePort();
  final ReceivePort exitPort = ReceivePort();
  final ReceivePort errorPort = ReceivePort();

  late final SendPort sendPort;
  final ReceivePort receivePort = ReceivePort();
  final isolate = await Isolate.spawn<dynamic>(
    isolateMainFunc,
    {
      'isolate_send_port': connectorPort.sendPort,
      'isolate_root_token': RootIsolateToken.instance!,
    },
    onExit: exitPort.sendPort,
    onError: errorPort.sendPort,
  );

  sendPort = await connectorPort.first;
  sendPort.send(receivePort.sendPort);

  return IsolateMediator(
    id: id,
    label: label,
    connector: connectorPort,
    isolateMainFunc: isolateMainFunc,
    isolate: isolate,
    exitPort: exitPort,
    errorPort: errorPort,
    onKill: onKill,
    sendPort: sendPort,
    recievePort: receivePort,
  );
}

class IsolateMediator {
  IsolateMediator({
    required this.id,
    required this.label,
    required this.connector,
    required Future Function(dynamic connector) isolateMainFunc,
    required Isolate isolate,
    required this.exitPort,
    required this.errorPort,
    required Function() onKill,
    required this.sendPort,
    required this.recievePort,
  })  : _isolate = isolate,
        _onKill = onKill;

  final int id;
  final String label;
  final ReceivePort connector;
  final ReceivePort exitPort;
  final ReceivePort errorPort;

  /// Messaging ports
  final SendPort sendPort;
  final ReceivePort recievePort;

  final Function() _onKill;
  late final Isolate _isolate;
  bool _isZombie = false;
  bool get killed => _isZombie;

  void kill() {
    if (_isZombie) {
      return;
    }

    _isZombie = true;
    _isolate.kill();
    _onKill();
  }
}
