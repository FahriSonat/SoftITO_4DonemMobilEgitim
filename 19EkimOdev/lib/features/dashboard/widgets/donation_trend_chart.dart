import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/date_utils.dart';
import 'chart_data_table.dart';

class TrendDataPoint {
  final String label;
  final int collected;
  final int target;

  const TrendDataPoint({
    required this.label,
    required this.collected,
    required this.target,
  });
}

class DonationTrendChart extends StatefulWidget {
  final List<TrendDataPoint> dataPoints;
  final String dateRange;

  const DonationTrendChart({
    super.key,
    required this.dataPoints,
    required this.dateRange,
  });

  @override
  State<DonationTrendChart> createState() => _DonationTrendChartState();
}

class _DonationTrendChartState extends State<DonationTrendChart> {
  bool _showTable = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalCollected =
        widget.dataPoints.fold<int>(0, (sum, p) => sum + p.collected);
    final totalTarget =
        widget.dataPoints.fold<int>(0, (sum, p) => sum + p.target);

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
                          Icon(Icons.show_chart_rounded,
                              size: 20, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Bağış Toplama Trendi',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Aralık: ${widget.dateRange} • Birim: Ünite Kan • Güncelleme: ${AppDateUtils.formatDateTime(AppDateUtils.now())}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.outlined(
                  tooltip: _showTable ? 'Grafiği Göster' : 'Tabloyu Göster (Erişilebilirlik)',
                  icon: Icon(_showTable
                      ? Icons.insert_chart_outlined_rounded
                      : Icons.table_chart_outlined),
                  onPressed: () => setState(() => _showTable = !_showTable),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Metrics summary banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Toplam Toplanan',
                          style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text(
                        '$totalCollected Ünite',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dönem Hedefi',
                          style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text(
                        '$totalTarget Ünite',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (_showTable)
              ChartDataTable(
                title: 'Bağış Trend Tablosu',
                columns: const ['Aralık', 'Toplanan', 'Hedef', 'Başarı Oranı'],
                rows: widget.dataPoints.map((p) {
                  final pct = p.target > 0
                      ? '%${((p.collected / p.target) * 100).toStringAsFixed(1)}'
                      : '-';
                  return [p.label, '${p.collected} Ünite', '${p.target} Ünite', pct];
                }).toList(),
              )
            else
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 80,
                    minY: 0,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final p = widget.dataPoints[groupIndex];
                          final isCollected = rodIndex == 0;
                          return BarTooltipItem(
                            '${p.label}\n',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: isCollected
                                    ? 'Toplanan: ${rod.toY.toInt()} Ünite'
                                    : 'Hedef: ${rod.toY.toInt()} Ünite',
                                style: TextStyle(
                                  color: isCollected
                                      ? Colors.redAccent
                                      : Colors.lightBlueAccent,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx >= 0 && idx < widget.dataPoints.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  widget.dataPoints[idx].label,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            if (value % 20 == 0) {
                              return Text(
                                '${value.toInt()}',
                                style: const TextStyle(fontSize: 10),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: theme.colorScheme.outlineVariant
                            .withValues(alpha: 0.5),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: widget.dataPoints.asMap().entries.map((entry) {
                      final i = entry.key;
                      final p = entry.value;
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: p.collected.toDouble(),
                            color: theme.colorScheme.primary,
                            width: 12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          BarChartRodData(
                            toY: p.target.toDouble(),
                            color: Colors.blueGrey.withValues(alpha: 0.55),
                            width: 12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _indicator(theme.colorScheme.primary, 'Gerçekleşen Toplama'),
                const SizedBox(width: 16),
                _indicator(
                    Colors.blueGrey.withValues(alpha: 0.55), 'Operasyonel Hedef'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _indicator(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
