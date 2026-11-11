void esyaEkle(Esya yeniEsya) {
  if (mevcutAgirlik + yeniEsya.agirlik > maxAgirlikKapasitesi) {
    final double asim = (mevcutAgirlik + yeniEsya.agirlik) -
  }
}

List<Esya> get degerliEsyalar => _esyalar
  .where(
    (e) => 
        e.nadirlik == EsyaNadirliği.destansi || 
        e.nadirlik == EsyaNadirliği.efsanevi, 
  )
  .toList();




  for (var esya in _esyalar){
    final deger = esya.degerlemeYap();
  }





  void main(){
    print("Zindan & Envanter Motoru Başlatılıyor...");


    final bool vipUyelik=true;


    final canta=OyuncuCantası(sahipAdi: "Elf Okçusu Ayberk", 
    maxAgirlikKapasitesi:20.0,);
    final List<Esya> zindanGrisPaketi=[
      Esya.kucukCanIksiri(),
      Esya(
        id:"SWD-101"
      )
    ]

    print("Ticaret ve altın harcama ");
    try{
      canta.altinHarca(200);
      canta.altinharca(800);
    } on YetersizAltinException catch (e) {}
  }