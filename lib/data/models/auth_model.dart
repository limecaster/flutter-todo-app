class AuthModel {
  String email;
  String password;

  AuthModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      email: json['email'],
      password: json['password'],
    );
  }

  @override
  String toString() {
    return 'AuthModel{email: $email, password: $password}';
  }
}
