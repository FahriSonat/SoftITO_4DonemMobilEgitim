// 1. Cihaz tipleri
enum CihazTipi { sensor, gateway, edgeServer, router }

// 2. IoT cihaz sınıfı
class IoTCihaz {
  String seriNo;
  String cihazAdi;
  CihazTipi tip;
  double cpuYukYuzdesi;
  int bellekMb;
  Set<String> acikPortlar;
  bool sslSertifikasiGecerliMi;

  // Cihazın kapalı olup olmadığını tutmak için ek alan
  bool cihazAcikMi;

  IoTCihaz({
    required this.seriNo,
    required this.cihazAdi,
    required this.tip,
    required this.cpuYukYuzdesi,
    required this.bellekMb,
    required this.acikPortlar,
    required this.sslSertifikasiGecerliMi,
    required this.cihazAcikMi,
  });

  // Getter
  // Bu getter, cihazdaki güvenlik açığını otomatik kontrol eder.
  // SSL geçersizse VEYA TELNET portu açıksa true döner.
  bool get guvenlikAcigiVarMi =>
      !sslSertifikasiGecerliMi || acikPortlar.contains("23/TELNET");

  // Alarm durumu
  // Cihazda güvenlik açığı varsa ya da CPU kullanımı %85'i geçerse
  // cihaz alarm durumunda kabul edilir.
  bool get alarmVarMi => guvenlikAcigiVarMi || cpuYukYuzdesi > 85;

  // 7. Switch Expression ile izolasyon bölgesi
  // switch expression, cihaz tipine göre uygun bölge kodunu döndürür.
  String izolasyonBolgesiGetir() {
    return switch (tip) {
      CihazTipi.sensor => "ZONE-S",
      CihazTipi.gateway => "ZONE-G",
      CihazTipi.edgeServer => "ZONE-E",
      CihazTipi.router => "ZONE-R",
    };
  }

  // 8. Kapalı cihaz için exception fırlatma
  // Cihaz kapalıysa bağlantı kurulamaz ve özel hata fırlatılır.
  void baglan() {
    if (!cihazAcikMi) {
      throw CihazErisilemezException(
        "$cihazAdi cihazına erişilemiyor. Cihaz kapalı.",
      );
    }
    // Cihaz açıksa bağlantının başarılı olduğunu ekrana yazar.
    print("$cihazAdi cihazına başarıyla bağlanıldı.");
  }
}

// 8. Özel exception sınıfı
// Kendi hata türümüzü oluşturuyoruz.
class CihazErisilemezException implements Exception {
  // Hata mesajını tutar.
  final String mesaj;

  CihazErisilemezException(this.mesaj);

  // Hata nesnesi yazdırıldığında sadece mesajın görünmesini sağlar.
  @override
  String toString() => mesaj;
}

// 6. Seri numarasına göre Record döndüren metot
// Metot, cihaz adı, tipi ve alarm bilgisini Record olarak döndürür.
// Soru işareti (?) cihaz bulunamazsa null dönebileceğini belirtir.
(String cihazAdi, CihazTipi tip, bool alarmDurumu)? cihazBilgisiBul(
  List<IoTCihaz> cihazlar,
  String aranacakSeriNo,
) {
  // Listedeki her cihazı tek tek kontrol eder.
  for (IoTCihaz cihaz in cihazlar) {
    // Aranan seri numarasıyla eşleşen cihaz bulunduysa:
    if (cihaz.seriNo == aranacakSeriNo) {
      // Record içinde üç farklı bilgi döndürülür.
      return (cihaz.cihazAdi, cihaz.tip, cihaz.alarmVarMi);
    }
  }

  // Seri numarası yoksa null döndürülür.
  return null;
}

void main() {
  // 3. En az 6 farklı cihazdan oluşan Liste
  // List, birden fazla IoTCihaz nesnesini sıralı şekilde tutar.
  List<IoTCihaz> cihazlar = [
    IoTCihaz(
      seriNo: "SN-001",
      cihazAdi: "Sicaklik Sensoru",
      tip: CihazTipi.sensor,
      cpuYukYuzdesi: 40.0,
      bellekMb: 256,
      acikPortlar: {"80/HTTP"},
      sslSertifikasiGecerliMi: true,
      cihazAcikMi: true,
    ),
    IoTCihaz(
      seriNo: "SN-002",
      cihazAdi: "Ana Gateway",
      tip: CihazTipi.gateway,
      cpuYukYuzdesi: 91.5,
      bellekMb: 1024,
      acikPortlar: {"443/HTTPS"},
      sslSertifikasiGecerliMi: true,
      cihazAcikMi: true,
    ),
    IoTCihaz(
      seriNo: "SN-003",
      cihazAdi: "Depo Router",
      tip: CihazTipi.router,
      cpuYukYuzdesi: 65.0,
      bellekMb: 512,
      acikPortlar: {"23/TELNET", "80/HTTP"},
      sslSertifikasiGecerliMi: true,
      cihazAcikMi: false,
    ),
    IoTCihaz(
      seriNo: "SN-004",
      cihazAdi: "Edge Sunucu",
      tip: CihazTipi.edgeServer,
      cpuYukYuzdesi: 72.0,
      bellekMb: 4096,
      acikPortlar: {"443/HTTPS"},
      sslSertifikasiGecerliMi: false,
      cihazAcikMi: true,
    ),
    IoTCihaz(
      seriNo: "SN-005",
      cihazAdi: "Nem Sensoru",
      tip: CihazTipi.sensor,
      cpuYukYuzdesi: 20.0,
      bellekMb: 128,
      acikPortlar: {},
      sslSertifikasiGecerliMi: true,
      cihazAcikMi: true,
    ),
    IoTCihaz(
      seriNo: "SN-006",
      cihazAdi: "Yedek Gateway",
      tip: CihazTipi.gateway,
      cpuYukYuzdesi: 87.0,
      bellekMb: 2048,
      acikPortlar: {"22/SSH"},
      sslSertifikasiGecerliMi: true,
      cihazAcikMi: true,
    ),
  ];

  // 4. where() ile riskli cihazları bulma
  // where(), sadece verilen koşulu sağlayan cihazları seçer.
  // toList() seçilen sonuçları tekrar bir List haline getirir.
  List<IoTCihaz> riskliCihazlar = cihazlar.where((cihaz) {
    return cihaz.guvenlikAcigiVarMi || cihaz.cpuYukYuzdesi > 85;
  }).toList();

  print("Riskli cihazlar:");

  // Riskli cihazların bilgileri ekrana yazdırılır.
  for (IoTCihaz cihaz in riskliCihazlar) {
    print(
      "${cihaz.cihazAdi} - CPU: ${cihaz.cpuYukYuzdesi}% - "
      "Guvenlik acigi: ${cihaz.guvenlikAcigiVarMi}",
    );
  }

  // 5. fold() ile toplam bellek hesabı
  // fold(), listedeki tüm bellek değerlerini toplamak için kullanılır.
  // 0 başlangıç değeridir.
  int toplamBellek = cihazlar.fold<int>(
    0,
    (toplam, cihaz) => toplam + cihaz.bellekMb,
  );

  print("\nToplam bellek kullanimi: $toplamBellek MB");

  // 6. Record ile cihaz arama
  // SN-004 seri numaralı cihaz aranır.
  var cihazBilgisi = cihazBilgisiBul(cihazlar, "SN-004");

  // Cihaz bulunduysa Record içindeki bilgiler ekrana yazdırılır.
  if (cihazBilgisi != null) {
    print("\nAranan cihaz bilgileri:");
    print("Cihaz adi: ${cihazBilgisi.$1}");
    print("Cihaz tipi: ${cihazBilgisi.$2}");
    print("Alarm durumu: ${cihazBilgisi.$3}");
  } else {
    print("\nBu seri numarasına ait cihaz bulunamadı.");
  }

  // 7. İzolasyon bölgesi
  print("\nIzolasyon bolgeleri:");

  // Her cihaz için switch expression sonucunda oluşan bölge kodu yazdırılır.
  for (IoTCihaz cihaz in cihazlar) {
    print("${cihaz.cihazAdi}: ${cihaz.izolasyonBolgesiGetir()}");
  }

  // 8. try-catch ile erişim hatasını yakalama
  print("\nCihaza baglanma denemesi:");

  try {
    // Listede 2. indeks, yani üçüncü cihaz olan Depo Router kapalıdır.
    // Bu nedenle baglan() metodu exception fırlatacaktır.
    cihazlar[2].baglan();
  } on CihazErisilemezException catch (hata) {
    // Fırlatılan özel hata burada yakalanır.
    print("Hata: $hata");
  }
}
