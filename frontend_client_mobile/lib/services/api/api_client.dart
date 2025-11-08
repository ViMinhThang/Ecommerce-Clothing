import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/services/api/category_api_service.dart';
import 'package:frontend_client_mobile/services/api/color_api_service.dart';
import 'package:frontend_client_mobile/services/api/product_api_service.dart';
import 'package:frontend_client_mobile/services/api/size_api_service.dart';

class ApiClient {
  static final Dio _dio = Dio();
  static ProductApiService? _productApiService;
  static CategoryApiService? _categoryApiService;
  static ColorApiService? _colorApiService;
  static SizeApiService? _sizeApiService;

  static ProductApiService getProductApiService() {
    if (_productApiService == null) {
      _productApiService = ProductApiService(_dio);
    }
    return _productApiService!;
  }

  static CategoryApiService getCategoryApiService() {
    if (_categoryApiService == null) {
      _categoryApiService = CategoryApiService(_dio);
    }
    return _categoryApiService!;
  }

  static ColorApiService getColorApiService() {
    if (_colorApiService == null) {
      _colorApiService = ColorApiService(_dio);
    }
    return _colorApiService!;
  }

  static SizeApiService getSizeApiService() {
    if (_sizeApiService == null) {
      _sizeApiService = SizeApiService(_dio);
    }
    return _sizeApiService!;
  }
}
