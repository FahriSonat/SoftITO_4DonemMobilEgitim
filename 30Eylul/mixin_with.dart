mixin UcmaYetisi{
  int ucusIrtifasiMetre=100;

  void gogeYuksel(){
    print("Uçus Yetisi: Kanatlarını Açtı ve $ucusIrtifasiMetre metreye yükseldi");
  }
}

mixin GorunmezlikYetkisi {
  void pelerinOrt() {
    print("Görünmezlik: Düşmanların gözünden tamamen kayboldu!");
  }
}

mixin AtesGucuYetisi{
  void alevSaldirisi () {
    print("Ateş Gücü: Kılıcını alevlendirdi ve alanı yaktı");
  }
}

class TemelKarakter{
  final String ad;
  TemelKarakter({required this.ad});
}

class EfsaneviEjderBinicisi extends TemelKarakter with UcmaYetisi, AtesGucuYetisi{
  final String ejderhaAdi;

  EfsaneviEjderBinicisi({required this.ejderhaAdi, required super.ad});

  void hucumEt(){
    print("$ad ve ejderhası $ejderhaAdi savaşa atılıyor");
    gogeYuksel();
    alevSaldirisi();
  }
}

class GolgeSuikastci extends TemelKarakter with GorunmezlikYetkisi{
  GolgeSuikastci({required super.ad});
  void suikastYap(){

  }
}

void main (){
  print("Süper Güçler Başlatılıyor");
  final birinci = EfsaneviEjderBinicisi(ejderhaAdi: "Dişsiz", ad: "Fahri");birinci.hucumEt();
  final ikinci = GolgeSuikastci(ad: "Faruk");ikinci.suikastYap();
  }