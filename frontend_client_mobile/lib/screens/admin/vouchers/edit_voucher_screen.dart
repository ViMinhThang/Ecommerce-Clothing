import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/voucher.dart';
import 'package:frontend_client_mobile/providers/voucher_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../config/theme_config.dart';
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
        _buildSectionCard(
          title: '01_CORE_PARAMETERS',
          children: [
            _buildInputField(
              controller: _codeController,
              label: 'VOUCHER_IDENTIFIER',
              hint: 'E.G. SUMMER50',
              icon: Icons.tag,
              isUppercase: true,
            ),
            const SizedBox(height: 24),
            _buildInputField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'e.g. Get 50% off on all items',
              icon: Icons.description_outlined,
              maxLines: 2,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: '02_FISCAL_RULES',
          children: [
            _buildLabel('DISCOUNT_LOGIC', Icons.category_outlined),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTypeOption(
                    'PERCENTAGE',
                    'Percentage',
                    Icons.percent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTypeOption(
                    'FIXED_AMOUNT',
                    'Fixed',
                    Icons.attach_money,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: _discountValueController,
                    label: _discountType == 'PERCENTAGE'
                        ? 'Value (%)'
                        : 'Amount (\$)',
                    hint: '0',
                    icon: Icons.add_circle_outline,
                    keyboardType: TextInputType.number,
                  ),
                ),
                if (_discountType == 'PERCENTAGE') ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputField(
                      controller: _maxDiscountController,
                      label: 'Cap (\$)',
                      hint: '0',
                      icon: Icons.keyboard_arrow_up,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: '03_VALIDATION_CONSTRAINTS',
          children: [
            _buildInputField(
              controller: _minOrderController,
              label: 'Minimum Purchase (\$)',
              hint: '0',
              icon: Icons.shopping_bag_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            _buildInputField(
              controller: _usageLimitController,
              label: 'Usage Limit',
              hint: '0 = Unlimited',
              icon: Icons.person_outline,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: '04_TEMPORAL_VALIDITY',
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    'Start Date',
                    _startDate,
                    (d) => setState(() => _startDate = d),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDatePicker(
                    'End Date',
                    _endDate,
                    (d) => setState(() => _endDate = d),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: '05_SYSTEM_CONFIGURATION',
          children: [
            _buildLabel('OPERATIONAL_STATUS', Icons.visibility_outlined),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatusOption('ACTIVE', 'Active', Colors.black),
                const SizedBox(width: 12),
                _buildStatusOption('INACTIVE', 'Inactive', Colors.grey[400]!),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.04),
            borderRadius: AppTheme.borderRadiusXS,
          ),
          child: Icon(icon, size: 14, color: Colors.black54),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isUppercase = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, icon),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          textCapitalization: isUppercase
              ? TextCapitalization.characters
              : TextCapitalization.none,
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.black26,
      ),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusXS,
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusXS,
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusXS,
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
    );
  }

  Widget _buildTypeOption(String value, String label, IconData icon) {
    final selected = _discountType == value;
    return GestureDetector(
      onTap: () => setState(() => _discountType = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          borderRadius: AppTheme.borderRadiusXS,
          border: Border.all(
            color: selected
                ? Colors.black
                : Colors.black.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.black54,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.outfit(
                color: selected ? Colors.white : Colors.black54,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(String value, String label, Color color) {
    final selected = _status == value;
    return GestureDetector(
      onTap: () => setState(() => _status = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          borderRadius: AppTheme.borderRadiusXS,
          border: Border.all(
            color: selected
                ? Colors.black
                : Colors.black.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: selected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w800,
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? date,
    Function(DateTime) onSelect,
  ) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, Icons.calendar_today_outlined),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) onSelect(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
              borderRadius: AppTheme.borderRadiusXS,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null
                        ? dateFormat.format(date).toUpperCase()
                        : 'SELECT DATE',
                    style: GoogleFonts.outfit(
                      color: date != null ? Colors.black87 : Colors.black26,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.black26),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
