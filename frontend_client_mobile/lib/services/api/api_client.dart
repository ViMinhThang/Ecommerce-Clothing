import 'package:dio/dio.dart';
import 'package:frontend_client_mobile/services/api/api_config.dart';
import 'package:frontend_client_mobile/services/api/category_api_service.dart';
import 'package:frontend_client_mobile/services/api/color_api_service.dart';
import 'package:frontend_client_mobile/services/api/dashboard_api_service.dart';
import 'package:frontend_client_mobile/services/api/filter_api_service.dart';
import 'package:frontend_client_mobile/services/api/order_api_service.dart';
import 'package:frontend_client_mobile/services/api/product_api_service.dart';
import 'package:frontend_client_mobile/services/api/search_api_service.dart';
import 'package:frontend_client_mobile/services/api/size_api_service.dart';
import 'package:frontend_client_mobile/services/api/user_api_service.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(milliseconds: 3000),
      receiveTimeout: Duration(milliseconds: 3000),
    ),
  );
  static ProductApiService? _productApiService;
  static CategoryApiService? _categoryApiService;
  static ColorApiService? _colorApiService;
  static SizeApiService? _sizeApiService;
  static FilterApiService? _filterService;
  static OrderApiService? _orderApiService;
  static DashboardApiService? _dashboardApiService;
  static UserApiService? _userApiService;
  static SearchApiService? _searchApiService;
  static Dio get dio => _dio;

  static ProductApiService getProductApiService() {
    _productApiService ??= ProductApiService(_dio);
    return _productApiService!;
  }

  static CategoryApiService getCategoryApiService() {
    _categoryApiService ??= CategoryApiService(_dio);
    return _categoryApiService!;
  }

  static ColorApiService getColorApiService() {
    _colorApiService ??= ColorApiService(_dio);
    return _colorApiService!;
  }

  static SizeApiService getSizeApiService() {
    _sizeApiService ??= SizeApiService(_dio);
    return _sizeApiService!;
  }

  static FilterApiService getFilterApiService() {
    _filterService ??= FilterApiService(_dio);
    return _filterService!;
  }

  static OrderApiService getOrderApiService() {
    _orderApiService ??= OrderApiService(_dio);
    return _orderApiService!;
  }

  static DashboardApiService getDashboardApiService() {
    _dashboardApiService ??= DashboardApiService(_dio);
    return _dashboardApiService!;
  }

  static UserApiService getUserApiService() {
    _userApiService ??= UserApiService(_dio);
    return _userApiService!;
  }

  static SearchApiService getSearchApiService() {
    _searchApiService ??= SearchApiService(_dio);
    return _searchApiService!;
  }
}
