import 'dart:core';

Future<BigInt> fibonacciAt(int n, [BigInt? a, BigInt? b]) async {
  final curA = a ?? BigInt.zero;
  final curB = b ?? BigInt.one;

  if (n <= 0) {
    return curA;
  }

  return fibonacciAt(n - 1, curB, curA + curB);
}
