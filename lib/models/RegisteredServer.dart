class RegisteredServer {
  final String id;
  final String serverName;
  final String serverUrl;
  final String? createdAt;
  final String? updatedAt;

  RegisteredServer({
    required this.id,
    required this.serverName,
    required this.serverUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory RegisteredServer.fromJson(Map<String, dynamic> json) {
    return RegisteredServer(
      id: json['_id'] ?? '',
      serverName: json['serverName'] ?? '',
      serverUrl: json['serverUrl'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'] ?? json['lastUpdated'],
    );
  }
}
