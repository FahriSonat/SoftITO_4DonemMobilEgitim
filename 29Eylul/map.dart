void main() {
  print("Map Metrikleri");

  final Map<String, Map<String, dynamic>> mikroservisRehberi = {
    "auth-api": {
      "port": 8081,
      "saglik": "Healthy",
      "restartSayisi": 0,
      "bellekKullanimiMB": 384.5,
      "otonomOlcekleme": true,
    },

    "payment-gateway": {
      "port": 8082,
      "saglik": "Degraded",
      "restartSayisi": 4,
      "bellekKullanimiMB": 1280.0,
      "otonomOlcekleme": false,
    },
  };

  mikroservisRehberi.putIfAbsent(
    "reporting-worker",
    () => {
      "port": 9091,
      "saglik": "Healthy",
      "restartSayisi": 1,
      "bellekKullanimiMB": 512.0,
      "otonomOlcekleme": true,
    },
  );

  if (mikroservisRehberi.containsKey("payment-gateway")) {
    mikroservisRehberi["payment-gateway"]!["restartSayisi"] =
        (mikroservisRehberi["payment-gateway"]!["restartSayisi"] as int) + 1;
  }

  print("Güncel Servis Durum Raporu");
  print("===========================================");
  for (var entry in mikroservisRehberi.entries) {
    final String servis = entry.key;
    final Map<String, dynamic> ozet = entry.value;
    final String saglik = ozet["saglik"];
    final String durumRozet = saglik == "Healthy" ? "OK" : "Alert";

    print(
      "$durumRozet ${servis.padRight(18)} | Port: ${ozet['port']} | Ram: ${ozet['bellekKullanimiMB']}MB | Restart: ${ozet['restartSayisi']}",
    );
  }
}

/* void main() {
  final Set<String> services = {
    'api-gateway',
    'user-service',
    'payment-service',
    'user-service', 
  };

  final bool isProduction = true;

  final List<String> serviceList = [
    ...services,
    if (isProduction) 'vault-secret-manager',
  ];

  print(serviceList);
} */
