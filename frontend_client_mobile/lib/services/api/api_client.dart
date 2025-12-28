import 'dart:convert';

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
import 'package:frontend_client_mobile/services/token_storage.dart';
import 'package:frontend_client_mobile/services/auth_service.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(milliseconds: 3000),
      receiveTimeout: Duration(milliseconds: 3000),
    ),
  );
  static bool _interceptorAdded = false;
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
    configInterceptor();
    return _productApiService!;
  }

  static CategoryApiService getCategoryApiService() {
    _categoryApiService ??= CategoryApiService(_dio);
    configInterceptor();
    return _categoryApiService!;
  }

  static ColorApiService getColorApiService() {
    _colorApiService ??= ColorApiService(_dio);
    configInterceptor();
    return _colorApiService!;
  }

  static SizeApiService getSizeApiService() {
    _sizeApiService ??= SizeApiService(_dio);
    configInterceptor();
    return _sizeApiService!;
  }

  static FilterApiService getFilterApiService() {
    _filterService ??= FilterApiService(_dio);
    configInterceptor();
    return _filterService!;
  }

  static OrderApiService getOrderApiService() {
    _orderApiService ??= OrderApiService(_dio);
    configInterceptor();
    return _orderApiService!;
  }

  static DashboardApiService getDashboardApiService() {
    _dashboardApiService ??= DashboardApiService(_dio);
    configInterceptor();
    return _dashboardApiService!;
  }

  static UserApiService getUserApiService() {
    _userApiService ??= UserApiService(_dio);
    configInterceptor();
    return _userApiService!;
  }

  static SearchApiService getSearchApiService() {
    _searchApiService ??= SearchApiService(_dio);
    configInterceptor();
    return _searchApiService!;
  }

  static String? _extractMessage(dynamic data) {
    if (data == null) return null;

    var body = data;
    if (body is String) {
      try {
        body = jsonDecode(body);
      } catch (_) {
        return body;
      }
    }
    if (body is Map) {
      if (body['message'] != null) return body['message'].toString();
      if (body['error'] != null) return body['error'].toString();
      if (body['data'] != null && body['data'] is String) {
        return body['data'].toString();
      }
      if (body.isNotEmpty) return body.values.first.toString();
    }
    return null;
  }

  static void configInterceptor() {
    if (_interceptorAdded) return;
    _interceptorAdded = true;

    final TokenStorage _tokenStorage = TokenStorage();
    final AuthService _authService = AuthService();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.readAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Nếu backend trả 401 -> thử refresh
          final status = e.response?.statusCode ?? 0;
          if (status == 401) {
            // tránh vòng lặp: nếu request là refresh thì không gọi lại
            if (e.requestOptions.path.contains('/api/auth/refresh')) {
              await _tokenStorage.clear();
              return handler.next(e);
            }

            final didRefresh = await _authService.refreshToken();
            if (didRefresh) {
              final newToken = await _tokenStorage.readAccessToken();
              if (newToken != null) {
                final opts = Options(
                  method: e.requestOptions.method,
                  headers: Map.from(e.requestOptions.headers),
                );
                opts.headers!['Authorization'] = 'Bearer $newToken';

                try {
                  final cloneReq = await dio.request(
                    e.requestOptions.path,
                    data: e.requestOptions.data,
                    queryParameters: e.requestOptions.queryParameters,
                    options: opts,
                  );
                  return handler.resolve(cloneReq);
                } on DioException catch (err) {
                  return handler.next(err);
                }
              }
            }
          }

          // Chỉ xử lý lỗi có response từ backend (4xx, 5xx)
          if (e.type == DioExceptionType.badResponse && e.response != null) {
            if (status >= 400) {
              final msg = _extractMessage(e.response?.data) ?? 'Có lỗi xảy ra';
              return handler.reject(
                DioException(
                  requestOptions: e.requestOptions,
                  response: e.response,
                  type: e.type,
                  error: AppHttpException(msg),
                ),
              );
            }
          }

          return handler.next(e);
        },
      ),
    );
  }
}

class AppHttpException implements Exception {
  final String message;
  AppHttpException(this.message);
  @override
  String toString() => message; // để e.toString() trả về đúng message
}
