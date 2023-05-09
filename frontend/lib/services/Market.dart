import 'package:dio/dio.dart';
import 'package:reslow/utils/dio_client.dart';

final DioClient dioClient = DioClient();

Future<Response> createOrder(
    String? impUid, Map<String, dynamic> formData) async {
  Response response =
      await dioClient.dio.post('/orders/$impUid', data: formData);

  return response;
}
