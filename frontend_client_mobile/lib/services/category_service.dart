import 'package:frontend_client_mobile/models/category.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/category_api_service.dart';

class CategoryService {
  final CategoryApiService _apiService = ApiClient.getCategoryApiService();

  Future<List<Category>> getCategories() async {
    final response = await _apiService.getCategories();
    print(response.toString());
    return response;
  }
}
