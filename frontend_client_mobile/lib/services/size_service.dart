import 'package:frontend_client_mobile/models/size.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/size_api_service.dart';

class SizeService {
  final SizeApiService _apiService = ApiClient.getSizeApiService();

  Future<List<Size>> getSizes() async {
    return await _apiService.getSizes();
  }
}
