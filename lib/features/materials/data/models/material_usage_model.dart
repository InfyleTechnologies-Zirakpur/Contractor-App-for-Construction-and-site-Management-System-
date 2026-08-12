/// Tracks consumption of a construction material against a project, so the
/// "material management & usage" dashboards can show requested vs used.
class MaterialUsageModel {
  const MaterialUsageModel({
    required this.id,
    required this.materialName,
    required this.unit,
    required this.requestedQty,
    required this.usedQty,
    this.projectName,
    this.raisedAt,
  });

  final String id;
  final String materialName;
  final String unit;
  final double requestedQty;
  final double usedQty;
  final String? projectName;
  final DateTime? raisedAt;

  double get pendingQty => (requestedQty - usedQty).clamp(0, double.infinity);
  double get usagePercent => requestedQty <= 0
      ? 0
      : (usedQty / requestedQty * 100).clamp(0, 100);

  factory MaterialUsageModel.fromJson(Map<String, dynamic> json) =>
      MaterialUsageModel(
        id: json['id'] as String,
        materialName: json['material_name'] as String,
        unit: json['unit'] as String,
        requestedQty: (json['requested_qty'] as num).toDouble(),
        usedQty: (json['used_qty'] as num).toDouble(),
        projectName: json['project_name'] as String?,
        raisedAt: json['raised_at'] != null
            ? DateTime.tryParse(json['raised_at'])
            : null,
      );
}