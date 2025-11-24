import 'package:frontend_client_mobile/models/color.dart';
import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/color_api_service.dart';

class ColorService {
  final ColorApiService _apiService = ApiClient.getColorApiService();

  Future<PageResponse<Color>> getColors({int page = 0, int size = 10}) async {
    final response = await _apiService.getColors(page, size);
    return response.data;
  }

  Future<Color> createColor(Color color) async {
    return await _apiService.createColor(color);
  }

  Future<Color> updateColor(int id, Color color) async {
    return await _apiService.updateColor(id, color);
  }

  Future<void> deleteColor(int id) async {
    return await _apiService.deleteColor(id);
  }
}
