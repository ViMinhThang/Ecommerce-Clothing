import 'package:flutter/foundation.dart';
import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:frontend_client_mobile/models/order_statistics.dart';
import 'package:frontend_client_mobile/models/order_view.dart';
import 'package:frontend_client_mobile/services/order_service.dart';

class OrderProvider with ChangeNotifier {
  OrderProvider({OrderService? orderService})
    : _orderService = orderService ?? OrderService();

  final OrderService _orderService;

  final List<OrderView> _orders = [];
  PageResponse<OrderView>? _lastPage;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isLoadingStatistics = false;
  String? _statusFilter;
  String _sortBy = 'createdDate';
  String _direction = 'DESC';
  int _pageSize = 10;
  OrderStatistics? _statistics;

  List<OrderView> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get statusFilter => _statusFilter;
  String get sortBy => _sortBy;
  String get direction => _direction;
  int get pageSize => _pageSize;
  PageResponse<OrderView>? get lastPage => _lastPage;
  OrderStatistics? get statistics => _statistics;
  bool get isLoadingStatistics => _isLoadingStatistics;

  Future<void> initialize({bool forceRefresh = false}) async {
    if (_orders.isNotEmpty && _statistics != null && !forceRefresh) return;
    await refreshAll();
  }

  Future<void> refreshAll() async {
    await Future.wait([refreshOrders(), fetchStatistics()]);
  }

  Future<void> refreshOrders() async {
    _orders.clear();
    _hasMore = true;
    _lastPage = null;
    await _fetchOrders(page: 0, reset: true);
  }

  Future<void> fetchNextPage() async {
    if (!_hasMore || _isLoading) return;
    final nextPage = (_lastPage?.number ?? -1) + 1;
    await _fetchOrders(page: nextPage);
  }

  Future<void> _fetchOrders({required int page, bool reset = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _orderService.getOrders(
        status: _statusFilter,
        sortBy: _sortBy,
        direction: _direction,
        page: page,
        size: _pageSize,
      );

      _lastPage = response;
      if (reset) {
        _orders
          ..clear()
          ..addAll(response.content);
      } else {
        _orders.addAll(response.content);
      }

      final fetchedItemCount = _orders.length;
      final totalExpected = response.totalElements;
      _hasMore =
          fetchedItemCount < totalExpected &&
          response.number < response.totalPages - 1;
    } catch (e, stack) {
      debugPrint('Error fetching orders: $e');
      debugPrint('$stack');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<OrderView> createOrder(OrderView order) async {
    final created = await _orderService.createOrder(order);
    _orders.insert(0, created);
    notifyListeners();
    return created;
  }

  Future<OrderView> updateOrder(OrderView order) async {
    final updated = await _orderService.updateOrder(order.id, order);
    final index = _orders.indexWhere((item) => item.id == updated.id);
    if (index != -1) {
      _orders[index] = updated;
      notifyListeners();
    }
    return updated;
  }

  Future<void> deleteOrder(int id) async {
    await _orderService.deleteOrder(id);
    _orders.removeWhere((order) => order.id == id);
    notifyListeners();
  }

  Future<OrderView> getOrder(int id, {bool forceRemote = false}) async {
    if (!forceRemote) {
      final existing = _orders.firstWhere(
        (order) => order.id == id,
        orElse: () => OrderView(
          id: -1,
          buyerEmail: '',
          totalPrice: 0,
          createdDate: '',
          status: '',
        ),
      );
      if (existing.id != -1) return existing;
    }
    final remote = await _orderService.getOrder(id);
    final index = _orders.indexWhere((order) => order.id == id);
    if (index != -1) {
      _orders[index] = remote;
    } else {
      _orders.insert(0, remote);
    }
    notifyListeners();
    return remote;
  }

  void updateFilters({
    String? status,
    bool applyStatus = false,
    String? sortBy,
    String? direction,
    int? size,
  }) {
    bool shouldRefresh = false;

    if (applyStatus && status != _statusFilter) {
      _statusFilter = status;
      shouldRefresh = true;
    }
    if (sortBy != null && sortBy.isNotEmpty && sortBy != _sortBy) {
      _sortBy = sortBy;
      shouldRefresh = true;
    }
    if (direction != null && direction.isNotEmpty && direction != _direction) {
      _direction = direction;
      shouldRefresh = true;
    }
    if (size != null && size > 0 && size != _pageSize) {
      _pageSize = size;
      shouldRefresh = true;
    }

    if (shouldRefresh) {
      refreshOrders();
    }
  }

  Future<void> fetchStatistics() async {
    _isLoadingStatistics = true;
    notifyListeners();

    try {
      _statistics = await _orderService.getStatistics();
    } catch (e, stack) {
      debugPrint('Error fetching order statistics: $e');
      debugPrint('$stack');
      rethrow;
    } finally {
      _isLoadingStatistics = false;
      notifyListeners();
    }
  }
}
