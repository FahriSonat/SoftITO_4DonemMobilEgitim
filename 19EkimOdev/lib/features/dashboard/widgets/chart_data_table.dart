import 'package:flutter/material.dart';

class ChartDataTable extends StatelessWidget {
  final String title;
  final List<String> columns;
  final List<List<String>> rows;

  const ChartDataTable({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.table_chart_outlined,
                    size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 40,
                dataRowMinHeight: 38,
                dataRowMaxHeight: 42,
                columns: columns
                    .map((col) => DataColumn(
                          label: Text(
                            col,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
                rows: rows
                    .map((row) => DataRow(
                          cells: row.map((c) => DataCell(Text(c))).toList(),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
