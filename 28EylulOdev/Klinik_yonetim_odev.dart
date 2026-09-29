//1.Enumları (derleme Zamanı güvenliği)
// Enum tanımlarını başlatır; enumlar sabit ve güvenli seçenek kümeleri oluşturur.
// Hizmet türlerini derleme zamanında güvenli biçimde sınırlandırır.
enum HizmetKategorisi { ciltYenileme, medikalEstetik, lazerEpilasyon, Lipo }

// Bir seansın bulunabileceği durumları tanımlar.
enum SeansDurumu { bekliyor, odadaIslemde, tamamlandi, iptalEdildi }

// Sistemce desteklenen ödeme yöntemlerini tanımlar.
enum OdemeYontemi { krediKarti, havaleEft, nakit, klinikPaketKredisi }

//Danışan (müşteri) Modeli
// Danışan (müşteri) verisini temsil eden sınıfı tanımlar.
class Danisan {
  // Danışanı benzersiz olarak tanımlayan ve sonradan değişmeyen kimlik bilgisidir.
  final String id;
  // Danışanın adını ve soyadını saklar.
  final String adSoyad;
  // Danışanın iletişim telefonunu saklar.
  final String telefon;
  // Danışanın VIP üyeliği olup olmadığını belirtir.
  final bool vipUyeMi;
  // Alerji listesidir; boş olabilir fakat null olamaz.
  final List<String> alerjiler;
  // Opsiyonel özel cilt/medikal notudur; null olabilir.
  final String? ozelCiltNotu;

  // Tüm danışan alanlarını başlatan, değiştirilemez (const) yapıcı metottur.
  const Danisan({
    // Kimlik bilgisinin verilmesini zorunlu tutar.
    required this.id,
    // Ad-soyad bilgisinin verilmesini zorunlu tutar.
    required this.adSoyad,
    // Telefon bilgisinin verilmesini zorunlu tutar.
    required this.telefon,
    // VIP durumu verilmezse varsayılan olarak false kullanılır.
    this.vipUyeMi = false,
    // Alerji listesi verilmezse boş ve sabit liste kullanılır.
    this.alerjiler = const [],
    // Özel not verilmezse null kalır.
    this.ozelCiltNotu,
  });

  // Alerji listesi boş değilse true döndüren hesaplanmış özelliktir.
  bool get hassasCiltMi => alerjiler.isNotEmpty;

  //Bilgi özet kartı
   String get bilgiOzeti {
    // Alerji yoksa uygun mesajı, varsa alerjileri virgülle birleştirilmiş metni seçer.
    final String alerjiBilgisi = alerjiler.isEmpty
        ? "Kayıtlı Alerji Yok"
        : "Alerjiler: ${alerjiler.join(', ')}";
    // Null özel not için varsayılan bilgilendirme metni kullanır.
    final String notBilgisi = ozelCiltNotu ?? "Özel medikal not girilmemiş";
    // VIP üyeye VİP, diğer danışana Standart etiketi atar.
    final String vipRozeti = vipUyeMi ? "VİP" : "Standart";
    // Hazırlanan tüm bilgileri tek bir özet metninde döndürür.
    return "$vipRozeti $adSoyad ($telefon) | $alerjiBilgisi | Not: $notBilgisi";
  }
}

// Seans (randevu) Modeli
// Seans/randevu verisini temsil eden sınıfı tanımlar.
class SeansKaydi {
  // Seansın benzersiz kodunu saklar.
  final String seansKodu;
  // Seansın bağlı olduğu danışan nesnesini saklar.
  final Danisan danisan;
  // Seansın hizmet kategorisini saklar.
  final HizmetKategorisi kategori;
  // Yapılacak işlemin adını saklar.
  final String islemAdi;
  // Tek seansın indirim öncesi ücretini saklar.
  final double birimFiyat;
  // Paket içindeki toplam seans adetini saklar.
  final int seansSayisi;
  // Yüzde cinsinden temel indirim oranını saklar; örneğin 10.0, %10 demektir.
  final double indirimOrani;
  // Sorumlu uzmanı saklar; henüz atanmamışsa null olabilir.
  final String? sorumluUzman;
  // Seansın güncellenebilen mevcut durumunu saklar.
  SeansDurumu durum;
  // Seans tamamlandığında seçilen ödeme yöntemini saklar; null olabilir.
  OdemeYontemi? odemeTipi;

  // Seans kaydını gerekli ve varsayılan alanlarla başlatan yapıcı metottur.
  SeansKaydi({
    // Seans kodunu zorunlu tutar.
    required this.seansKodu,
    // Danışan bilgisini zorunlu tutar.
    required this.danisan,
    // Hizmet kategorisini zorunlu tutar.
    required this.kategori,
    // İşlem adını zorunlu tutar.
    required this.islemAdi,
    // Birim fiyatı zorunlu tutar.
    required this.birimFiyat,
    // Seans sayısı verilmezse 1 kabul edilir.
    this.seansSayisi = 1,
    // İndirim oranı verilmezse %0 kabul edilir.
    this.indirimOrani = 0.0,
    // Uzman ataması isteğe bağlıdır.
    this.sorumluUzman,
    // Başlangıç durumu bekliyor olarak atanır.
    this.durum = SeansDurumu.bekliyor,
    // Ödeme tipi başlangıçta belirtilmeyebilir.
    this.odemeTipi,
  });

  // Birim fiyat ile seans sayısını çarparak brüt tutarı hesaplar.
  double get brutTutar => birimFiyat * seansSayisi;

  // Temel indirim ve varsa VIP indirimini tutar olarak hesaplar.
  double get indirimTutari {
    // Hesaba seansa tanımlı indirim oranı ile başlanır.
    double toplamOran = indirimOrani;
    // Danışan VIP ise toplam indirime ek %10 eklenir.
    if (danisan.vipUyeMi) {
      // Toplam oranı 10 puan artırır.
      toplamOran += 10.0;
    }
    // Brüt tutarın toplam indirim oranına karşılık gelen kısmını döndürür.
    return brutTutar * (toplamOran / 100.0);
  }

  // Brüt tutardan indirim tutarını çıkararak net ödenecek tutarı hesaplar.
  double get netTutar => brutTutar - indirimTutari;
}
// Yönetim Servisi
// Klinik işlemlerini, kayıtlarını ve raporlamayı yöneten sınıfı tanımlar.
class KlinikYoneticisi {
  // Yönetilen kliniğin/şubenin adını saklar.
  final String subeAdi;
  // Seans kayıtlarını sınıf dışına kapalı tutan özel listedir.
  final List<SeansKaydi> _seanslar = [];
  // Danışanları kimlikleriyle eşleyen, sınıf dışına kapalı sözlüktür.
  final Map<String, Danisan> _danisanRehberi = {};

  // Yönetici oluşturulurken şube adının verilmesini zorunlu tutar.
  KlinikYoneticisi({required this.subeAdi});

  //Danışan kaydetme
 // Verilen danışanı rehbere kaydeder ve ekrana bilgi mesajı yazar.
  void danisanKaydet(Danisan danisan) {
    // Danışanı, id değerini anahtar kullanarak sözlüğe ekler veya günceller.
    _danisanRehberi[danisan.id] = danisan;
    // Kayıt sonucunu ve üyelik türünü konsola yazdırır.
    print(
      "Rehbere Eklendi: ${danisan.adSoyad} (${danisan.vipUyeMi ? "VİP" : "Standart"})",
    );
  }

  // Verilen seans kaydını listeye ekler ve kaydı bildirir.
  void randevuOlustur(SeansKaydi seans) {
    // Seansı dahili seans listesine ekler.
    _seanslar.add(seans);
    // Kaydedilen seansın temel bilgilerini konsola yazar.
    print(
      "Randevu Kaydedildi [${seans.seansKodu}]: ${seans.danisan.adSoyad}->${seans.islemAdi}",
    );
  }

  // Belirtilen kodlu seansı tamamlar ve ödeme yöntemini kaydeder.
  void seansiTamamla({required String seansKodu, required OdemeYontemi odeme}) {
    // Tüm seans kayıtlarını sırayla dolaşır.
    for (var seans in _seanslar) {
      // Mevcut seansın kodu aranan koda eşitse ilgili kaydı bulur.
      if (seans.seansKodu == seansKodu) {
        // Seansın durumunu tamamlandı yapar.
        seans.durum = SeansDurumu.tamamlandi;
        // Seansın ödeme yöntemini kaydeder.
        seans.odemeTipi = odeme;
        // Tahsil edilen net tutarı ve ödeme türünü konsola yazar.
        print(
          "Seans Tamamlandı: [${seans.seansKodu}]: ${seans.netTutar.toStringAsFixed(2)} tahsil edildi (${odeme.name})",
        );
      }
    }
    // NOT: Bu satır mevcut kodda her zaman çalışır; seans bulunduğunda if içinde `return;` eklenmelidir.
    print("Hata [$seansKodu] kodlu seans bulunamadı");
    // Metottan çıkar; void metot için zorunlu değildir.
    return;
  }

  // Belirtilen seansı iptal eder; isteğe bağlı iptal nedenini de yazdırır.
  void seansiIptalEt(String seansKodu, {String? iptalNedeni}) {
    // Tüm seansları sırayla kontrol eder.
    for (var seans in _seanslar) {
      // Aranan seans kodu bulunduysa işlem yapar.
      if (seans.seansKodu == seansKodu) {
        // Seansın durumunu iptal edildi olarak günceller.
        seans.durum = SeansDurumu.iptalEdildi;
        // İptal nedenini veya neden yoksa varsayılan mesajı yazdırır.
        print(
          "Seans İptal Edildi [${seans.seansKodu}]: ${iptalNedeni ?? "Gerekçe Belirtilmedi"}",
        );
        // Kayıt bulunduğu için metottan çıkar.
        return;
      }
    }
  }


  // Finansal Rapor Metotları(fonksiyonel dart)
 // Tamamlanmış seansların net tutarlarını toplayarak gerçekleşen ciroyu hesaplar.
  double get toplamTahsilEdilenCiro => _seanslar
      // Yalnızca tamamlanan seansları filtreler.
      .where((s) => s.durum == SeansDurumu.tamamlandi)
      // Filtrelenmiş net tutarları 0.0 başlangıcından itibaren toplar.
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  // Bekleyen veya işlemdeki seansların net tutarlarını potansiyel ciro olarak hesaplar.
  double get beklenenPotansiyelCiro => _seanslar
      // Sadece henüz tahsil edilmemiş aktif seansları filtreler.
      .where(
        // Seans bekliyor ya da odada işlemdeyse filtreye alınır.
        (s) =>
            s.durum == SeansDurumu.bekliyor ||
            s.durum == SeansDurumu.odadaIslemde,
      )
      // Filtrelenen seansların net tutarlarını toplar.
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  // Her hizmet kategorisindeki seans adedini döndüren metottur.
  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {
    // Sonuç dağılımını tutacak boş sözlüğü oluşturur.
    final Map<HizmetKategorisi, int> dagilim = {};
    // Enumdaki bütün kategorileri gezer.
    for (var kat in HizmetKategorisi.values) {
      // Her kategori için başlangıç sayısını sıfır yapar.
      dagilim[kat] = 0;
    }
    // Kayıtlı tüm seansları gezer.
    for (var s in _seanslar) {
      // Seansın kategorisindeki sayıyı bir artırır; yoksa sıfırdan başlar.
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1;
    }
    // Tamamlanan kategori-sayı eşlemesini döndürür.
    return dagilim;
  }

  // Atanmış uzmanların tekrarsız adlarından oluşan kümeyi döndürür.
  Set<String> gorevliUzmanKadrosu() {
    // Uzman adlarını alır, null değerleri çıkarır ve yinelenenleri kümede tekilleştirir.
    return _seanslar.map((s) => s.sorumluUzman).whereType<String>().toSet();
  }

  // Uzman atanmamış seans kayıtlarını liste olarak döndürür.
  List<SeansKaydi> uzmansizSeanslariGetir() {
    // Sorumlu uzmanı null olan seansları filtreleyip yeni listeye dönüştürür.
    return _seanslar.where((s) => s.sorumluUzman == null).toList();
  }

  // Gün sonu seans, finans ve uzman raporunu konsola yazdırır.
  void gunSonuRaporuYazdir() {
    // Rapor başlığını yazdırır.
    print("Günlük Seans ve İşlem Çizelgesi");
    // Tablo için yatay ayırıcı çizgi yazdırır.
    print("---------------------------------------");
    // Sütun başlıklarını boşluklarla hizalayıp yazdırır.
    print(
      "${'Kod'.padRight((10))} | "
      "${'Danışan'.padRight(16)} | "
      "${'İşlem'.padRight(20)} | "
      "${'Uzman'.padRight(18)} | "
      "${'Tutar'.padRight(10)} | "
      "${'Durum'} | ",
    );
    // Başlıkların altına ikinci ayırıcıyı yazdırır.
    print("---------------------------------------");

    // Her seansı rapor satırına dönüştürmek üzere sırayla dolaşır.
    for (var s in _seanslar) {
      // Uzman yoksa varsayılan bekleme mesajını kullanır.
      final String uzman = s.sorumluUzman ?? " Nöbetçi Bekliyor";
      // Seans durumunu kullanıcı dostu metne çeviren switch ifadesidir.
      final String durumRozet = switch (s.durum) {
        // Tamamlanan durumunu Tamamlandı etiketi yapar.
        SeansDurumu.tamamlandi => "Tamamlandı",
        // İşlemdeki durumu İşlemde etiketi yapar.
        SeansDurumu.odadaIslemde => "İşlemde",
        // Bekleyen durumu Bekliyor etiketi yapar.
        SeansDurumu.bekliyor => "Bekliyor",
        // İptal durumunu İptal etiketi yapar.
        SeansDurumu.iptalEdildi => "İptal",
      };

      // Seans bilgilerini hizalanmış tek bir tablo satırı halinde yazdırır.
      print(
        "${s.seansKodu.padRight(10)} | "
        "${s.danisan.adSoyad.padRight(10)} | "
        "${s.islemAdi.padRight(10)} | "
        "${uzman.padRight(10)} | "
        "${s.netTutar.toStringAsFixed(2).padRight(10)} | "
        "$durumRozet",
      );
    }

    // Seans tablosunu finansal bölümden ayırır.
    print("---------------------------------------");
    // Finansal özet başlığını yazdırır.
    print("Finansal Özet:");
    // Tamamlanmış seanslardan hesaplanan net ciroyu iki ondalıkla yazdırır.
    print(
      " * Gerçekleşen (kasadaki net ciro) : ${toplamTahsilEdilenCiro.toStringAsFixed(2)}",
    );
    // Bekleyen/işlemdeki seanslardan hesaplanan potansiyel alacağı yazdırır.
    print(
      " * Bekleyen Potansiyen Alacak : ${beklenenPotansiyelCiro.toStringAsFixed(2)}",
    );
    // Toplam randevu sayısını yazdırır.
    print(" * Toplam Seans : ${_seanslar.length} Randevu");
    // Finansal bölümü uzman bölümünden ayırır.
    print("---------------------------------------");
    // Uzman listesinin başlığını yazdırır.
    print("Aktif Uzmanlar");
    // Atanmış uzmanların tekrarsız kümesini alır.
    final uzmanlar = gorevliUzmanKadrosu();
    // Küme boşsa kayıtlı uzman olmadığını bildirir.
    if (uzmanlar.isEmpty) {
      // Boş kadro mesajını yazdırır.
      print("Kayıtlı Uzman Bulunamadı");
    } else {
      // Uzman adlarını virgülle birleştirerek yazdırır.
      print(" ${uzmanlar.join(', ')}");
    }
    // Henüz uzman atanmamış seansları alır.
    final uzmansizlar = uzmansizSeanslariGetir();
    // Uzmansız seans bulunuyorsa uyarı ve detayları yazdırır.
    if (uzmansizlar.isNotEmpty) {
      // Uzmansız seans sayısını içeren uyarıyı yazdırır.
      print(
        "Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır",
      );
      // Her uzmansız seansı ayrı ayrı dolaşır.
      for (var u in uzmansizlar) {
        // Seans kodu, danışan ve işlem bilgilerini yazdırır.
        print("->[${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})");
      }
    }
    // Raporun son ayırıcı çizgisini yazdırır.
    print("---------------------------------------");
  }
}

// Dart programının çalıştırılmaya başlandığı ana giriş noktasıdır.
void main() {
  // Programın açılış mesajını konsola yazdırır.
  print("Klinik yönetim sistemi başlatılıyor....");
  // Bağcılar şubesi için yönetici nesnesini oluşturur.
  final yonetici = KlinikYoneticisi(subeAdi: "Softito Bağcılar Şubesi");

  // Birinci danışanı gerekli ve isteğe bağlı verileriyle oluşturur.
  final d1 = Danisan(
    // Birinci danışanın kodunu atar.
    id: "DAN-101",
    // Birinci danışanın adını atar.
    adSoyad: "Ahmet Yılmaz",
    // Birinci danışanın telefonunu atar.
    telefon: "0555 555 55 55",
    // Birinci danışanı VIP olarak işaretler.
    vipUyeMi: true,
    // Birinci danışanın alerjilerini liste halinde atar.
    alerjiler: ["Retinol,Aspirin"],
    // Birinci danışanın özel cilt notunu atar.
    ozelCiltNotu: "Cilt bariyeri hassas",
  );
  // İkinci danışanı oluşturur.
  final d2 = Danisan(
    // İkinci danışanın kodunu atar.
    id: "DAN-102",
    // İkinci danışanın adını atar.
    adSoyad: "Ahmet Yılan",
    // İkinci danışanın telefonunu atar.
    telefon: "0555 555 55 55",
    // İkinci danışanı standart üye olarak işaretler.
    vipUyeMi: false,
    // İkinci danışanın alerjisi olmadığını boş listeyle belirtir.
    alerjiler: [],
  );
  // Üçüncü danışanı oluşturur.
  final d3 = Danisan(
    // Üçüncü danışanın kodunu atar.
    id: "DAN-103",
    // Üçüncü danışanın adını atar.
    adSoyad: "Mehmet Yılmaz",
    // Üçüncü danışanın telefonunu atar.
    telefon: "0555 555 55 55",
    // Üçüncü danışanı VIP olarak işaretler.
    vipUyeMi: true,
    // Üçüncü danışanın alerjilerini liste halinde atar.
    alerjiler: ["Retinol,Aspirin"],
  );
  // Dördüncü danışanı oluşturur.
  final d4 = Danisan(
    // Dördüncü danışanın kodunu atar.
    id: "DAN-104",
    // Dördüncü danışanın adını atar.
    adSoyad: "Ahmet Mehmet Yılmaz",
    // Dördüncü danışanın telefonunu atar.
    telefon: "0555 555 55 55",
    // Dördüncü danışanı VIP olarak işaretler.
    vipUyeMi: true,
    // Dördüncü danışanın alerjisi olmadığını boş listeyle belirtir.
    alerjiler: [],
    // Dördüncü danışanın özel cilt notunu atar.
    ozelCiltNotu: "Cilt bariyeri hassas",
  );

  // Birinci danışanı rehbere kaydeder.
  yonetici.danisanKaydet(d1);
  // İkinci danışanı rehbere kaydeder.
  yonetici.danisanKaydet(d2);
  // Üçüncü danışanı rehbere kaydeder.
  yonetici.danisanKaydet(d3);
  // Dördüncü danışanı rehbere kaydeder.
  yonetici.danisanKaydet(d4);

  // Danışan bilgileri bölümünün başlığını yazdırır.
  print("Danışan güvenlik kontrolü");
  // Birinci danışanın hesaplanmış bilgi özetini yazdırır.
  print(d1.bilgiOzeti);
  // İkinci danışanın hesaplanmış bilgi özetini yazdırır.
  print(d2.bilgiOzeti);
  // Görsel ayırıcı çizgi yazdırır.
  print("----------------------------------");

  // Birinci randevu/seans kaydını oluşturur.
  final seans1 = SeansKaydi(
    // Birinci seansın benzersiz kodunu atar.
    seansKodu: "SNS-2026-1",
    // Seansı birinci danışana bağlar.
    danisan: d1,
    // Seansın kategorisini Lipo olarak atar.
    kategori: HizmetKategorisi.Lipo,
    // İşlem adını atar.
    islemAdi: "Lipo gerisini bilmiyorum",
    // Birim fiyatı atar.
    birimFiyat: 6500.0,
    // Paket için iki seans olduğunu atar.
    seansSayisi: 2,
    // Temel indirimi %5 olarak atar.
    indirimOrani: 5.0,
    // Sorumlu uzmanı atar.
    sorumluUzman: "Sümeyye Arab",
  );
  // İkinci randevu/seans kaydını oluşturur.
  final seans2 = SeansKaydi(
    // İkinci seansın benzersiz kodunu atar.
    seansKodu: "SNS-2026-2",
    // Seansı ikinci danışana bağlar.
    danisan: d2,
    // Seansın kategorisini cilt yenileme olarak atar.
    kategori: HizmetKategorisi.ciltYenileme,
    // İşlem adını atar.
    islemAdi: "Siverex ile tyüz temizleme",
    // Birim fiyatı atar.
    birimFiyat: 2500.0,
    // Paket için beş seans olduğunu atar.
    seansSayisi: 5,
    // Temel indirimi %15 olarak atar.
    indirimOrani: 15.0,
    // Henüz uzman atanmadığını null ile belirtir.
    sorumluUzman: null,
  );
  // Üçüncü randevu/seans kaydını oluşturur.
  final seans3 = SeansKaydi(
    // Üçüncü seansın benzersiz kodunu atar.
    seansKodu: "SNS-2026-3",
    // Seansı üçüncü danışana bağlar.
    danisan: d3,
    // Seansın kategorisini lazer epilasyon olarak atar.
    kategori: HizmetKategorisi.lazerEpilasyon,
    // İşlem adını atar.
    islemAdi: "Tüm Vücut",
    // Birim fiyatı atar.
    birimFiyat: 25000.0,
    // Paket için on beş seans olduğunu atar.
    seansSayisi: 15,
    // Temel indirim olmadığını %0 ile belirtir.
    indirimOrani: 0.0,
    // Sorumlu uzmanı atar.
    sorumluUzman: "Tuba Aydın",
  );
  // Dördüncü randevu/seans kaydını oluşturur.
  final seans4 = SeansKaydi(
    // Dördüncü seansın benzersiz kodunu atar.
    seansKodu: "SNS-2026-4",
    // Seansı dördüncü danışana bağlar.
    danisan: d4,
    // Seansın kategorisini medikal estetik olarak atar.
    kategori: HizmetKategorisi.medikalEstetik,
    // İşlem adını atar.
    islemAdi: "Burun Estetiği",
    // Birim fiyatı atar.
    birimFiyat: 1500.0,
    // Paket için üç seans olduğunu atar.
    seansSayisi: 3,
    // Sorumlu uzmanı atar; indirim oranı varsayılan %0 kalır.
    sorumluUzman: "Alaaddin Odabaşı",
  );
  // Birinci seansı yöneticinin seans listesine kaydeder.
  yonetici.randevuOlustur(seans1);
  // İkinci seansı yöneticinin seans listesine kaydeder.
  yonetici.randevuOlustur(seans2);
  // Üçüncü seansı yöneticinin seans listesine kaydeder.
  yonetici.randevuOlustur(seans3);
  // Dördüncü seansı yöneticinin seans listesine kaydeder.
  yonetici.randevuOlustur(seans4);
  // Seans oluşturma bölümünün tamamlandığını bildirir.
  print("Seanslar Gönderiliyor");

  // İlk seansı kredi kartı ödemesiyle tamamlandı olarak işaretler.
  yonetici.seansiTamamla(
    // Tamamlanacak seansın kodunu verir.
    seansKodu: "SNS-2026-1",
    // Kullanılan ödeme yöntemini kredi kartı olarak verir.
    odeme: OdemeYontemi.krediKarti,
  );
  // İkinci seansı nakit ödemesiyle tamamlandı olarak işaretler.
  yonetici.seansiTamamla(
    // Tamamlanacak seansın kodunu verir.
    seansKodu: "SNS-2026-2",
    // Kullanılan ödeme yöntemini nakit olarak verir.
    odeme: OdemeYontemi.nakit,
  );
  // Dördüncü seansı belirtilen gerekçeyle iptal eder.
  yonetici.seansiIptalEt(
    // İptal edilecek seans kodunu verir.
    "SNS-2026-4",
    // İptalin açıklamasını verir.
    iptalNedeni: "Danışanın şehir dışından tanıdığı geldiği için gelemedi",
  );

  // Tüm kayıtların gün sonu raporunu konsola yazdırır.
  yonetici.gunSonuRaporuYazdir();
}
