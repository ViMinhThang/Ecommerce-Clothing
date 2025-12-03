import 'package:flutter/foundation.dart';
import 'package:frontend_client_mobile/models/PageResponse.dart';
import 'package:frontend_client_mobile/models/user_detail_view.dart';
import 'package:frontend_client_mobile/models/user_item_view.dart';
import 'package:frontend_client_mobile/models/user_request.dart';
import 'package:frontend_client_mobile/models/user_update_request.dart';
import 'package:frontend_client_mobile/models/user_search_result.dart';
import 'package:frontend_client_mobile/services/user_service.dart';

class UserProvider with ChangeNotifier {
  UserProvider({UserService? userService})
    : _userService = userService ?? UserService();

  final UserService _userService;

  final List<UserItemView> _users = [];
  PageResponse<UserItemView>? _lastPage;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isSaving = false;
  bool _isDeleting = false;
  bool _isFetchingDetail = false;
  bool _isSearching = false;
  int _pageSize = 10;
  String _sort = 'createdDate,desc';
  String _searchKeyword = '';

  UserDetailView? _selectedUser;
  List<UserSearchResult> _searchResults = const [];

  List<UserItemView> get users => List.unmodifiable(_users);
  PageResponse<UserItemView>? get lastPage => _lastPage;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  bool get isSaving => _isSaving;
  bool get isDeleting => _isDeleting;
  bool get isFetchingDetail => _isFetchingDetail;
  bool get isSearching => _isSearching;
  int get pageSize => _pageSize;
  String get sort => _sort;
  UserDetailView? get selectedUser => _selectedUser;
  List<UserSearchResult> get searchResults => _searchResults;
  String get searchKeyword => _searchKeyword;

  Future<void> initialize({bool forceRefresh = false}) async {
    if (_users.isNotEmpty && !forceRefresh) return;
    await refreshUsers();
  }

  Future<void> refreshUsers() async {
    _users.clear();
    _lastPage = null;
    _hasMore = true;
    await _fetchUsers(page: 0, reset: true);
  }

  Future<void> fetchNextPage() async {
    if (!_hasMore || _isLoading) return;
    final nextPage = (_lastPage?.number ?? -1) + 1;
    await _fetchUsers(page: nextPage);
  }

  Future<void> _fetchUsers({required int page, bool reset = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userService.fetchUsers(
        page: page,
        size: _pageSize,
        sort: _sort,
      );

      _lastPage = response;
      if (reset) {
        _users
          ..clear()
          ..addAll(response.content);
      } else {
        _users.addAll(response.content);
      }

      final fetched = _users.length;
      final total = response.totalElements;
      _hasMore = fetched < total && response.number < response.totalPages - 1;
    } catch (error, stack) {
      debugPrint('Error fetching users: $error');
      debugPrint('$stack');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUser(UserRequest request) async {
    _isSaving = true;
    notifyListeners();
    try {
      await _userService.createUser(request);
      await refreshUsers();
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(int id, UserUpdateRequest request) async {
    _isSaving = true;
    notifyListeners();
    try {
      await _userService.updateUser(id, request);
      await refreshUsers();
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(int id) async {
    _isDeleting = true;
    notifyListeners();
    try {
      await _userService.deleteUser(id);
      _users.removeWhere((user) => user.id == id);
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  Future<UserDetailView?> fetchUserDetail(
    int id, {
    bool forceRemote = false,
  }) async {
    if (!forceRemote && _selectedUser != null && _selectedUser?.id == id) {
      return _selectedUser;
    }
    _isFetchingDetail = true;
    notifyListeners();
    try {
      _selectedUser = await _userService.getUserDetail(id);
      return _selectedUser;
    } finally {
      _isFetchingDetail = false;
      notifyListeners();
    }
  }

  Future<UserUpdateRequest> fetchUpdateInfo(int id) {
    return _userService.getUserUpdateInfo(id);
  }

  Future<void> searchUsers(String keyword) async {
    final trimmed = keyword.trim();
    _searchKeyword = trimmed;
    if (trimmed.isEmpty) {
      _searchResults = const [];
      notifyListeners();
      return;
    }
    _isSearching = true;
    notifyListeners();
    try {
      _searchResults = await _userService.searchUsers(trimmed);
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void updatePagination({int? pageSize, String? sort}) {
    bool changed = false;
    if (pageSize != null && pageSize > 0 && pageSize != _pageSize) {
      _pageSize = pageSize;
      changed = true;
    }
    if (sort != null && sort.isNotEmpty && sort != _sort) {
      _sort = sort;
      changed = true;
    }
    if (changed) {
      refreshUsers();
    }
  }

  void clearDetailCache() {
    _selectedUser = null;
  }
}
