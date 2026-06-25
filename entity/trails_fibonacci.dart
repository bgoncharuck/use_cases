import 'dart:core';

Stream<BigInt> fibonacciAt(int n, [BigInt? a, BigInt? b]) async* {
  final curA = a ?? BigInt.zero;
  final curB = b ?? BigInt.one;

  if (n <= 0) {
    yield curA;
    return;
  }

  yield* fibonacciAt(n - 1, curB, curA + curB);
}

Future<String?> fibonacci(int n) async {
  final stream = fibonacciAt(n);
  await for (final result in stream) {
    return result.toString();
  }
  return null;
}
