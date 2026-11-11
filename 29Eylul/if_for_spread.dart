void main(){
  print("Pipeline Konfirügasyonu");

  final bool productionMu = true;
  final bool debugLoggingAktif = false;
  final List<String>? cloudWatchEklentileri=["datadog-agent:v7","prometheus-exporter"];
  final List<String>? geciciTestYamalari=null;

  final List<String> aktifPipelineAdimlari=[
    "git-checkout",
    "security-sast-scan",

    if(productionMu) "production-kms-check",
    if(debugLoggingAktif) "verbose-debug-looger" else "minified-json-logger",

    ...["docker-build","helm-chart-package"],

    ...?cloudWatchEklentileri,
    ...?geciciTestYamalari,

  ];

  for (int i = 0; i < aktifPipelineAdimlari.length; i++) {
    print("Adım ${i + 1}: ${aktifPipelineAdimlari[i]}");
  }

  final List<int> izinliPortlar = [8080, 8443, 9090];
  final List<String> firewallGuvenlikKurallari = [
    "INGRESS-DEFAULT-DROP", 
    for (var port in izinliPortlar) "ALLOW-TCP_PORT-Sport (VPC_INTERNAL)",
    "EGRESS_ALL_ALLOW",
  ];
  print("Dinamik Güvenlik Kuralları (collection for):---");

  firewallGuvenlikKurallari.forEach((kural) => print (" * $kural"));
}