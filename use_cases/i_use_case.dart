mixin IUseCase<T, P> {
  Future<T> execute({required P params});
}

class NoParams {}
