import 'package:flutter/material.dart';
import '../../../core/utils/number_utils.dart';
import '../../inventory/models/blood_stock.dart';
import 'chart_data_table.dart';

class BloodStockChart extends StatefulWidget {
  final List<BloodStock> stocks;

  const BloodStockChart({super.key, required this.stocks});

  @override
  State<BloodStockChart> createState() => _BloodStockChartState();
}

class _BloodStockChartState extends State<BloodStockChart> {
  bool _showTable = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sorted = List<BloodStock>.from(widget.stocks)
      ..sort((a, b) => a.ratio.compareTo(b.ratio));

    final totalCurrent = sorted.fold<int>(0, (sum, s) => sum + s.currentUnits);
    final totalTarget = sorted.fold<int>(0, (sum, s) => sum + s.targetUnits);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 20, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Kan Grubu Dağılımı ve Hedef Grafiği',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Acil ihtiyaç duyulan gruplar üstte listelenir • Birim: Ünite',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.outlined(
                  tooltip: _showTable ? 'Grafiği Göster' : 'Tabloyu Göster',
                  icon: Icon(_showTable
                      ? Icons.bar_chart_rounded
                      : Icons.table_chart_outlined),
                  onPressed: () => setState(() => _showTable = !_showTable),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Toplam Rezerv: ${AppNumberUtils.formatUnits(totalCurrent)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Text(
                  'Hedef: ${AppNumberUtils.formatUnits(totalTarget)}',
                  style: TextStyle(color: theme.colorScheme.outline),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_showTable)
              ChartDataTable(
                title: 'Stok ve Hedef Dağılım Tablosu',
                columns: const [
                  'Kan Grubu',
                  'Mevcut',
                  'Hedef',
                  'Doluluk Oranı',
                  'Durum'
                ],
                rows: sorted.map((s) {
                  return [
                    s.bloodGroup,
                    '${s.currentUnits} Ünite',
                    '${s.targetUnits} Ünite',
                    AppNumberUtils.formatPercent(s.ratio),
                    s.status.label,
                  ];
                }).toList(),
              )
            else
              Column(
                children: sorted.map((stock) {
                  final status = stock.status;
                  final ratio = stock.ratio.clamp(0.0, 1.5);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 44,
                          child: Text(
                            stock.bloodGroup,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: (ratio / 1.25).clamp(0.0, 1.0),
                                  minHeight: 12,
                                  backgroundColor:
                                      theme.colorScheme.surfaceContainerHighest,
                                  color: status.color,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${stock.currentUnits} / ${stock.targetUnits} Ünite',
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.grey),
                                  ),
                                  Text(
                                    AppNumberUtils.formatPercent(stock.ratio),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: status.color,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: status.bgColor,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: status.color.withValues(alpha: 0.4)),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(status.icon, size: 14, color: status.textColor),
                                const SizedBox(width: 4),
                                Text(
                                  status.label,
                                  style: TextStyle(
                                    color: status.textColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
