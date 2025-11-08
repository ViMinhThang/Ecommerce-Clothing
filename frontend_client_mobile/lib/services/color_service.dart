import 'package:frontend_client_mobile/models/color.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/color_api_service.dart';

class ColorService {
  final ColorApiService _apiService = ApiClient.getColorApiService();

  Future<List<Color>> getColors() async {
    return await _apiService.getColors();
  }
}
