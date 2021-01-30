class User {
  String token;
  DateTime expiryDate;
  String userId;
  bool isAdmin;
  User({
    this.token,
    this.expiryDate,
    this.userId,
    this.isAdmin,
  });
}
