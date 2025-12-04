class User {
  final int id;
  final String email;

  final String fullName;
  final DateTime createdAt;
  final String token;

  User({
    required this.id,
    required this.email,

    required this.fullName,
    required this.createdAt,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],

    fullName: json["fullName"],
    createdAt: DateTime.parse(json["createdAt"]),
    token: json["token"],
  );
}
