import 'package:frontend_client_mobile/models/dashboard_view.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/dashboard_api_service.dart';

class DashboardService {
  final DashboardApiService _apiService = ApiClient.getDashboardApiService();

  Future<DashboardView> fetchSummary() async {
    return await _apiService.getDashboardSummary();
  }
}
