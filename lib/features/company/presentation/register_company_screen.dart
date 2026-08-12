import 'package:contractor_app/core/constants/app_colors.dart';
import 'package:contractor_app/core/utils/responsive.dart';
import 'package:contractor_app/features/company/data/models/company_model.dart';
import 'package:contractor_app/features/company/data/services/company_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const List<String> kSpecializationOptions = [
  'Civil',
  'Electrical',
  'Plumbing',
  'Painting',
  'Steel Fabrication',
  'Interiors',
  'HVAC',
  'Roofing',
  'Flooring',
  'Landscaping',
];

const List<String> kOperationAreaOptions = [
  'Ludhiana',
  'Chandigarh',
  'Mohali',
  'Bathinda',
  'Patiala',
  'Jalandhar',
  'Amritsar',
  'Delhi NCR',
];

const List<String> kTeamSizeOptions = [
  '1-10',
  '10-50',
  '50-100',
  '100-500',
  '500+',
];

class RegisterCompanyScreen extends StatefulWidget {
  const RegisterCompanyScreen({super.key, this.initial});

  final CompanyModel? initial;

  @override
  State<RegisterCompanyScreen> createState() => _RegisterCompanyScreenState();
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  static final _gstinRegex = RegExp(r'^[0-9A-Z]{15}$');
  static final _panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');

  int _step = 0;
  String? _error;
  bool _submitting = false;

  // Step 1 — required basics
  final _name = TextEditingController();
  CompanyType? _type;
  final _gstin = TextEditingController();
  final _pan = TextEditingController();
  final _contactPerson = TextEditingController();
  final _designation = TextEditingController();
  final _contactPhone = TextEditingController();
  final _contactEmail = TextEditingController();
  final _regLine1 = TextEditingController();
  final _regLine2 = TextEditingController();
  final _regCity = TextEditingController();
  final _regState = TextEditingController();
  final _regPincode = TextEditingController();

  // Step 2 — optional details
  final _yearEstablished = TextEditingController();
  final _description = TextEditingController();
  String? _logoPath;
  final _alternatePhone = TextEditingController();
  final _website = TextEditingController();
  final _cin = TextEditingController();
  final _udyam = TextEditingController();
  final _labourLicense = TextEditingController();
  final _pfEsic = TextEditingController();
  bool _sameAsOperational = true;
  final _opLine1 = TextEditingController();
  final _opLine2 = TextEditingController();
  final _opCity = TextEditingController();
  final _opState = TextEditingController();
  final _opPincode = TextEditingController();

  // Step 3 — business scope
  final Set<String> _specializations = {};
  final Set<String> _areasOfOperation = {};
  String? _teamSizeRange;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final c = widget.initial;
    if (c != null) {
      _name.text = c.name;
      _type = c.type;
      _gstin.text = c.gstin;
      _pan.text = c.pan;
      _contactPerson.text = c.contactPersonName;
      _designation.text = c.contactPersonDesignation;
      _contactPhone.text = c.contactPhone;
      _alternatePhone.text = c.alternatePhone ?? '';
      _contactEmail.text = c.contactEmail;
      _website.text = c.website ?? '';
      _yearEstablished.text = c.yearEstablished?.toString() ?? '';
      _description.text = c.description ?? '';
      _logoPath = c.logoUrl;
      _cin.text = c.cin ?? '';
      _udyam.text = c.udyamRegistrationNumber ?? '';
      _labourLicense.text = c.labourLicenseNumber ?? '';
      _pfEsic.text = c.pfEsicNumber ?? '';
      _regLine1.text = c.registeredAddress.line1;
      _regLine2.text = c.registeredAddress.line2 ?? '';
      _regCity.text = c.registeredAddress.city;
      _regState.text = c.registeredAddress.state;
      _regPincode.text = c.registeredAddress.pincode;
      final op = c.operationalAddress;
      if (op != null) {
        _sameAsOperational = false;
        _opLine1.text = op.line1;
        _opLine2.text = op.line2 ?? '';
        _opCity.text = op.city;
        _opState.text = op.state;
        _opPincode.text = op.pincode;
      }
      _specializations.addAll(c.specializations);
      _areasOfOperation.addAll(c.areasOfOperation);
      _teamSizeRange = c.teamSizeRange;
    }
  }

  @override
  void dispose() {
    for (final c in [
      _name, _gstin, _pan, _contactPerson, _designation, _contactPhone,
      _contactEmail, _regLine1, _regLine2, _regCity, _regState, _regPincode,
      _yearEstablished, _description, _alternatePhone, _website, _cin, _udyam,
      _labourLicense, _pfEsic, _opLine1, _opLine2, _opCity, _opState, _opPincode,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _validateStep(int step) {
    switch (step) {
      case 0:
        if (_name.text.trim().isEmpty) return 'Company name is required.';
        if (_type == null) return 'Select the company type.';
        if (!_gstinRegex.hasMatch(_gstin.text.trim().toUpperCase())) {
          return 'GSTIN must be exactly 15 characters (letters/numbers).';
        }
        if (!_panRegex.hasMatch(_pan.text.trim().toUpperCase())) {
          return 'PAN must be 10 characters (e.g. ABCD E1234F).';
        }
        if (_contactPerson.text.trim().isEmpty) return 'Contact person name is required.';
        if (_designation.text.trim().isEmpty) return 'Designation is required.';
        if (_contactPhone.text.trim().isEmpty) return 'Contact phone is required.';
        if (!_contactEmail.text.trim().contains('@')) return 'Enter a valid contact email.';
        if (_regLine1.text.trim().isEmpty ||
            _regCity.text.trim().isEmpty ||
            _regState.text.trim().isEmpty ||
            _regPincode.text.trim().isEmpty) {
          return 'Registered address (line 1, city, state, pincode) is required.';
        }
        return null;
      case 1:
        if (!_sameAsOperational &&
            (_opLine1.text.trim().isEmpty ||
                _opCity.text.trim().isEmpty ||
                _opState.text.trim().isEmpty ||
                _opPincode.text.trim().isEmpty)) {
          return 'Operational address (line 1, city, state, pincode) is required.';
        }
        if (_yearEstablished.text.trim().isNotEmpty &&
            int.tryParse(_yearEstablished.text.trim()) == null) {
          return 'Year established must be a number.';
        }
        if (_website.text.trim().isNotEmpty && !_website.text.trim().contains('.')) {
          return 'Website looks invalid.';
        }
        return null;
      default:
        return null;
    }
  }

  void _next() {
    final error = _validateStep(_step);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() {
      _error = null;
      _step++;
    });
  }

  void _back() {
    setState(() {
      _error = null;
      _step--;
    });
  }

  Future<void> _pickLogo() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    if (!mounted) return;
    setState(() => _logoPath = picked.path);
  }

  AddressModel _address(
    TextEditingController line1,
    TextEditingController line2,
    TextEditingController city,
    TextEditingController state,
    TextEditingController pincode,
  ) {
    final line2Text = line2.text.trim();
    return AddressModel(
      line1: line1.text.trim(),
      line2: line2Text.isEmpty ? null : line2Text,
      city: city.text.trim(),
      state: state.text.trim(),
      pincode: pincode.text.trim(),
    );
  }

  String? _opt(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  CompanyModel _buildModel() => CompanyModel(
        id: widget.initial?.id ?? 'pending-id',
        name: _name.text.trim(),
        type: _type!,
        yearEstablished: int.tryParse(_yearEstablished.text.trim()),
        logoUrl: _logoPath,
        description: _opt(_description),
        gstin: _gstin.text.trim().toUpperCase(),
        pan: _pan.text.trim().toUpperCase(),
        cin: _opt(_cin),
        udyamRegistrationNumber: _opt(_udyam),
        labourLicenseNumber: _opt(_labourLicense),
        pfEsicNumber: _opt(_pfEsic),
        contactPersonName: _contactPerson.text.trim(),
        contactPersonDesignation: _designation.text.trim(),
        contactPhone: _contactPhone.text.trim(),
        alternatePhone: _opt(_alternatePhone),
        contactEmail: _contactEmail.text.trim(),
        website: _opt(_website),
        registeredAddress: _address(
            _regLine1, _regLine2, _regCity, _regState, _regPincode),
        operationalAddress: _sameAsOperational
            ? null
            : _address(_opLine1, _opLine2, _opCity, _opState, _opPincode),
        specializations: _specializations.toList(),
        areasOfOperation: _areasOfOperation.toList(),
        teamSizeRange: _teamSizeRange,
        verificationStatus: widget.initial?.verificationStatus ??
            VerificationStatus.pending,
      );

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final method = _isEdit
          ? CompanyService.instance.updateProfile(_buildModel())
          : CompanyService.instance.registerCompany(_buildModel());
      await method;
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Could not save. Try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit company' : 'Register company'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _ProgressHeader(step: _step, total: 3),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(context.w(20)),
                children: [
                  if (_step == 0) _buildBasicsStep(theme),
                  if (_step == 1) _buildOptionalStep(theme),
                  if (_step == 2) _buildScopeStep(theme),
                  if (_error != null) ...[
                    SizedBox(height: context.h(12)),
                    Text(
                      _error!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.error),
                    ),
                  ],
                ],
              ),
            ),
            _buildControls(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(context.w(20)),
      child: Row(
        children: [
          if (_step > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _submitting ? null : _back,
                child: const Text('Back'),
              ),
            ),
          if (_step > 0) SizedBox(width: context.w(12)),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _submitting
                  ? null
                  : _step == 2
                      ? _submit
                      : _next,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(_step == 2 ? 'Submit' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicsStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Company basics', style: theme.textTheme.titleLarge),
        SizedBox(height: context.h(6)),
        Text(
          'Required information to get started.',
          style: theme.textTheme.bodySmall,
        ),
        SizedBox(height: context.h(20)),
        TextField(
          controller: _name,
          decoration: const InputDecoration(labelText: 'Company name'),
        ),
        SizedBox(height: context.h(12)),
        DropdownButtonFormField<CompanyType>(
          initialValue: _type,
          decoration: const InputDecoration(
            labelText: 'Company type',
            hintText: 'Select type',
          ),
          items: [
            for (final type in CompanyType.values)
              DropdownMenuItem(value: type, child: Text(companyTypeLabel(type))),
          ],
          onChanged: (value) => setState(() => _type = value),
        ),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _gstin,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'GSTIN',
            hintText: '15-character GSTIN',
          ),
        ),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _pan,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'PAN',
            hintText: '10-character PAN',
          ),
        ),
        SizedBox(height: context.h(20)),
        Text('Contact person', style: theme.textTheme.titleMedium),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _contactPerson,
          decoration: const InputDecoration(labelText: 'Contact person name'),
        ),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _designation,
          decoration: const InputDecoration(labelText: 'Designation'),
        ),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _contactPhone,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: 'Contact phone'),
        ),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _contactEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Contact email'),
        ),
        SizedBox(height: context.h(20)),
        Text('Registered address', style: theme.textTheme.titleMedium),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _regLine1,
          decoration: const InputDecoration(labelText: 'Address line 1'),
        ),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _regLine2,
          decoration: const InputDecoration(labelText: 'Address line 2 (optional)'),
        ),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _regCity,
          decoration: const InputDecoration(labelText: 'City'),
        ),
        SizedBox(height: context.h(12)),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _regState,
                decoration: const InputDecoration(labelText: 'State'),
              ),
            ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: TextField(
                controller: _regPincode,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Pincode'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionalStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Optional details', style: theme.textTheme.titleLarge),
        SizedBox(height: context.h(6)),
        Text(
          'Everything here is optional — you can add these later.',
          style: theme.textTheme.bodySmall,
        ),
        SizedBox(height: context.h(20)),
        TextField(
          controller: _yearEstablished,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Year established (optional)'),
        ),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _description,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Company description (optional)',
            alignLabelWithHint: true,
          ),
        ),
        SizedBox(height: context.h(12)),
        OutlinedButton.icon(
          onPressed: _pickLogo,
          icon: const Icon(Icons.image_outlined),
          label: Text(_logoPath == null
              ? 'Upload logo (optional)'
              : 'Logo selected — tap to change'),
        ),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _alternatePhone,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: 'Alternate phone (optional)'),
        ),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _website,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(labelText: 'Website (optional)'),
        ),
        SizedBox(height: context.h(20)),
        Text('Registration & legal', style: theme.textTheme.titleMedium),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _cin,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'CIN (optional)',
            hintText: 'For private limited / LLPs',
          ),
        ),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _udyam,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Udyam registration number (optional)',
          ),
        ),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _labourLicense,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Labour license number (optional)',
          ),
        ),
        SizedBox(height: context.h(12)),
        TextField(
          controller: _pfEsic,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'PF / ESIC number (optional)',
          ),
        ),
        SizedBox(height: context.h(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Operational address', style: theme.textTheme.titleMedium),
            const Spacer(),
            // Text('Same as registered', style: theme.textTheme.bodySmall),
            Switch(
              value: _sameAsOperational,
              onChanged: (value) => setState(() => _sameAsOperational = value),
            ),
          ],
        ),
        SizedBox(height: context.h(8)),
        if (!_sameAsOperational) ...[
          TextField(
            controller: _opLine1,
            decoration: const InputDecoration(labelText: 'Operational address line 1'),
          ),
          SizedBox(height: context.h(12)),
          TextField(
            controller: _opLine2,
            decoration: const InputDecoration(
              labelText: 'Operational address line 2 (optional)',
            ),
          ),
          SizedBox(height: context.h(12)),
          TextField(
            controller: _opCity,
            decoration: const InputDecoration(labelText: 'City'),
          ),
          SizedBox(height: context.h(12)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _opState,
                  decoration: const InputDecoration(labelText: 'State'),
                ),
              ),
              SizedBox(width: context.w(12)),
              Expanded(
                child: TextField(
                  controller: _opPincode,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Pincode'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildScopeStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Business scope', style: theme.textTheme.titleLarge),
        SizedBox(height: context.h(6)),
        Text(
          'Tell builders what you do and where you work.',
          style: theme.textTheme.bodySmall,
        ),
        SizedBox(height: context.h(20)),
        Text('Specializations (optional)', style: theme.textTheme.titleMedium),
        SizedBox(height: context.h(10)),
        Wrap(
          spacing: context.w(8),
          runSpacing: context.h(8),
          children: [
            for (final option in kSpecializationOptions)
              FilterChip(
                label: Text(option),
                selected: _specializations.contains(option),
                onSelected: (selected) => setState(() {
                  selected
                      ? _specializations.add(option)
                      : _specializations.remove(option);
                }),
              ),
          ],
        ),
        SizedBox(height: context.h(20)),
        Text('Areas of operation (optional)', style: theme.textTheme.titleMedium),
        SizedBox(height: context.h(10)),
        Wrap(
          spacing: context.w(8),
          runSpacing: context.h(8),
          children: [
            for (final option in kOperationAreaOptions)
              FilterChip(
                label: Text(option),
                selected: _areasOfOperation.contains(option),
                onSelected: (selected) => setState(() {
                  selected
                      ? _areasOfOperation.add(option)
                      : _areasOfOperation.remove(option);
                }),
              ),
          ],
        ),
        SizedBox(height: context.h(20)),
        Text('Team size range (optional)', style: theme.textTheme.titleMedium),
        SizedBox(height: context.h(10)),
        Wrap(
          spacing: context.w(8),
          runSpacing: context.h(8),
          children: [
            for (final option in kTeamSizeOptions)
              ChoiceChip(
                label: Text(option),
                selected: _teamSizeRange == option,
                onSelected: (_) => setState(() => _teamSizeRange = option),
              ),
          ],
        ),
      ],
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
          context.w(20), context.h(16), context.w(20), context.h(8)),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step ${step + 1} of $total',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.h(6)),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (step + 1) / total,
              minHeight: context.h(6),
              backgroundColor: AppColors.border,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}