class User {
  // String userId;
  String? accessToken;
  String? refreshToken;
  int? refreshTokenExpirationTime;

  User({this.refreshTokenExpirationTime, this.accessToken, this.refreshToken});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        accessToken: responseData['accessToken'],
        refreshToken: responseData['refreshToken'],
        refreshTokenExpirationTime: responseData['refreshTokenExpirationTime']);
  }
}
