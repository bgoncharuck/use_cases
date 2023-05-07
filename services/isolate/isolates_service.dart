import '/services/isolate/isolate_mediator.dart';

class IsolatesService {
  final List<IsolateMediator> mediators = [];
  int _lastId = 0;

  void killAll() {
    for (final IsolateMediator mediator in mediators) {
      mediators.remove(mediator..kill());
    }
  }

  void killById(int id) {
    if (mediators.isNotEmpty && mediators.any((mediator) => mediator.id == id)) {
      mediators.removeAt(mediators.indexWhere((mediator) => mediator.id == id)).kill();
    }
  }

  void killByLabel(String label) {
    if (mediators.isNotEmpty && mediators.any((mediator) => mediator.label == label)) {
      mediators.removeAt(mediators.indexWhere((mediator) => mediator.label == label)).kill();
    }
  }

  IsolateMediator of(String label) => mediators.firstWhere((m) => m.label == label);
  IsolateMediator byId(int id) => mediators.firstWhere((m) => m.id == id);

  Future<int> createIsolate({
    required String label,
    required Future Function(dynamic) isolateMainFunc,
    Function()? onKill,
  }) async {
    if (mediators.any((m) => m.label == label)) {
      killByLabel(label);
    }

    final int id = _lastId++;
    mediators.add(await createIsolateMediator(
      id: id,
      label: label,
      isolateMainFunc: isolateMainFunc,
      onKill: () {
        if (onKill != null) {
          onKill();
        }
      },
    ));
    return id;
  }
}
