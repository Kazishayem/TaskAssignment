import 'package:dio/dio.dart';

class AppApiService {
  final Dio dio = Dio();

  Future<Map<String, dynamic>> fetchApp(String date) async {
    final response = await dio.get(
      'https://api.nasa.gov/planetary/apod',
      queryParameters: {
        'api_key': '18QBwoiRpbFgeYBSl3PxFHi2aoJjrt7lIindJfng',
        'date': date,
      },
    );

    return response.data;
  }
}
