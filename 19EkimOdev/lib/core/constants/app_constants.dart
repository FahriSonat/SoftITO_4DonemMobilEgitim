class AppConstants {
  static const String appName = 'Kan Bağışı Takip Portalı';
  static const String demoDataLabel = '[Demo / Örnek Veri]';
  static const String medicalDisclaimer =
      'Tıbbi uygunluk, uygulamanın verdiği bir onay değildir; '
      'son değerlendirme yetkili kan alma ekibindedir.';

  static const List<String> bloodGroups = [
    'O-',
    'O+',
    'A-',
    'A+',
    'B-',
    'B+',
    'AB-',
    'AB+',
  ];
}

enum UserRole {
  donor('donor', 'Bağışçı', 'Randevu oluşturabilir ve geçmişini inceleyebilir.'),
  staff('staff', 'Merkez Çalışanı', 'Girişleri onaylar ve stokları günceller.'),
  admin('admin', 'Yönetici', 'Yalnızca toplulaştırılmış operasyon grafiklerini inceler.');

  final String id;
  final String title;
  final String description;

  const UserRole(this.id, this.title, this.description);

  bool get isDonor => this == UserRole.donor;
  bool get isStaff => this == UserRole.staff;
  bool get isAdmin => this == UserRole.admin;
}
