import 'package:dio/dio.dart';
import 'package:reslow/utils/dio_client.dart';

final DioClient dioClient = DioClient();

Future<Response> createOrder(
    String? impUid, Map<String, dynamic> formData) async {
  Response response =
      await dioClient.dio.post('/orders/$impUid', data: formData);

  return response;
}

Future<Response> getOrder(int pk) async {
  print(pk);
  Response response = await dioClient.dio.get('/orders/$pk');

  return response;
}
