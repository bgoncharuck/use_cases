mixin IUseCase<P, R> {
  Future<R> execute({required P params});
}

class NoParams {}
