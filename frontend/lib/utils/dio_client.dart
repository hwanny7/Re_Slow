import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  final Dio dio = Dio(); // Set your base URL here

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio.interceptors.add(_TokenInterceptor());
    dio.options.baseUrl =
        'http://k8b306.p.ssafy.io:8080'; // Set your base URL here
  }
}

class _TokenInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _getTokenFromSharedPreferences();
    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  // Future<void> onError(    DioError err,
  //   ErrorInterceptorHandler handler,) {
//  err.response.statusCode == 401
  //   }

  Future<String?> _getTokenFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}


// final DioClient dioClient = DioClient();
// dioClient.setEndpoint('your/endpoint'); // Append endpoint to the base URL

// final response = await dioClient.dio.get('/your/endpoint'); // Use the appended endpoint