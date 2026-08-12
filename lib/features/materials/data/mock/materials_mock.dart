import '../models/material_usage_model.dart';

/// Demo data returned while `AppConfig.mockMode` is true.
class MaterialsMock {
  MaterialsMock._();

  static final List<MaterialUsageModel> usage = [
    MaterialUsageModel(
      id: 'mat-001',
      materialName: 'Cement',
      unit: 'bags',
      requestedQty: 1200,
      usedQty: 760,
      projectName: 'Skyline Residency – Tower B',
      raisedAt: DateTime.now().subtract(const Duration(days: 9)),
    ),
    MaterialUsageModel(
      id: 'mat-002',
      materialName: 'Steel TMT',
      unit: 'tonnes',
      requestedQty: 85,
      usedQty: 54,
      projectName: 'Skyline Residency – Tower B',
      raisedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    MaterialUsageModel(
      id: 'mat-003',
      materialName: 'River Sand',
      unit: 'cu ft',
      requestedQty: 4500,
      usedQty: 1750,
      projectName: 'Green Valley Township Phase 1',
      raisedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    MaterialUsageModel(
      id: 'mat-004',
      materialName: 'Bricks',
      unit: 'thousand',
      requestedQty: 320,
      usedQty: 115,
      projectName: 'Green Valley Township Phase 1',
      raisedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    MaterialUsageModel(
      id: 'mat-005',
      materialName: 'Paint (exterior)',
      unit: 'litres',
      requestedQty: 600,
      usedQty: 600,
      projectName: 'Skyline Residency – Tower B',
      raisedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}