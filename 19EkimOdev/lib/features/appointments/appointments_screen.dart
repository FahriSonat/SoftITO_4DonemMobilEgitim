import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/state/app_state.dart';
import '../../core/utils/date_utils.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String? _statusFilter;

  void _showNewAppointmentDialog(BuildContext context) {
    final centers = AppState.instance.centers;
    String selectedCenter = centers.first.name;
    String selectedBlood = AppConstants.bloodGroups.first;
    DateTime selectedDate = AppDateUtils.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 30);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: Color(0xFFC62828)),
                  SizedBox(width: 8),
                  Text('Yeni Randevu Al'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kan Bağışı Merkezi / Araç:'),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: selectedCenter,
                      items: centers
                          .map((c) => DropdownMenuItem(
                                value: c.name,
                                child: Text(c.name, overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedCenter = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text('Kan Grubu:'),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: selectedBlood,
                      items: AppConstants.bloodGroups
                          .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedBlood = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: Text(AppDateUtils.formatDate(selectedDate)),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: AppDateUtils.now(),
                                lastDate: AppDateUtils.now().add(const Duration(days: 60)),
                              );
                              if (picked != null) {
                                setDialogState(() => selectedDate = picked);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.access_time, size: 16),
                            label: Text(selectedTime.format(context)),
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );
                              if (picked != null) {
                                setDialogState(() => selectedTime = picked);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: const Text(
                        AppConstants.medicalDisclaimer,
                        style: TextStyle(fontSize: 11, color: Color(0xFF5D4037)),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Vazgeç'),
                ),
                FilledButton(
                  onPressed: () {
                    final appointmentDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    final newApt = AppointmentItem(
                      id: 'APT-${DateTime.now().millisecondsSinceEpoch % 10000}',
                      donorCode: 'BG-${(DateTime.now().millisecondsSinceEpoch % 9000) + 1000}',
                      centerName: selectedCenter,
                      dateTime: appointmentDateTime,
                      bloodGroup: selectedBlood,
                      status: 'Planlandı',
                      note: 'Bağışçı portalından randevu oluşturuldu',
                    );

                    AppState.instance.addAppointment(newApt);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Randevunuz başarıyla oluşturuldu!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Randevuyu Onayla'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'tamamlandı':
        return const Color(0xFF2E7D32);
      case 'planlandı':
        return const Color(0xFF1976D2);
      case 'ertelendi':
        return const Color(0xFFF57C00);
      case 'iptal':
        return const Color(0xFFD32F2F);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final appointments = AppState.instance.appointments;
        final role = AppState.instance.role;

        final filtered = _statusFilter == null
            ? appointments
            : appointments.where((a) => a.status == _statusFilter).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Randevu Takip ve Yönetim'),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showNewAppointmentDialog(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Randevu Al'),
          ),
          body: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    FilterChip(
                      selected: _statusFilter == null,
                      label: Text('Tümü (${appointments.length})'),
                      onSelected: (_) => setState(() => _statusFilter = null),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: _statusFilter == 'Planlandı',
                      label: const Text('Planlandı'),
                      onSelected: (_) => setState(() =>
                          _statusFilter = _statusFilter == 'Planlandı' ? null : 'Planlandı'),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: _statusFilter == 'Tamamlandı',
                      label: const Text('Tamamlandı'),
                      onSelected: (_) => setState(() =>
                          _statusFilter = _statusFilter == 'Tamamlandı' ? null : 'Tamamlandı'),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: _statusFilter == 'Ertelendi',
                      label: const Text('Ertelendi'),
                      onSelected: (_) => setState(() =>
                          _statusFilter = _statusFilter == 'Ertelendi' ? null : 'Ertelendi'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('Kayıtlı randevu bulunamadı.'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final apt = filtered[index];
                          final color = _getStatusColor(apt.status);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primaryContainer,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          apt.bloodGroup,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          apt.centerName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                              color: color.withValues(alpha: 0.4)),
                                        ),
                                        child: Text(
                                          apt.status,
                                          style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time_rounded,
                                          size: 16, color: theme.colorScheme.outline),
                                      const SizedBox(width: 6),
                                      Text(
                                        AppDateUtils.formatDateTime(apt.dateTime),
                                        style: TextStyle(
                                            color: theme.colorScheme.onSurfaceVariant),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Bağışçı No: ${apt.donorCode}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme.colorScheme.outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (apt.note != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Not: ${apt.note}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: theme.colorScheme.outline,
                                      ),
                                    ),
                                  ],
                                  if (role.isStaff && apt.status == 'Planlandı') ...[
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: () {
                                            AppState.instance
                                                .updateAppointmentStatus(
                                                    apt.id, 'Ertelendi');
                                          },
                                          icon: const Icon(Icons.pause_circle_outline,
                                              size: 16),
                                          label: const Text('Ertele'),
                                        ),
                                        const SizedBox(width: 8),
                                        FilledButton.icon(
                                          onPressed: () {
                                            AppState.instance
                                                .updateAppointmentStatus(
                                                    apt.id, 'Tamamlandı');
                                          },
                                          icon: const Icon(Icons.check_circle_outline,
                                              size: 16),
                                          label: const Text('Giriş Onayla'),
                                        ),
                                      ],
                                    ),
                                  ],
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
