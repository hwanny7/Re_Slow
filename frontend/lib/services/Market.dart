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
  Response response = await dioClient.dio.get('/orders/$pk');

  return response;
}

Future<Response> getBuyItems(Map<String, dynamic> queryParams) async {
  Response response =
      await dioClient.dio.get('/orders/purchase', queryParameters: queryParams);

  return response;
}

Future<Response> getSellItems(Map<String, dynamic> queryParams) async {
  Response response =
      await dioClient.dio.get('/products/sale', queryParameters: queryParams);

  return response;
}

Future<Response> changeStatus(
    int orderNo, Map<String, dynamic> formData) async {
  Response response =
      await dioClient.dio.patch('/orders/$orderNo', data: formData);

  return response;
}

Future<Response> InputDelivery(
    int orderNo, Map<String, dynamic> formData) async {
  Response response =
      await dioClient.dio.patch('/orders/$orderNo/carrier', data: formData);

  return response;
}

Future<Response> getMyCupons(Map<String, dynamic> queryParams) async {
  Response response =
      await dioClient.dio.get('/coupons/my', queryParameters: queryParams);

  return response;
}

Future<Response> getDelivery(Map<String, dynamic> queryParams) async {
  Response response =
      await dioClient.dio.get('/coupons/my', queryParameters: queryParams);

  return response;
}
