import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/models/user_update_request.dart';

class EditUserForm extends StatefulWidget {
  final int userId;
  const EditUserForm({Key? key, required this.userId}) : super(key: key);

  @override
  State<EditUserForm> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameCtl = TextEditingController();
  final TextEditingController _emailCtl = TextEditingController();
  final TextEditingController _birthCtl = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final dto = await ApiClient.getUserApiService().getUserUpdateInfo(
        widget.userId,
      );
      setState(() {
        _fullNameCtl.text = dto.fullName ?? '';
        _emailCtl.text = dto.email ?? '';
        _birthCtl.text = dto.birthDay != null ? dto.birthDay!.toString() : '';
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Load failed: $e')));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
    });
    try {
      final req = UserUpdateRequest(
        fullName: _fullNameCtl.text,
        email: _emailCtl.text,
        birthDay: _birthCtl.text.isNotEmpty
            ? DateTime.tryParse(_birthCtl.text)
            : null,
      );
      await ApiClient.getUserApiService().updateUser(widget.userId, req);
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _fullNameCtl.dispose();
    _emailCtl.dispose();
    _birthCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fullNameCtl,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _emailCtl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _birthCtl,
                decoration: const InputDecoration(
                  labelText: 'Birthday (YYYY-MM-DD)',
                ),
              ),
              const SizedBox(height: 16),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
