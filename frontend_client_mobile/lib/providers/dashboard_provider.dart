import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/dashboard_view.dart';
import 'package:frontend_client_mobile/services/dashboard_service.dart';

class DashboardProvider with ChangeNotifier {
  DashboardProvider({DashboardService? service})
    : _service = service ?? DashboardService();

  final DashboardService _service;

  DashboardView? _summary;
  bool _isLoading = false;
  String? _error;

  DashboardView? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDashboard({bool forceRefresh = false}) async {
    if (_isLoading) return;
    if (_summary != null && !forceRefresh) return;

    _isLoading = true;
    if (forceRefresh) _summary = null;
    _error = null;
    notifyListeners();

    try {
      _summary = await _service.fetchSummary();
    } catch (e) {
      _error = 'Không thể tải dữ liệu dashboard';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadDashboard(forceRefresh: true);
  }
}
