class User {
  // String userId;
  String? accessToken;
  String? refreshToken;
  int? refreshTokenExpirationTime;
  bool? existAccount;

  User(
      {this.refreshTokenExpirationTime,
      this.accessToken,
      this.refreshToken,
      this.existAccount});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        accessToken: responseData['accessToken'],
        existAccount: responseData['existAccount'],
        refreshToken: responseData['refreshToken'],
        refreshTokenExpirationTime: responseData['refreshTokenExpirationTime']);
  }
}
