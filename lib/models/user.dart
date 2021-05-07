class User {
  String token;
  DateTime expiryDate;
  String userId;
  String role;
  String userEmail;
  User({
    this.token,
    this.expiryDate,
    this.userId,
    this.role,
    this.userEmail,
  });
}

class Role {
  static final String user = 'USER';
  static final String admin = 'ADMIN';
}
