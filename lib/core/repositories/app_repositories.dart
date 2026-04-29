import 'package:datepickertask/core/service/app_api_service.dart';

import '../models/app_model.dart';


class AppRepository {
  final AppApiService appApiService;

  AppRepository(this.appApiService);

  Future<AppModel> getApod(String date) async {
    final data = await appApiService.fetchApp(date);
    return AppModel.fromJson(data);
  }
}