import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/state/app_state.dart';
import '../../core/utils/number_utils.dart';
import '../inventory/models/blood_stock.dart';
import 'widgets/blood_stock_chart.dart';
import 'widgets/donation_trend_chart.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onNavigateToAppointments;
  final VoidCallback onNavigateToInventory;
  final VoidCallback onNavigateToCenters;

  const DashboardScreen({
    super.key,
    required this.onNavigateToAppointments,
    required this.onNavigateToInventory,
    required this.onNavigateToCenters,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedDaysFilter = 7;

  List<TrendDataPoint> _getTrendData(int days) {
    if (days == 7) {
      return const [
        TrendDataPoint(label: 'Pzt', collected: 42, target: 50),
        TrendDataPoint(label: 'Sal', collected: 48, target: 50),
        TrendDataPoint(label: 'Çar', collected: 55, target: 50),
        TrendDataPoint(label: 'Per', collected: 39, target: 50),
        TrendDataPoint(label: 'Cum', collected: 62, target: 50),
        TrendDataPoint(label: 'Cmt', collected: 70, target: 60),
        TrendDataPoint(label: 'Paz', collected: 34, target: 40),
      ];
    } else {
      return const [
        TrendDataPoint(label: '1-5 Gün', collected: 210, target: 220),
        TrendDataPoint(label: '6-10 Gün', collected: 235, target: 230),
        TrendDataPoint(label: '11-15 Gün', collected: 198, target: 220),
        TrendDataPoint(label: '16-20 Gün', collected: 242, target: 230),
        TrendDataPoint(label: '21-25 Gün', collected: 260, target: 240),
        TrendDataPoint(label: '26-30 Gün', collected: 255, target: 240),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final role = AppState.instance.role;
        final stocks = AppState.instance.stocks;
        final appointments = AppState.instance.appointments;

        final criticalStocks =
            stocks.where((s) => s.status == StockStatus.critical).toList();
        final upcomingAppointments =
            appointments.where((a) => a.status == 'Planlandı').toList();

        final trendPoints = _getTrendData(_selectedDaysFilter);
        final totalCollected =
            trendPoints.fold<int>(0, (sum, p) => sum + p.collected);
        final totalTarget =
            trendPoints.fold<int>(0, (sum, p) => sum + p.target);
        final fulfillmentRate =
            totalTarget > 0 ? (totalCollected / totalTarget) : 1.0;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.water_drop_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  AppConstants.appName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Role Switcher Card
                    Card(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.35),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.badge_outlined,
                                    size: 18, color: theme.colorScheme.primary),
                                const SizedBox(width: 6),
                                const Expanded(
                                  child: Text(
                                    'Aktif Rol Seçici (Simülasyon / Test)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    AppConstants.demoDataLabel,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SegmentedButton<UserRole>(
                              segments: UserRole.values
                                  .map((r) => ButtonSegment<UserRole>(
                                        value: r,
                                        label: Text(r.title),
                                        icon: Icon(
                                          r == UserRole.donor
                                              ? Icons.favorite_border_rounded
                                              : r == UserRole.staff
                                                  ? Icons.medical_services_outlined
                                                  : Icons.admin_panel_settings_outlined,
                                          size: 16,
                                        ),
                                      ))
                                  .toList(),
                              selected: {role},
                              onSelectionChanged: (set) {
                                AppState.instance.setRole(set.first);
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              role.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Critical Stock Warning Banner
                    if (criticalStocks.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEF9A9A)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_rounded,
                                color: Color(0xFFC62828), size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Kritik Kan Rezervi Uyarısı',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB71C1C),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${criticalStocks.map((s) => s.bloodGroup).join(', ')} gruplarında stok seviyesi acil eşiğin altında!',
                                    style: const TextStyle(
                                      color: Color(0xFFB71C1C),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: widget.onNavigateToInventory,
                              child: const Text('Stokları Gör'),
                            ),
                          ],
                        ),
                      ),

                    // Operational Summary Metric Cards
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _SummaryCard(
                          title: 'Dönem Toplam Bağış',
                          value: '${AppNumberUtils.formatInteger(totalCollected)} Ünite',
                          subtitle: 'Son $_selectedDaysFilter Gün Toplamı',
                          icon: Icons.water_drop_rounded,
                          iconColor: theme.colorScheme.primary,
                        ),
                        _SummaryCard(
                          title: 'Kritik Kan Grubu',
                          value: '${criticalStocks.length} Grup',
                          subtitle: 'O-, B-, AB- acil',
                          icon: Icons.warning_amber_rounded,
                          iconColor: const Color(0xFFD32F2F),
                        ),
                        _SummaryCard(
                          title: 'Hedef Karşılama',
                          value: AppNumberUtils.formatPercent(fulfillmentRate),
                          subtitle: 'Dönem içi başarı',
                          icon: Icons.track_changes_rounded,
                          iconColor: const Color(0xFF2E7D32),
                        ),
                        _SummaryCard(
                          title: 'Aktif Randevular',
                          value: '${upcomingAppointments.length} Bekleyen',
                          subtitle: 'Onay aşamasında',
                          icon: Icons.event_available_rounded,
                          iconColor: const Color(0xFF1976D2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Filter selector for operational trend
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        SegmentedButton<int>(
                          segments: const [
                            ButtonSegment(
                              value: 7,
                              label: Text('Son 7 Gün'),
                              icon: Icon(Icons.date_range, size: 16),
                            ),
                            ButtonSegment(
                              value: 30,
                              label: Text('Son 30 Gün'),
                              icon: Icon(Icons.calendar_month, size: 16),
                            ),
                          ],
                          selected: {_selectedDaysFilter},
                          onSelectionChanged: (newSelection) {
                            setState(() {
                              _selectedDaysFilter = newSelection.first;
                            });
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock_clock_outlined,
                                  size: 14, color: theme.colorScheme.outline),
                              const SizedBox(width: 4),
                              Text(
                                'Saat Dilimi: TRT (UTC+3)',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Charts Layout
                    if (isWide) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: DonationTrendChart(
                              dataPoints: trendPoints,
                              dateRange: 'Son $_selectedDaysFilter Gün',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 5,
                            child: BloodStockChart(stocks: stocks),
                          ),
                        ],
                      ),
                    ] else ...[
                      DonationTrendChart(
                        dataPoints: trendPoints,
                        dateRange: 'Son $_selectedDaysFilter Gün',
                      ),
                      const SizedBox(height: 16),
                      BloodStockChart(stocks: stocks),
                    ],

                    const SizedBox(height: 20),

                    // Privacy and Medical Disclaimer Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blueGrey.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.shield_outlined,
                              size: 22, color: Colors.blueGrey.shade700),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Veri Gizliliği ve Tıbbi Uygunluk İlkesi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xFF263238),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${AppConstants.medicalDisclaimer} Operasyon grafikleri yalnızca toplulaştırılmış veri içerir; bağışçı kişisel bilgileri gösterilmez.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.blueGrey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    double cardWidth = 160;
    if (width > 600) cardWidth = 200;

    return SizedBox(
      width: cardWidth,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(icon, size: 20, color: iconColor),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
