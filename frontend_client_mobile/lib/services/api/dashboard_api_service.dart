import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/models/dashboard_view.dart';
import 'package:retrofit/retrofit.dart';

part 'dashboard_api_service.g.dart';

@RestApi()
abstract class DashboardApiService {
  factory DashboardApiService(Dio dio, {String? baseUrl}) =
      _DashboardApiService;

  @GET('api/dashboard')
  Future<DashboardView> getDashboardSummary();
}
