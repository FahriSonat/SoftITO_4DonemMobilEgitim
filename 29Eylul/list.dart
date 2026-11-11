void main() {
  final List<String> aktifMikroservisler = [
    "auth-service:v2.1",
    "gateway-service:v1.9",
    "payment-processor:v3.0",
  ];
  aktifMikroservisler.add("telemetry-collector:v1.0");
  print(
    "Aktifler Servisler: (${aktifMikroservisler.length}adet): $aktifMikroservisler",
  );

  final List<String> cekirdekYukDengeleyiciler = List.filled(
    4,
    "Port-kapalı",
    growable: false,
  );
  cekirdekYukDengeleyiciler[0] = "LB-NODE-01; 192.168.1.10 (Online)";
  cekirdekYukDengeleyiciler[0] = "LB-NODE-02; 192.168.1.11 (Online)";

  print("Çekirdek Yük Dengeleyici Portları: $cekirdekYukDengeleyiciler");

  final List<String> kubernetsPodlari=List.generate(3, (index) => "pod-node-eu-west-${index + 1} [RAM:16GB, CPU:4 Cores]", );

  print("Oluşturulan KBs Podları: $kubernetsPodlari");

  final List<String> guvenlikDuvariPortlari=List.unmodifiable([
    "22/TCP (SSH)",
    "443/TCP (HTTPS)",
    "6443/TCP (KBs-API)",
    ]);

    print("Güvenlik Duvarı Korumalı Portlar: $guvenlikDuvariPortlari");
}
