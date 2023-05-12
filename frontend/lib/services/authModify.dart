import 'package:dio/dio.dart';
import 'package:reslow/utils/dio_client.dart';

final DioClient dioClient = DioClient();

Future<Response> accountRegister(Map<String, dynamic> formData) async {
  Response response =
      await dioClient.dio.post('/members/account', data: formData);

  return response;
}
