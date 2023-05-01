import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  final Dio dio = Dio();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio.interceptors.add(_TokenInterceptor());
    dio.options.contentType = Headers.jsonContentType;
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

// final response = await dioClient.dio.get('/endpoint',     data: formData,
//     options: Options(contentType: 'multipart/form-data'),); // Use the appended endpoint