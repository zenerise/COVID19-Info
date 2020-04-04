import 'package:dio/dio.dart';

class Covid19API {
  static final String baseUrl = "https://covid19.mathdro.id/api";
  static final api = Dio()..options.baseUrl = baseUrl;
  static Response<dynamic> apiResponse;
  // static final String urlExt = "";

  dynamic getData(String ext)  {
    api.get(ext).then((v) => apiResponse = v);
    return apiResponse.data;
  }
}