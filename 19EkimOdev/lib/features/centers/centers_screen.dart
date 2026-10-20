import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';

class CentersScreen extends StatefulWidget {
  final VoidCallback? onNavigateToAppointments;

  const CentersScreen({super.key, this.onNavigateToAppointments});

  @override
  State<CentersScreen> createState() => _CentersScreenState();
}

class _CentersScreenState extends State<CentersScreen> {
  String _searchQuery = '';
  String? _typeFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final centers = AppState.instance.centers;

        final filtered = centers.where((c) {
          final query = _searchQuery.toLowerCase();
          final matchesQuery = query.isEmpty ||
              c.name.toLowerCase().contains(query) ||
              c.address.toLowerCase().contains(query);
          final matchesType = _typeFilter == null || c.type == _typeFilter;
          return matchesQuery && matchesType;
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Bağış Merkezleri ve Kampanyalar'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (val) => setState(() => _searchQuery = val.trim()),
                      decoration: InputDecoration(
                        hintText: 'Merkez adı, cadde veya ilçe ara...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.35),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            selected: _typeFilter == null,
                            label: Text('Tümü (${centers.length})'),
                            onSelected: (_) =>
                                setState(() => _typeFilter = null),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            selected: _typeFilter == 'Sabit Merkez',
                            label: const Text('Sabit Merkez'),
                            onSelected: (_) => setState(() => _typeFilter =
                                _typeFilter == 'Sabit Merkez'
                                    ? null
                                    : 'Sabit Merkez'),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            selected: _typeFilter == 'Mobil Bağış Otobüsü',
                            label: const Text('Mobil Araçlar'),
                            onSelected: (_) => setState(() => _typeFilter =
                                _typeFilter == 'Mobil Bağış Otobüsü'
                                    ? null
                                    : 'Mobil Bağış Otobüsü'),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            selected: _typeFilter == 'Bölge Kan Merkezi',
                            label: const Text('Bölge Kan Merkezi'),
                            onSelected: (_) => setState(() => _typeFilter =
                                _typeFilter == 'Bölge Kan Merkezi'
                                    ? null
                                    : 'Bölge Kan Merkezi'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('Kriterlere uygun bağış noktası bulunamadı.'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final center = filtered[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 14),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        center.type == 'Mobil Bağış Otobüsü'
                                            ? Icons.directions_bus_rounded
                                            : Icons.local_hospital_rounded,
                                        color: theme.colorScheme.primary,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          center.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: center.isOpenToday
                                              ? const Color(0xFFE8F5E9)
                                              : const Color(0xFFFFEBEE),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          center.isOpenToday
                                              ? 'Açık'
                                              : 'Kapalı',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: center.isOpenToday
                                                ? const Color(0xFF2E7D32)
                                                : const Color(0xFFC62828),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on_outlined,
                                          size: 16,
                                          color: theme.colorScheme.outline),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          center.address,
                                          style: TextStyle(
                                              color: theme
                                                  .colorScheme.onSurfaceVariant),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time_rounded,
                                          size: 16,
                                          color: theme.colorScheme.outline),
                                      const SizedBox(width: 6),
                                      Text(
                                        center.workingHours,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.event_seat_outlined,
                                          size: 16,
                                          color: theme.colorScheme.outline),
                                      const SizedBox(width: 6),
                                      Text(
                                        center.capacity,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme.colorScheme.outline,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (widget.onNavigateToAppointments !=
                                          null)
                                        TextButton.icon(
                                          onPressed:
                                              widget.onNavigateToAppointments,
                                          icon: const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 16),
                                          label: const Text('Randevu Al'),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
