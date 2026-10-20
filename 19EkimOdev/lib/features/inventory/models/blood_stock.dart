import 'package:flutter/material.dart';
import '../../../core/theme/status_colors.dart';

enum StockStatus {
  critical(
    label: 'Kritik',
    icon: Icons.warning_rounded,
    color: StatusColors.critical,
    bgColor: StatusColors.criticalBackground,
    textColor: StatusColors.criticalText,
  ),
  low(
    label: 'Düşük',
    icon: Icons.report_problem_rounded,
    color: StatusColors.low,
    bgColor: StatusColors.lowBackground,
    textColor: StatusColors.lowText,
  ),
  sufficient(
    label: 'Yeterli',
    icon: Icons.check_circle_rounded,
    color: StatusColors.sufficient,
    bgColor: StatusColors.sufficientBackground,
    textColor: StatusColors.sufficientText,
  ),
  surplus(
    label: 'Fazla',
    icon: Icons.inventory_2_rounded,
    color: StatusColors.surplus,
    bgColor: StatusColors.surplusBackground,
    textColor: StatusColors.surplusText,
  );

  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final Color textColor;

  const StockStatus({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.textColor,
  });

  static StockStatus fromRatio(double ratio) {
    if (ratio < 0.35) return StockStatus.critical;
    if (ratio < 0.65) return StockStatus.low;
    if (ratio <= 1.25) return StockStatus.sufficient;
    return StockStatus.surplus;
  }
}

class BloodStock {
  final String bloodGroup;
  final int currentUnits;
  final int targetUnits;
  final DateTime lastUpdated;

  const BloodStock({
    required this.bloodGroup,
    required this.currentUnits,
    required this.targetUnits,
    required this.lastUpdated,
  });

  double get ratio => targetUnits > 0 ? (currentUnits / targetUnits) : 0.0;
  StockStatus get status => StockStatus.fromRatio(ratio);

  BloodStock copyWith({
    String? bloodGroup,
    int? currentUnits,
    int? targetUnits,
    DateTime? lastUpdated,
  }) {
    return BloodStock(
      bloodGroup: bloodGroup ?? this.bloodGroup,
      currentUnits: currentUnits ?? this.currentUnits,
      targetUnits: targetUnits ?? this.targetUnits,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
