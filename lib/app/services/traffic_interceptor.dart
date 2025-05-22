import 'package:dio/dio.dart';


class TrafficInterceptor extends Interceptor {

  final accessToken = 'pk.eyJ1IjoiZGllZ28tdmFsZGVycmFtYS1tdSIsImEiOiJjbTIwdnh2eGwwMHNzMm9xNXF6a29kOXM1In0.Uo-wVrhKnVMGvNZX0D-KJQ';


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    
    options.queryParameters.addAll({
      'alternatives': true,
      'continue_straight':true,
      'geometries': 'polyline6',
      'overview': 'full',
      'steps': true,
      'access_token': accessToken
    });


    super.onRequest(options, handler);
  }


}
