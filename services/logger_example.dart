import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

late final LoggingLibrary log;

abstract class LoggingLibrary {
  Future<void> exception(Object e, StackTrace t);
  Future<void> message(String message);
}

class SentryLogging implements LoggingLibrary {
  const SentryLogging();

  @override
  Future<void> exception(Object e, StackTrace t) async => await Sentry.captureException(e, stackTrace: t);
  @override
  Future<void> message(String message) async => await Sentry.captureMessage(message);
}

class DebugPrintLogging implements LoggingLibrary {
  const DebugPrintLogging();

  @override
  Future<void> exception(Object e, StackTrace t) async => debugPrint('\n\nException $e\nstackTrace:\n$t\n\n');
  @override
  Future<void> message(String message) async => debugPrint(message);
}

class MultipleLibrariesLogging implements LoggingLibrary {
  final Iterable<LoggingLibrary> libraries = [
    const SentryLogging(),
    if (kDebugMode) const DebugPrintLogging(),
  ];

  @override
  Future<void> exception(Object e, StackTrace t) async {
    for (final lib in libraries) {
      await lib.exception(e, t);
    }
  }

  @override
  Future<void> message(String message) async {
    for (final lib in libraries) {
      await lib.message(message);
    }
  }
}
