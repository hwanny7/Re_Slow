class User {
  String userId;
  String accessToken;
  String refreshToken;

  User(
      {required this.userId,
      required this.accessToken,
      required this.refreshToken});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        userId: responseData['userId'],
        accessToken: responseData['accessToken'],
        refreshToken: responseData['refreshToken']);
  }
}
