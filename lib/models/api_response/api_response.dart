class ApiResponse {
  dynamic data;
  bool success;
  String message;

  ApiResponse({
    this.data,
    this.success,
    this.message,
  });

  ApiResponse.fromJson(Map<String, dynamic> json)
      : data = json['data'],
        success = json['success'],
        message = json['message'];
}
