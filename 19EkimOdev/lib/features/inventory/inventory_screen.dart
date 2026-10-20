import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/state/app_state.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/number_utils.dart';
import 'models/blood_stock.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  StockStatus? _selectedStatusFilter;

  void _showEditDialog(BuildContext context, BloodStock stock) {
    final currentController =
        TextEditingController(text: stock.currentUnits.toString());
    final targetController =
        TextEditingController(text: stock.targetUnits.toString());

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('${stock.bloodGroup} Stok Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Mevcut Miktar (Ünite)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bloodtype_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Hedef Miktar (Ünite)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () {
                final current = int.tryParse(currentController.text);
                final target = int.tryParse(targetController.text);
                if (current != null && target != null) {
                  AppState.instance.updateStock(
                    stock.bloodGroup,
                    current,
                    target,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${stock.bloodGroup} stoğu güncellendi.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final stocks = AppState.instance.stocks;
        final role = AppState.instance.role;

        final filtered = _selectedStatusFilter == null
            ? stocks
            : stocks.where((s) => s.status == _selectedStatusFilter).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Kan Grubu Stok Durumu'),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = 1;
              if (width >= 1050) {
                crossAxisCount = 4;
              } else if (width >= 600) {
                crossAxisCount = 2;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Threshold Standards Card
                    Card(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.4),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                color: theme.colorScheme.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Stok Eşik Standartları',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
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
                                  const SizedBox(height: 2),
                                  Text(
                                    'Kritik: <%35 | Düşük: %35-%65 | Yeterli: %65-%125 | Fazla: >%125 (Eşikler idari konfigürasyondur).',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Filter Chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          selected: _selectedStatusFilter == null,
                          label: Text('Tümü (${stocks.length})'),
                          onSelected: (_) =>
                              setState(() => _selectedStatusFilter = null),
                        ),
                        FilterChip(
                          selected: _selectedStatusFilter == StockStatus.critical,
                          avatar: const Icon(Icons.warning_rounded, size: 16),
                          label: Text(
                            'Kritik (${stocks.where((s) => s.status == StockStatus.critical).length})',
                          ),
                          onSelected: (_) => setState(() {
                            _selectedStatusFilter =
                                _selectedStatusFilter == StockStatus.critical
                                    ? null
                                    : StockStatus.critical;
                          }),
                        ),
                        FilterChip(
                          selected: _selectedStatusFilter == StockStatus.low,
                          avatar: const Icon(Icons.report_problem_rounded, size: 16),
                          label: Text(
                            'Düşük (${stocks.where((s) => s.status == StockStatus.low).length})',
                          ),
                          onSelected: (_) => setState(() {
                            _selectedStatusFilter =
                                _selectedStatusFilter == StockStatus.low
                                    ? null
                                    : StockStatus.low;
                          }),
                        ),
                        FilterChip(
                          selected: _selectedStatusFilter == StockStatus.sufficient,
                          avatar: const Icon(Icons.check_circle_rounded, size: 16),
                          label: Text(
                            'Yeterli (${stocks.where((s) => s.status == StockStatus.sufficient).length})',
                          ),
                          onSelected: (_) => setState(() {
                            _selectedStatusFilter =
                                _selectedStatusFilter == StockStatus.sufficient
                                    ? null
                                    : StockStatus.sufficient;
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        mainAxisExtent: 180,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final stock = filtered[index];
                        final status = stock.status;
                        final ratio = stock.ratio.clamp(0.0, 1.5);

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: theme.colorScheme.primary
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Text(
                                        stock.bloodGroup,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: status.bgColor,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: status.color
                                                .withValues(alpha: 0.6)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(status.icon,
                                              size: 16, color: status.textColor),
                                          const SizedBox(width: 4),
                                          Text(
                                            status.label,
                                            style: TextStyle(
                                              color: status.textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '${stock.currentUnits}',
                                      style: theme.textTheme.headlineMedium
                                          ?.copyWith(fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text('Ünite',
                                        style: TextStyle(color: Colors.grey)),
                                    const Spacer(),
                                    Text(
                                      'Hedef: ${AppNumberUtils.formatUnits(stock.targetUnits)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: (ratio / 1.25).clamp(0.0, 1.0),
                                    minHeight: 8,
                                    backgroundColor:
                                        theme.colorScheme.surfaceContainerHighest,
                                    color: status.color,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Güncelleme: ${AppDateUtils.formatDateTime(stock.lastUpdated)}',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.colorScheme.outline,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (role.isStaff)
                                      IconButton.filledTonal(
                                        onPressed: () =>
                                            _showEditDialog(context, stock),
                                        icon: const Icon(Icons.edit_note_rounded,
                                            size: 20),
                                        visualDensity: VisualDensity.compact,
                                        tooltip: 'Stok Güncelle',
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
