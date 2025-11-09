import 'package:frontend_client_mobile/models/size.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/size_api_service.dart';

class SizeService {
  final SizeApiService _apiService = ApiClient.getSizeApiService();

  Future<List<Size>> getSizes() async {
    return await _apiService.getSizes();
  }

  Future<Size> createSize(Size size) async {
    return await _apiService.createSize(size);
  }

  Future<Size> updateSize(int id, Size size) async {
    return await _apiService.updateSize(id, size);
  }

  Future<void> deleteSize(int id) async {
    return await _apiService.deleteSize(id);
  }
}