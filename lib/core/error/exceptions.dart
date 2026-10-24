class ServerException implements Exception {
  const ServerException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String toString() => 'ServerException($statusCode): $message';
}
