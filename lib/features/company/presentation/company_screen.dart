import 'package:contractor_app/core/constants/app_colors.dart';
import 'package:contractor_app/core/utils/responsive.dart';
import 'package:contractor_app/features/company/data/models/company_model.dart';
import 'package:contractor_app/features/company/data/services/company_service.dart';
import 'package:flutter/material.dart';
import 'register_company_screen.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  bool _loading = true;
  String? _error;
  CompanyModel? _company;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final company = await CompanyService.instance.getCompany();
      if (!mounted) return;
      setState(() => _company = company);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Could not load company profile.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openWizard() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => RegisterCompanyScreen(initial: _company),
      ),
    );
    if (saved == true) _load();
  }

  Future<void> _submitVerification() async {
    await CompanyService.instance
        .submitVerification({'message': 'Verification documents submitted'});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification submitted for review')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                      const SizedBox(height: 12),
                      Text(_error!),
                      const SizedBox(height: 12),
                      OutlinedButton(onPressed: _load, child: const Text('Retry')),
                    ],
                  ),
                )
              : _company == null
                  ? _EmptyCompany(onRegister: _openWizard)
                  : _CompanyProfile(
                      company: _company!,
                      onEdit: _openWizard,
                      onSubmitVerification: _submitVerification,
                    ),
    );
  }
}

class _EmptyCompany extends StatelessWidget {
  const _EmptyCompany({required this.onRegister});

  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_outlined, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text('No company registered yet', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Register your company to post projects, hire workers and get verified.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRegister,
              icon: const Icon(Icons.add_business_outlined),
              label: const Text('Register company'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyProfile extends StatelessWidget {
  const _CompanyProfile({
    required this.company,
    required this.onEdit,
    required this.onSubmitVerification,
  });

  final CompanyModel company;
  final VoidCallback onEdit;
  final Future<void> Function() onSubmitVerification;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (company.verificationStatus) {
      VerificationStatus.pending => AppColors.statusLate,
      VerificationStatus.approved => AppColors.statusPresent,
      VerificationStatus.rejected => AppColors.statusRejected,
    };

    return ListView(
      padding: EdgeInsets.all(context.w(20)),
      children: [
        _HeaderCard(company: company, statusColor: statusColor),
        SizedBox(height: context.h(16)),
        _LegalDetailsCard(company: company),
        SizedBox(height: context.h(16)),
        _ContactCard(company: company),
        SizedBox(height: context.h(16)),
        _AddressCard(company: company),
        SizedBox(height: context.h(16)),
        _ScopeCard(company: company),
        SizedBox(height: context.h(20)),
        if (company.verificationStatus != VerificationStatus.approved) ...[
          ElevatedButton.icon(
            onPressed: onSubmitVerification,
            icon: const Icon(Icons.verified_user_outlined),
            label: const Text('Submit for verification'),
          ),
          SizedBox(height: context.h(10)),
        ],
        OutlinedButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit company details'),
        ),
        SizedBox(height: context.h(20)),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.company, required this.statusColor});

  final CompanyModel company;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusLabel = switch (company.verificationStatus) {
      VerificationStatus.pending => 'Pending Verification',
      VerificationStatus.approved => 'Verified',
      VerificationStatus.rejected => 'Verification Rejected',
    };

    return Container(
      padding: EdgeInsets.all(context.w(18)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.w(12)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(context.w(12)),
                ),
                child: Icon(Icons.business, color: AppColors.primary, size: context.sp(26)),
              ),
              SizedBox(width: context.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.name, style: theme.textTheme.titleMedium),
                    Text(
                      companyTypeLabel(company.type),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(10),
              vertical: context.h(6),
            ),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_outlined, size: context.sp(16), color: statusColor),
                SizedBox(width: context.w(6)),
                Text(
                  statusLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (company.yearEstablished != null) ...[
            SizedBox(height: context.h(12)),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              text: 'Established ${company.yearEstablished}',
            ),
          ],
          if (company.description != null) ...[
            SizedBox(height: context.h(8)),
            Text(company.description!, style: theme.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _LegalDetailsCard extends StatelessWidget {
  const _LegalDetailsCard({required this.company});

  final CompanyModel company;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Registration & legal',
      icon: Icons.description_outlined,
      children: [
        _InfoRow(icon: Icons.badge_outlined, text: 'GSTIN: ${company.gstin}'),
        _InfoRow(icon: Icons.credit_card_outlined, text: 'PAN: ${company.pan}'),
        _OptionalLegalRow(text: company.cin, label: 'CIN'),
        _OptionalLegalRow(text: company.udyamRegistrationNumber, label: 'Udyam Reg. No.'),
        _OptionalLegalRow(text: company.labourLicenseNumber, label: 'Labour License No.'),
        _OptionalLegalRow(text: company.pfEsicNumber, label: 'PF / ESIC No.'),
      ],
    );
  }
}

class _OptionalLegalRow extends StatelessWidget {
  const _OptionalLegalRow({required this.text, required this.label});

  final String? text;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _InfoRow(icon: Icons.label_outline, text: '$label: ${text ?? '—'}');
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.company});

  final CompanyModel company;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Contact',
      icon: Icons.contact_phone_outlined,
      children: [
        _InfoRow(
          icon: Icons.person_outline,
          text:
              '${company.contactPersonName} (${company.contactPersonDesignation})',
        ),
        _InfoRow(icon: Icons.phone_outlined, text: company.contactPhone),
        if (company.alternatePhone != null)
          _InfoRow(icon: Icons.phone_iphone, text: 'Alt: ${company.alternatePhone}'),
        _InfoRow(icon: Icons.email_outlined, text: company.contactEmail),
        if (company.website != null)
          _InfoRow(icon: Icons.language_outlined, text: company.website!),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.company});

  final CompanyModel company;

  @override
  Widget build(BuildContext context) {
    final reg = company.registeredAddress;
    return _SectionCard(
      title: 'Addresses',
      icon: Icons.location_on_outlined,
      children: [
        _InfoRow(
          icon: Icons.home_outlined,
          text: 'Registered: ${_formatAddress(reg)}',
        ),
        if (company.operationalAddress != null)
          _InfoRow(
            icon: Icons.location_city_outlined,
            text: 'Operational: ${_formatAddress(company.operationalAddress!)}',
          )
        else
          const _InfoRow(
            icon: Icons.location_city_outlined,
            text: 'Operational: same as registered',
          ),
      ],
    );
  }

  String _formatAddress(AddressModel address) {
    final parts = [address.line1, address.line2, address.city, address.state, address.pincode]
        .whereType<String>()
        .where((p) => p.trim().isNotEmpty)
        .toList();
    return parts.join(', ');
  }
}

class _ScopeCard extends StatelessWidget {
  const _ScopeCard({required this.company});

  final CompanyModel company;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Business scope',
      icon: Icons.insights_outlined,
      children: [
        _ChipRow(label: 'Specializations', values: company.specializations),
        _ChipRow(label: 'Areas of operation', values: company.areasOfOperation),
        if (company.teamSizeRange != null)
          _InfoRow(icon: Icons.groups_outlined, text: 'Team size: ${company.teamSizeRange}'),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: context.sp(18), color: AppColors.primary),
              SizedBox(width: context.w(8)),
              Text(title, style: theme.textTheme.titleSmall),
            ],
          ),
          SizedBox(height: context.h(12)),
          ...children,
        ],
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.label, required this.values});

  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          SizedBox(height: context.h(6)),
          if (values.isEmpty)
            Text('—', style: theme.textTheme.bodyMedium)
          else
            Wrap(
              spacing: context.w(6),
              runSpacing: context.h(6),
              children: [
                for (final value in values)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(8),
                      vertical: context.h(3),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      value,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.h(2)),
            child: Icon(icon, size: context.sp(16), color: AppColors.textSecondary),
          ),
          SizedBox(width: context.w(8)),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}