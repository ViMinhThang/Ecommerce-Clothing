import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/voucher.dart';
import 'package:frontend_client_mobile/providers/voucher_provider.dart';
import 'package:provider/provider.dart';
import '../../../features/admin/voucher/edit/sections/basic_info_section.dart';
import '../../../features/admin/voucher/edit/sections/discount_settings_section.dart';
import '../../../features/admin/voucher/edit/sections/usage_limits_section.dart';
import '../../../features/admin/voucher/edit/sections/valid_period_section.dart';
import '../../../features/admin/voucher/edit/sections/status_section.dart';
import '../base/base_edit_screen.dart';

class EditVoucherScreen extends BaseEditScreen<Voucher> {
  const EditVoucherScreen({super.key, super.entity});

  @override
  State<EditVoucherScreen> createState() => _EditVoucherScreenState();
}

class _EditVoucherScreenState
    extends BaseEditScreenState<Voucher, EditVoucherScreen> {
  late final TextEditingController _codeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _discountValueController;
  late final TextEditingController _minOrderController;
  late final TextEditingController _maxDiscountController;
  late final TextEditingController _usageLimitController;

  String _discountType = 'PERCENTAGE';
  String _status = 'ACTIVE';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  String getScreenTitle() => isEditing ? 'Edit Voucher' : 'Add Voucher';

  @override
  int getSelectedIndex() => 7;

  @override
  String getEntityName() => 'Voucher';

  @override
  IconData getSectionIcon() => Icons.local_offer_outlined;

  @override
  void initializeForm() {
    _codeController = TextEditingController(text: widget.entity?.code ?? '');
    _descriptionController = TextEditingController(
      text: widget.entity?.description ?? '',
    );
    _discountValueController = TextEditingController(
      text: widget.entity?.discountValue.toString() ?? '',
    );
    _minOrderController = TextEditingController(
      text: widget.entity?.minOrderAmount.toString() ?? '0',
    );
    _maxDiscountController = TextEditingController(
      text: widget.entity?.maxDiscountAmount.toString() ?? '0',
    );
    _usageLimitController = TextEditingController(
      text: widget.entity?.usageLimit.toString() ?? '0',
    );

    if (widget.entity != null) {
      _discountType = widget.entity!.discountType;
      _status = widget.entity!.status;
      _startDate = widget.entity!.startDate;
      _endDate = widget.entity!.endDate;
    }
  }

  @override
  void disposeControllers() {
    _codeController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    _minOrderController.dispose();
    _maxDiscountController.dispose();
    _usageLimitController.dispose();
  }

  @override
  bool validateForm() {
    return _codeController.text.trim().isNotEmpty &&
        _discountValueController.text.trim().isNotEmpty;
  }

  @override
  Future<void> saveEntity() async {
    final provider = Provider.of<VoucherProvider>(context, listen: false);

    final data = {
      'code': _codeController.text.toUpperCase(),
      'description': _descriptionController.text,
      'discountType': _discountType,
      'discountValue': double.tryParse(_discountValueController.text) ?? 0,
      'minOrderAmount': double.tryParse(_minOrderController.text) ?? 0,
      'maxDiscountAmount': double.tryParse(_maxDiscountController.text) ?? 0,
      'startDate': _startDate?.toIso8601String(),
      'endDate': _endDate?.toIso8601String(),
      'usageLimit': int.tryParse(_usageLimitController.text) ?? 0,
      'status': _status,
    };

    bool success;
    if (isEditing) {
      success = await provider.updateVoucher(widget.entity!.id, data);
    } else {
      success = await provider.createVoucher(data);
    }

    if (!success) {
      throw Exception(provider.error ?? 'Failed to save voucher');
    }
  }

  @override
  Widget buildFormFields() {
    return Column(
      children: [
        VoucherBasicInfoSection(
          codeController: _codeController,
          descriptionController: _descriptionController,
        ),
        const SizedBox(height: 16),
        DiscountSettingsSection(
          discountType: _discountType,
          discountValueController: _discountValueController,
          maxDiscountController: _maxDiscountController,
          onDiscountTypeChanged: (value) =>
              setState(() => _discountType = value),
        ),
        const SizedBox(height: 16),
        UsageLimitsSection(
          minOrderController: _minOrderController,
          usageLimitController: _usageLimitController,
        ),
        const SizedBox(height: 16),
        ValidPeriodSection(
          startDate: _startDate,
          endDate: _endDate,
          onStartDateChanged: (d) => setState(() => _startDate = d),
          onEndDateChanged: (d) => setState(() => _endDate = d),
        ),
        const SizedBox(height: 16),
        VoucherStatusSection(
          status: _status,
          onStatusChanged: (value) => setState(() => _status = value),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
