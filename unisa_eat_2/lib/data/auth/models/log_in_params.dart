class LogInParams {

  final String email;
  final String password;

  LogInParams({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory LogInParams.fromJson(Map<String, dynamic> json) {
    return LogInParams(
      email: json['email'],
      password: json['password'],
    );
  }
}