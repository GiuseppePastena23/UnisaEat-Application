class RegisterParams {
  final String email;
  final String password;
  final String password2;
  final String firstName;
  final String lastName;
  final String fiscalCode;
  final String phone;

  RegisterParams({
    required this.email,
    required this.password,
    required this.password2,
    required this.firstName,
    required this.lastName,
    required this.fiscalCode,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'password2': password2,
      'first_name': firstName,
      'last_name': lastName,
      'fiscal_code': fiscalCode,
      'phone': phone,
    };
  }
}