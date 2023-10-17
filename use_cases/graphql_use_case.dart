export '../i_use_case.dart';

mixin GraphQLParameters {
  Future<GraphQLMeta> metaData();
}

abstract class GraphQLUseCase {
  Future<dynamic> query(GraphQLMeta q);
  Future<dynamic> mutation(GraphQLMeta q);
  // Future<Stream?> subscription(GraphQLMeta q);
  // Future<Stream?> liveSubscription(GraphQLMeta q);
}

class GraphQLMeta {
  GraphQLMeta({
    required this.key,
    required this.document,
    required this.variables,
    required this.headers,
  });
  final String key;
  final String document;
  final Map<String, dynamic>? variables;
  final Map<String, String> headers;

  List<dynamic> convertToDynamicParams() => [key, document, variables, headers];
}

/// Bridge pattern that
/// decouples any of GraphQLUseCaseBridge use-cases
/// from the specific implementation of the GraphQL client library
class GraphQLUseCaseBridge implements GraphQLUseCase {
  final GraphQLUseCase _rawGraphQLUseCase = RawGraphQLUseCase();

  @override
  Future<dynamic> mutation(GraphQLMeta q) => _rawGraphQLUseCase.mutation(q);

  @override
  Future<dynamic> query(GraphQLMeta q) => _rawGraphQLUseCase.query(q);
}
