import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:frontend_client_mobile/models/filter_attributes.dart';
import 'package:frontend_client_mobile/models/product_view.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/filter_api_service.dart';
import 'package:retrofit/dio.dart';

class FilterService {
  final FilterApiService _filterApiService = ApiClient.getFilterApiService();

  Future<HttpResponse<PageResponse<ProductView>>> filters(
    Map<String, dynamic> filters,
    int categoryId,
  ) async {
    return await _filterApiService.filter(filters, categoryId);
  }

  Future<int> countProductAvailable(
    Map<String, dynamic> filters,
    int categoryId,
  ) async {
    return await _filterApiService.countProductAvailable(filters, categoryId);
  }

  Future<FilterResponse> getFilterAttributes(int categoryId) async {
    return await _filterApiService.getFilterAttributes(categoryId);
  }
}
