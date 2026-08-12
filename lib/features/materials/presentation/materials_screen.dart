import 'package:contractor_app/core/constants/app_colors.dart';
import 'package:contractor_app/core/utils/responsive.dart';
import 'package:contractor_app/features/materials/data/models/material_usage_model.dart';
import 'package:contractor_app/features/materials/data/services/material_service.dart';
import 'package:flutter/material.dart';
import 'material_usage_card.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  List<MaterialUsageModel> _usage = [];
  bool _loading = true;
  String? _error;

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
      final usage = await MaterialService.instance.getMaterialUsage();
      if (!mounted) return;
      setState(() => _usage = usage);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Could not load material usage.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Materials')),
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
              : ListView(
                  padding: EdgeInsets.all(context.w(20)),
                  children: [
                    _TotalsRow(usage: _usage),
                    SizedBox(height: context.h(16)),
                    Text('Usage by material', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: context.h(10)),
                    for (final item in _usage)
                      Padding(
                        padding: EdgeInsets.only(bottom: context.h(10)),
                        child: MaterialUsageCard(usage: item),
                      ),
                  ],
                ),
    );
  }
}

class _TotalsRow extends StatelessWidget {
  const _TotalsRow({required this.usage});

  final List<MaterialUsageModel> usage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalRequested =
        usage.fold<double>(0, (sum, item) => sum + item.requestedQty);
    final totalUsed = usage.fold<double>(0, (sum, item) => sum + item.usedQty);
    final overallPercent =
        totalRequested <= 0 ? 0 : (totalUsed / totalRequested * 100).round();

    Widget stat(String label, String value, {Color? color}) => Expanded(
          child: Container(
            padding: EdgeInsets.all(context.w(14)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(context.w(14)),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: theme.textTheme.labelLarge?.copyWith(color: color)),
                SizedBox(height: context.h(4)),
                Text(label,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );

    return Row(
      children: [
        stat('Materials', usage.length.toString()),
        SizedBox(width: context.w(10)),
        stat('Total used', totalUsed.toInt().toString()),
        SizedBox(width: context.w(10)),
        stat('Consumed', '$overallPercent%', color: AppColors.primary),
      ],
    );
  }
}