import 'package:dio/dio.dart';

import '../models/role_view.dart';
import 'api/api_client.dart';

class RoleService {
  RoleService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<RoleView>> getAllRoles() async {
    final response = await _dio.get('/api/roles');
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map>()
          .map(
            (item) => RoleView.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    }
    return const [];
  }
}
