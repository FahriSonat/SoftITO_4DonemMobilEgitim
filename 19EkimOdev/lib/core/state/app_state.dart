import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../utils/date_utils.dart';
import '../../features/inventory/models/blood_stock.dart';

class AppointmentItem {
  final String id;
  final String donorCode;
  final String centerName;
  final DateTime dateTime;
  final String bloodGroup;
  final String status;
  final String? note;

  const AppointmentItem({
    required this.id,
    required this.donorCode,
    required this.centerName,
    required this.dateTime,
    required this.bloodGroup,
    required this.status,
    this.note,
  });

  AppointmentItem copyWith({
    String? id,
    String? donorCode,
    String? centerName,
    DateTime? dateTime,
    String? bloodGroup,
    String? status,
    String? note,
  }) {
    return AppointmentItem(
      id: id ?? this.id,
      donorCode: donorCode ?? this.donorCode,
      centerName: centerName ?? this.centerName,
      dateTime: dateTime ?? this.dateTime,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }
}

class CenterItem {
  final String id;
  final String name;
  final String type;
  final String address;
  final String workingHours;
  final bool isOpenToday;
  final String capacity;

  const CenterItem({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.workingHours,
    required this.isOpenToday,
    required this.capacity,
  });
}

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  AppState._internal() {
    _initializeData();
  }

  UserRole _role = UserRole.donor;
  UserRole get role => _role;

  void setRole(UserRole newRole) {
    if (_role != newRole) {
      _role = newRole;
      notifyListeners();
    }
  }

  final List<BloodStock> _stocks = [];
  List<BloodStock> get stocks => List.unmodifiable(_stocks);

  final List<AppointmentItem> _appointments = [];
  List<AppointmentItem> get appointments => List.unmodifiable(_appointments);

  final List<CenterItem> _centers = [];
  List<CenterItem> get centers => List.unmodifiable(_centers);

  void _initializeData() {
    final now = AppDateUtils.now();

    _stocks.addAll([
      BloodStock(
        bloodGroup: 'O-',
        currentUnits: 18,
        targetUnits: 80,
        lastUpdated: now.subtract(const Duration(minutes: 15)),
      ),
      BloodStock(
        bloodGroup: 'O+',
        currentUnits: 65,
        targetUnits: 120,
        lastUpdated: now.subtract(const Duration(minutes: 24)),
      ),
      BloodStock(
        bloodGroup: 'A-',
        currentUnits: 25,
        targetUnits: 70,
        lastUpdated: now.subtract(const Duration(minutes: 40)),
      ),
      BloodStock(
        bloodGroup: 'A+',
        currentUnits: 110,
        targetUnits: 100,
        lastUpdated: now.subtract(const Duration(hours: 1)),
      ),
      BloodStock(
        bloodGroup: 'B-',
        currentUnits: 14,
        targetUnits: 50,
        lastUpdated: now.subtract(const Duration(hours: 2)),
      ),
      BloodStock(
        bloodGroup: 'B+',
        currentUnits: 72,
        targetUnits: 80,
        lastUpdated: now.subtract(const Duration(minutes: 50)),
      ),
      BloodStock(
        bloodGroup: 'AB-',
        currentUnits: 12,
        targetUnits: 40,
        lastUpdated: now.subtract(const Duration(hours: 3)),
      ),
      BloodStock(
        bloodGroup: 'AB+',
        currentUnits: 62,
        targetUnits: 45,
        lastUpdated: now.subtract(const Duration(minutes: 10)),
      ),
    ]);

    _appointments.addAll([
      AppointmentItem(
        id: 'APT-101',
        donorCode: 'BG-8401',
        centerName: 'Kadıköy Sabit Kan Bağışı Merkezi',
        dateTime: now.add(const Duration(hours: 3)),
        bloodGroup: 'O-',
        status: 'Planlandı',
        note: 'İlk bağış randevusu',
      ),
      AppointmentItem(
        id: 'APT-102',
        donorCode: 'BG-9214',
        centerName: 'Şişli Cevahir Mobil Bağış Aracı',
        dateTime: now.add(const Duration(hours: 6)),
        bloodGroup: 'A+',
        status: 'Planlandı',
      ),
      AppointmentItem(
        id: 'APT-103',
        donorCode: 'BG-3312',
        centerName: 'Kartal Bölge Kan Merkezi',
        dateTime: now.subtract(const Duration(hours: 2)),
        bloodGroup: 'B-',
        status: 'Tamamlandı',
      ),
      AppointmentItem(
        id: 'APT-104',
        donorCode: 'BG-5542',
        centerName: 'Kadıköy Sabit Kan Bağışı Merkezi',
        dateTime: now.subtract(const Duration(days: 1)),
        bloodGroup: 'AB+',
        status: 'Ertelendi',
        note: 'Hemoglobin seviyesi nedeniyle ertelendi',
      ),
    ]);

    _centers.addAll(const [
      CenterItem(
        id: 'CTR-01',
        name: 'Kadıköy Sabit Kan Bağışı Merkezi',
        type: 'Sabit Merkez',
        address: 'Caferağa Mah. Moda Cad. No: 42, Kadıköy',
        workingHours: 'Hafta içi 08:30 - 19:30 | Hafta sonu 09:30 - 18:00',
        isOpenToday: true,
        capacity: '8 Koltuk • Günlük ~120 Bağışçı',
      ),
      CenterItem(
        id: 'CTR-02',
        name: 'Şişli Cevahir Mobil Bağış Aracı',
        type: 'Mobil Bağış Otobüsü',
        address: 'Büyükdere Cad. Cevahir AVM Meydanı, Şişli',
        workingHours: 'Her gün 10:30 - 19:00',
        isOpenToday: true,
        capacity: '4 Koltuk • Günlük ~60 Bağışçı',
      ),
      CenterItem(
        id: 'CTR-03',
        name: 'Kartal Bölge Kan Merkezi',
        type: 'Bölge Kan Merkezi',
        address: 'Cevizli Mah. Köroğlu Cad. No: 18, Kartal',
        workingHours: '7/24 Kesintisiz Aferez & Tam Kan',
        isOpenToday: true,
        capacity: '12 Koltuk • Trombosit / Aferez Ünitesi',
      ),
      CenterItem(
        id: 'CTR-04',
        name: 'Beşiktaş İskele Meydanı Mobil Otobüsü',
        type: 'Mobil Bağış Otobüsü',
        address: 'Sinanpaşa Mah. Barbaros Bulvarı Girişi, Beşiktaş',
        workingHours: 'Salı - Pazar 11:00 - 19:30',
        isOpenToday: true,
        capacity: '4 Koltuk',
      ),
    ]);
  }

  void updateStock(String bloodGroup, int currentUnits, int targetUnits) {
    final index = _stocks.indexWhere((s) => s.bloodGroup == bloodGroup);
    if (index != -1) {
      _stocks[index] = _stocks[index].copyWith(
        currentUnits: currentUnits,
        targetUnits: targetUnits,
        lastUpdated: AppDateUtils.now(),
      );
      notifyListeners();
    }
  }

  void addAppointment(AppointmentItem appointment) {
    _appointments.insert(0, appointment);
    notifyListeners();
  }

  void updateAppointmentStatus(String id, String newStatus) {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }
}
