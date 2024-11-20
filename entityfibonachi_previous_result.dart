class PreviousResult {
  const PreviousResult({
    required this.n,
    required this.previousNumber,
    required this.currentNumber,
  });

  final int n;
  final int previousNumber;
  final int currentNumber;
}

PreviousResult fibonacciWithPreviousResult(
  PreviousResult previousResult,
  int n,
) =>
    previousResult.n >= n
        ? previousResult
        : fibonacciWithPreviousResult(
            PreviousResult(
              n: previousResult.n + 1,
              previousNumber: previousResult.currentNumber,
              currentNumber:
                  previousResult.currentNumber + previousResult.previousNumber,
            ),
            n,
          );

int fibonacci(int n) => n <= 1
    ? n
    : fibonacciWithPreviousResult(
        PreviousResult(
          n: 0,
          previousNumber: 0,
          currentNumber: 1,
        ),
        n - 1,
      ).currentNumber;
