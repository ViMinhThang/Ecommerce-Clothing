import 'package:flutter/material.dart';
import '../../../layouts/admin_layout.dart';
import 'edit_user_screen.dart';
import 'users_function.dart';
import '../../../config/theme_config.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    users = [
      {
        'id': 1,
        'name': 'Nguyễn Văn A',
        'email': 'vana@example.com',
        'role': 'Admin',
        'status': 'active',
      },
      {
        'id': 2,
        'name': 'Trần Thị B',
        'email': 'thib@example.com',
        'role': 'User',
        'status': 'inactive',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'User Management',
      selectedIndex: 3,
      actions: [
        IconButton(
          onPressed: () => setState(_loadMockData),
          icon: const Icon(Icons.refresh),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _onAddUser,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          Expanded(child: _buildListView()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: AppTheme.borderRadiusSM,
        boxShadow: AppTheme.shadowSM,
      ),
      child: TextField(
        controller: _searchController,
        style: AppTheme.bodyMedium,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: AppTheme.mediumGray),
          hintText: 'Search User...',
          hintStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.lightGray),
          border: OutlineInputBorder(
            borderRadius: AppTheme.borderRadiusSM,
            borderSide: AppTheme.borderThin.top,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppTheme.borderRadiusSM,
            borderSide: AppTheme.borderThin.top,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppTheme.borderRadiusSM,
            borderSide: const BorderSide(
              color: AppTheme.mediumGray,
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: AppTheme.primaryWhite,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (query) {
          setState(() {
            // sau này lọc danh sách từ API ở đây
          });
        },
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final u = users[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.primaryWhite,
            borderRadius: AppTheme.borderRadiusMD,
            border: AppTheme.borderThin,
            boxShadow: AppTheme.shadowSM,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              backgroundColor: AppTheme.offWhite,
              radius: 24,
              child: Text(
                u['name'].toString().substring(0, 1).toUpperCase(),
                style: AppTheme.h4.copyWith(fontSize: 18),
              ),
            ),
            title: Text(u['name'], style: AppTheme.h4.copyWith(fontSize: 16)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    u['email'],
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.veryLightGray,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          u['role'],
                          style: AppTheme.bodySmall.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        u['status'],
                        style: AppTheme.bodySmall.copyWith(
                          color: u['status'] == 'active'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: AppTheme.primaryBlack),
                  tooltip: 'Edit User',
                  splashRadius: 20,
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditUserScreen(user: u),
                      ),
                    );

                    if (updated != null) {
                      setState(() {
                        final index = users.indexWhere(
                          (item) => item['id'] == updated['id'],
                        );
                        if (index != -1) users[index] = updated;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFEF5350),
                  ),
                  tooltip: 'Delete User',
                  splashRadius: 20,
                  onPressed: () => _onDeleteUser(u),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddUser() async {
    final newUser = await addUser(context, const EditUserScreen());
    if (newUser != null) {
      setState(() => users.add(newUser));
    }
  }

  Future<void> _onDeleteUser(Map<String, dynamic> user) async {
    final deleted = await deleteUser(context, users, user);
    if (deleted) setState(() {});
  }
}
