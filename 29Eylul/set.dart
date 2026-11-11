void main(){
  print("Beyaz Liste ve Küme Analizi");

  final Set<String> istanbulVeriMerkeziIpleri={
    "10.0.1.10",
    "10.0.1.11",
    "10.0.1.12",
    "10.0.1.13",
    "10.0.1.10",
  };

  print("İstanbul Ipleri: $istanbulVeriMerkeziIpleri");

  final Set<String> frankfurtVeriMerkeziIpleri={
    "10.0.1.13",
    "10.0.1.30",
    "10.0.1.45",
  };
  print("Frankfurt Ipleri: $frankfurtVeriMerkeziIpleri");

  final ortakKopruIpler=istanbulVeriMerkeziIpleri.intersection(frankfurtVeriMerkeziIpleri);
  print("Ortak Ağ Ipleri(kesişim): $ortakKopruIpler");

  final tumGlobalIpler=istanbulVeriMerkeziIpleri.union(frankfurtVeriMerkeziIpleri);
  print("Toplam Global Ipler(birleşim): $tumGlobalIpler");

  final sadeceIstanbul = istanbulVeriMerkeziIpleri.difference(frankfurtVeriMerkeziIpleri);
  print("Sadece Istanbul: $sadeceIstanbul");
}