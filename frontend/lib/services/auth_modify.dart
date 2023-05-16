import 'package:dio/dio.dart';
import 'package:reslow/utils/dio_client.dart';

final DioClient dioClient = DioClient();

Future<Response> accountRegister(Map<String, dynamic> formData) async {
  Response response =
      await dioClient.dio.post('/members/account', data: formData);

  return response;
}

Future<Response> getShipmentInfo() async {
  Response response = await dioClient.dio.get('/members/address');

  return response;
}

Future<Response> registerShipmentInfo(Map<String, dynamic> formData) async {
  Response response = await dioClient.dio.put('/members/', data: formData);

  return response;
}

Future<Response> addProfilePic(FormData formData) async {
  Response response = await dioClient.dio.post('/members/profile',
      data: formData, options: Options(contentType: 'multipart/form-data'));

  return response;
}
