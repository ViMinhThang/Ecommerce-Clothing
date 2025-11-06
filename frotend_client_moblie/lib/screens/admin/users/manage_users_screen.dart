import 'package:flutter/material.dart';
import '../../../layouts/admin_layout.dart';
import 'edit_user_screen.dart';
import 'users_function.dart';

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
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.black),
        hintText: 'Search User...',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
      onChanged: (query) {
        setState(() {
          // sau này lọc danh sách từ API ở đây
        });
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final u = users[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              u['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${u['email']} • ${u['role']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  tooltip: 'Edit User',
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
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete User',
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
