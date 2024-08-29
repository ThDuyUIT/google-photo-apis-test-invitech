import 'package:dio/dio.dart';

class DioOption {
  late Dio client;

  Dio createDio({String? baseUrl}) {
    client = Dio();
    //client.options.connectTimeout = 10000 as Duration?;
    //client.options.baseUrl = 'http://localhost:3006/api';
    client.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers.addAll({'Accept': 'application/json'});
      options.headers.addAll({'content-type': 'application/json'});
      //options.headers.addAll({'Authorization': 'Bearer ${MyApp.prefs.get('token')}'}); // Add token to header
      return handler.next(options);
    }, onResponse: (response, handler) async {
      // Do something with response data
      // return response; // continue
      return handler.next(response);
    }));
    return client;
  }
}
