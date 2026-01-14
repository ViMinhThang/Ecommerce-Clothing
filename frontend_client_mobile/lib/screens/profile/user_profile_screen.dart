import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/models/user_detail_view.dart';
import 'edit_user_form.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Future<UserDetailView> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _future = ApiClient.getUserApiService().getUserDetail(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: FutureBuilder<UserDetailView>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Email: ${user.email ?? '-'}'),
                const SizedBox(height: 8),
                Text(
                  'Birthday: ${user.birthDay != null ? user.birthDay!.toLocal().toIso8601String().split('T').first : '-'}',
                ),
                const SizedBox(height: 8),
                Text('Status: ${user.status}'),
                const SizedBox(height: 8),
                Text('Roles: ${user.roles.join(', ')}'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // navigate to edit form
                          final didUpdate = await Navigator.of(context)
                              .push<bool?>(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditUserForm(userId: widget.userId),
                                ),
                              );
                          if (didUpdate == true) _load();
                        },
                        child: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          // placeholder: could navigate to orders or logout
                        },
                        child: const Text('More'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
