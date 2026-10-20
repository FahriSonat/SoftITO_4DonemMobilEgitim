# Kan Bağışı Flutter Projesi

Bu belge, grafikler içeren kan bağışı uygulaması için önerilen proje sınırlarını ve dosya yapısını tanımlar. Kullanıcı farklı bir mimari, paket veya servis belirtirse onun tercihini koruyun.

## Amaç ve roller

Uygulama; bağışçıların randevu bulmasına ve takip etmesine, merkez çalışanlarının bağış/stok süreçlerini yönetmesine ve yöneticilerin yalnızca toplu verilerle operasyon grafikleri görmesine yardımcı olur.

Roller: `donor`, `staff`, `admin`. Her rol yalnızca ihtiyacı olan veriye ve işlemlere erişir. Tıbbi uygunluk, uygulamanın verdiği bir onay değildir; son değerlendirme yetkili kan alma ekibindedir.

## Teknoloji tercihi

- Flutter ve Dart
- Material 3
- Grafikler: mevcut proje tercihi yoksa `fl_chart`
- Yerelleştirme ve biçimlendirme: `intl`
- Durum yönetimi: mevcut proje deseni; yeni projede tek bir tutarlı yaklaşım seçin
- Veri katmanı: repository deseni ve bağımlılık enjeksiyonu

Gizli anahtarları, üretim verisini ve kişiyi tanımlayabilecek bağışçı bilgisini kaynak koda veya örnek veri dosyalarına koymayın.

## Dosya yapısı

```text
lib/
├── core/
│   ├── theme/             # Temel tema ayarları
│   ├── constants/         # Sabitler
│   ├── utils/             # Yardımcı fonksiyonlar
│   └── navigation/        # Navigasyon (go_router)
├── features/
│   ├── dashboard/         # Ana Sayfa ve grafikler
│   ├── appointments/      # Randevular
│   ├── inventory/         # Kan stokları
│   └── centers/           # Merkezler ve kampanyalar
│
└── main.dart
```

`features/` altında yalnızca dört ana sayfa bulunur: `dashboard`, `appointments`, `inventory` ve `centers`. Her özellik kendi ekranı, bileşenleri, modelleri ve veri erişim kodunu içinde tutar. Ortak tema, sabitler, yardımcı işlevler ve `go_router` yönlendirmesi `core/` altında bulunur. Grafik bileşenleri yalnızca toplu grafik modellerini alır; ham bağışçı kayıtlarına erişmez.

## Dört ana sayfa ve temel akışlar

Uygulama tam olarak dört ana sayfa kullanır. Rol bazlı içerikler ayrı bir sayfa oluşturmadan bu dört sayfanın içinde gösterilir.

| Ekran | Amaç | Temel bileşenler |
| --- | --- | --- |
| 1. Ana sayfa | Kullanıcıya rolüne uygun özet sunar; yönetici için toplu operasyon grafiklerini de içerir. | Özet kartları, yaklaşan randevu, stok uyarısı, tarih filtresi, trend ve hedef-gerçekleşen grafikleri. |
| 2. Randevular | Randevu oluşturma ve yönetme. | Merkez/kampanya seçimi, tarih-saat, durum. |
| 3. Stok | Kan gruplarının stok durumunu gösterir. | Mevcut miktar, hedef, güncellenme zamanı, metinsel durum. |
| 4. Merkezler ve kampanyalar | Merkez veya kampanya bulmayı sağlar. | Arama, filtreler, çalışma bilgisi. |

## Grafik sözleşmesi

Her grafik bileşeni şunları sağlar:

- Başlık, birim, seçili tarih aralığı ve mümkünse son güncelleme zamanı.
- `loading`, `error`, `empty` ve `data` durumları.
- Klavye erişimi ile metinsel özet veya `chart_data_table.dart` aracılığıyla tablo.
- Renk dışındaki kodlamalar: etiket, değer ve gerektiğinde simge.
- Sayım çubuk grafiklerinde sıfırdan başlayan eksen.

Stok grafiği için kayıt: kan grubu, mevcut miktar, hedef miktar, durum ve güncellenme zamanı. Durum eşikleri yapılandırılabilir olmalı; klinik eşikler uygulama tarafından uydurulmamalıdır.

## Veri ve gizlilik kuralları

- Yönetim grafiklerinde yalnızca toplu veri döndürün.
- İsim, telefon/e-posta, tıbbi yanıt, erteleme nedeni ve kesin konum bilgisini grafik modeline koymayın.
- Küçük grupların bir kişiyi ortaya çıkarma ihtimali varsa sonuçları bastırın veya genişletin.
- Tarih filtrelemede tek, açıkça tanımlanmış uygulama saat dilimi kullanın.
- Demo verisini `demo` veya `örnek veri` olarak etiketleyin.

## Tamamlanma ölçütleri

- `flutter analyze` uyarısız tamamlanır.
- İlgili widget ve iş kuralı testleri geçer.
- Grafik, kart ve tablodaki toplamlar aynı veriyi gösterir.
- Telefon, tablet ve web genişliklerinde taşma olmadan okunur.
- Kritik stok durumu yalnızca renge bağlı olmadan anlaşılır.
