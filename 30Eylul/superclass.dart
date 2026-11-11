class TemelSavasci{
  final String ad;
  final double temelGuc;

  TemelSavasci({required this.ad, required this.temelGuc
});

void saldir(){
  print("[$ad] Temel Fiziksel Yumruk attı. Hasar: $temelGuc");
}
}

class Buyucu extends TemelSavasci{
  int manaPuani;

  Buyucu({required this.manaPuani, required super.ad, required super.temelGuc});

  @override
  void saldir(){
    if (manaPuani >= 10) {
      manaPuani -= 10;
      print("[$ad] Alev Topu Fırlattı: Hasar: $temelGuc*2} Kalan Mana: $manaPuani"
      )
    }
  }

  class Okcu extends TemelSavasci{
    int okSayisi;

    Okcu({ 
      required this.okSayisi
    })
  }

  void main(){
    print("Savaş Arenası");
    final asker = TemelSavasci(ad: "Ayberk", temelGuc: 20.0);

    asker.saldir();
    print("================")
  }