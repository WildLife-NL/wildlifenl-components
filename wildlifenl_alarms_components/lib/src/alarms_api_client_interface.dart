abstract interface class AlarmsApiClientInterface {
  Future<AlarmsHttpResponse> get(String path);
}

class AlarmsHttpResponse {
  const AlarmsHttpResponse({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;
  final String body;
}
