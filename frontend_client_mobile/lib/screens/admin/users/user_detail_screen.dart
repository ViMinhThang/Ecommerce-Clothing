import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';
import 'package:frontend_client_mobile/models/user_detail_view.dart';
import 'package:frontend_client_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;
  final String? initialName;

  const UserDetailScreen({super.key, required this.userId, this.initialName});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  UserDetailView? _detail;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final detail = await context.read<UserProvider>().fetchUserDetail(
        widget.userId,
        forceRemote: true,
      );
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Unable to load user detail.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _detail?.name ?? widget.initialName ?? 'User Detail';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppTheme.primaryBlack,
        foregroundColor: AppTheme.primaryWhite,
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _fetchDetail, child: const Text('Retry')),
          ],
        ),
      );
    }

    final detail = _detail;
    if (detail == null) {
      return const Center(child: Text('No detail available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(detail),
          const SizedBox(height: 16),
          _buildInfoSection(detail),
          const SizedBox(height: 16),
          _buildStatsSection(detail),
        ],
      ),
    );
  }

  Widget _buildHeader(UserDetailView detail) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: AppTheme.borderRadiusMD,
        border: AppTheme.borderThin,
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(detail.name, style: AppTheme.h2.copyWith(fontSize: 22)),
          const SizedBox(height: 8),
          Text(
            detail.status.toUpperCase(),
            style: AppTheme.bodySmall.copyWith(
              color: detail.status.toLowerCase() == 'active'
                  ? Colors.green
                  : Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: detail.roles.isEmpty
                ? [
                    Chip(
                      label: const Text('No roles'),
                      backgroundColor: AppTheme.offWhite,
                    ),
                  ]
                : detail.roles
                      .map(
                        (role) => Chip(
                          label: Text(role),
                          backgroundColor: AppTheme.offWhite,
                        ),
                      )
                      .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(UserDetailView detail) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: AppTheme.borderRadiusMD,
        border: AppTheme.borderThin,
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Email', detail.email ?? '—', Icons.email_outlined),
          const Divider(height: 24),
          _infoRow(
            'Birthday',
            detail.birthDay != null ? _formatDate(detail.birthDay!) : '—',
            Icons.cake_outlined,
          ),
          const Divider(height: 24),
          _infoRow('Status', detail.status, Icons.verified_user_outlined),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.mediumGray),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTheme.bodySmall),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(UserDetailView detail) {
    return Row(
      children: [
        Expanded(child: _statCard('Total Orders', '${detail.totalOrder}')),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard('Total Spent', detail.totalPrice.toStringAsFixed(2)),
        ),
      ],
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: AppTheme.borderRadiusMD,
        border: AppTheme.borderThin,
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.bodySmall),
          const SizedBox(height: 8),
          Text(value, style: AppTheme.h3.copyWith(fontSize: 20)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
