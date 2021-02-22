class User {
  String token;
  DateTime expiryDate;
  String userId;
  String role;
  User({
    this.token,
    this.expiryDate,
    this.userId,
    this.role,
  });
}

class Role {
  static final String user = 'USER';
  static final String admin = 'ADMIN';
}
