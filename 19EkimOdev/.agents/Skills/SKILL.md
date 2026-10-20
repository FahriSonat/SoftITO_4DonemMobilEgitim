---
name: blood-donation-analytics
description: Doğru, gizliliğe duyarlı grafikler, bağışçı akışları ve stok görünümleri içeren Flutter kan bağışı uygulamaları oluşturur veya geliştirir. Bu alandaki Flutter/Dart ürün, uygulama veya analiz isteklerinde kullanın.
---

# Kan Bağışı Analitiği

Yararlı ve güvenilir kan bağışı deneyimleri oluşturun. Sayılar, tarihler, uygunluk yanıtları, stok durumları ve sağlıkla ilişkili tüm bilgileri hassas veri olarak değerlendirin.

Bir Flutter projesi başlatırken veya dosya yapısı belirlerken [proje yapısı rehberini](references/PROJECT.md) okuyun.

## Flutter uygulaması

Kullanıcı açıkça başka bir platform istemediği sürece istemciyi Flutter ve Dart ile geliştirin. Özellik kodlarını modüler tutun: ekranları ve tekrar kullanılabilir bileşenleri durum yönetimi, veri kaynakları ve veri aktarım modellerinden ayırın. Değiştirilemez grafik ve arayüz durumu tercih edin; toplu kayıtlar yeterliyse kişiyi tanımlayabilecek bağışçı bilgilerini gösterge paneli görünüm modellerine dahil etmeyin.

Material 3 teması ve anlamsal renk rolleri kullanın; aciliyet renklerini bileşenlerin içinde sabit olarak tanımlamayın. Gösterge panellerinin telefon, tablet ve web genişliklerinde çalışması için kısıtlar ve kırılım noktalarıyla uyarlanabilir düzen kurun. Her grafik kartında yükleniyor, hata, güncel olmayan veri ve boş durumlarını destekleyin.

Etkileşimli grafikler için projeye uygun ve bakımı yapılan bir Flutter grafik paketi (örneğin `fl_chart`) kullanın; çizim kodunu ayrı bileşenlerde yalıtın. Projede zaten bir grafik kütüphanesi varsa sessizce başka bir paket seçmeyin. Her grafiğin yanında veya altında veri tablosu ya da metinsel özet sağlayın; filtreleri standart Flutter kontrolleriyle erişilebilir yapın.

Tarih, sayı biçimlendirme ve yerelleştirme için `intl` kullanın. Tarih toplamalarında cihazın örtük saat dilimine güvenmek yerine uygulamanın açıkça tanımlanmış saat dilimini iletin. Repository'ler için bağımlılık enjeksiyonu veya projenin yerleşik düzenini kullanın; API anahtarlarını ya da canlı bağışçı verilerini uygulamaya gömmeyin.

## Ürün yapısını belirleme

Kullanıcı farklı bir yapı tanımlamadıysa makul bir uygulama yapısı çıkarın. Yaygın roller bağışçı, toplama merkezi çalışanı ve yöneticidir. Her rolün ihtiyacını ayrı tutun:

- Bağışçılar merkez veya kampanya bulabilmeli, açıkça sınırları belirtilmiş bir uygunluk özetini görebilmeli, randevu oluşturup yönetebilmeli ve kişisel bağış geçmişini inceleyebilmelidir.
- Çalışanlar randevuları, bağışçı giriş durumunu, toplama toplamlarını ve stok uyarılarını yönetebilmelidir.
- Yöneticiler, kimliği belirlenebilir bağışçı bilgilerini gereksizce görmeden toplu operasyon eğilimlerini inceleyebilmelidir.

Bilgilendirici uygunluk içeriğini tıbbi onay gibi sunmayın. Nihai kararın yetkili toplama ekibinde olduğunu açıkça belirtin. Ülkeye özgü uygunluk kuralları, klinik eşikler veya düzenleyici iddialar uydurmayın; bu bilgi gerekli olduğunda ülkeyi sorun veya açıkça yer tutucu olarak işaretlenmiş kurallar kullanın.

## Operasyon kararları için grafik tasarımı

Grafikleri yalnızca somut bir soruya yanıt veriyorsa kullanın. Görsellerin yanında erişilebilir özetler ve tablolar tercih edin. Mevcutsa açık başlık, birim, tarih aralığı, veri kaynağı veya yenileme zamanı ekleyin. Veri yoksa uydurma veri kullanmak yerine boş durum gösterin.

Önerilen soru-grafik eşleşmeleri:

| Soru | Uygun gösterim |
| --- | --- |
| Bağışlar artıyor mu, azalıyor mu? | Gün, hafta veya aya göre gruplanmış zaman serisi çizgi ya da alan grafiği. |
| En çok hangi kan gruplarına ihtiyaç var? | Hedef, mevcut stok ve durum içeren sıralı yatay çubuk grafik. |
| Toplama hedeflerine ulaşılıyor mu? | Hedef-gerçekleşen çubukları veya kompakt ilerleme göstergeleri. |
| Personel ne zaman artırılmalı? | Haftanın günü ve saat aralığına göre ısı haritası; yanında metinsel alternatif. |
| Randevu sonuçları nasıl karşılaştırılıyor? | Planlandı, geldi, ertelendi, iptal edildi ve gelmedi değerleri için yığılmış çubuk grafik. |
| Hangi merkez ya da kampanya daha çok katkı sağlıyor? | Sıralı çubuk grafik veya sıralanabilir karşılaştırma tablosu. |

Yanıltıcı görselleştirmelerden kaçının: sayım tabanlı çubuk grafikleri sıfırdan başlatın; birbirine yakın veya çok sayıda kategori için pasta/donut grafikleri kullanmayın; aciliyeti yalnızca renkle ifade etmeyin; gözlemsel eğilimlerden nedensellik sonucu çıkarmayın. Kan grubu etiketlerini tutarlı kullanın; örneğin her yerde `O−` kullanın, `O Negative` ve `O-` biçimlerini karıştırmayın.

Stok görünümünde her kan grubu için `Kritik`, `Düşük`, `Yeterli` veya `Fazla` gibi durum etiketi, mevcut miktar, yapılandırılmış hedef ve verinin güncellendiği zamanı birlikte gösterin. Eşik yapılandırmasını yetkili kullanıcılara görünür yapın; klinik eşikleri kendiniz seçmeyin.

## Gizlilik, güvenlik ve erişilebilirlik

Gösterge paneli grafiklerinde varsayılan olarak toplu veri kullanın. Grafiklerde isim, iletişim bilgisi, tıbbi yanıt, bağış erteleme bilgisi veya tam konum izleri göstermeyin. Bir grafik kişinin hassas durumunu ortaya çıkarabilecekse küçük grupları gizleyin ya da daha geniş gruplar hâlinde birleştirin. Rol tabanlı erişim kullanın; canlı bağışçı verisine bağlanmadan, bu veriyi dışa aktarmadan veya paylaşmadan önce izin isteyin.

Her grafiği klavye ile erişilebilir yapın ve kısa bir metinsel özet veya veri tablosu sağlayın. Yüksek kontrastlı, renk körlüğüne uygun paletler kullanın; etiket, desen veya simge gibi yinelenen kodlamalar ekleyin. Uygun olduğunda tarihleri, sayı biçimlerini, dili ve sağdan sola düzeni yerelleştirin.

## Uygulama ve doğrulama

Uygulamayı geliştirirken grafik verisini kişiyi tanımlayabilecek bağışçı kayıtlarından ayrı modelleyin. Her rol için yalnızca gerekli alanları alın, girdileri sınırda doğrulayın ve yükleniyor, güncel olmayan veri, hata ve veri yok durumlarını açıkça yönetin. Grafik filtrelerini ve seçilen tarih aralıklarını yalnızca hassas kullanıcı bağlamını açığa çıkarmıyorsa paylaşılabilir URL'de koruyun.

Teslimden önce grafik, özet kartı ve tablodaki toplamların tutarlı olduğunu; tarih filtrelerinin tek bir açık saat dilimi kullandığını; etiketlerin mobil genişlikte okunabildiğini; ve kritik stok durumlarının yalnızca renge güvenmeden anlaşılabildiğini doğrulayın. Örnek veri kullanılıyorsa bunu örnek veya demo veri olarak etiketleyin.
