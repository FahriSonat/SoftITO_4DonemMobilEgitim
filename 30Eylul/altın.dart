class Kasa {
  final String _oyuncuAdi;
  int _bakiye = 0;

  Kasa(this._oyuncuAdi);

  void altinEkle(int miktar) {
    if (miktar < 0) {
      print("Sahte altın eklenemez!");
    } else if (miktar > 0) {
      _bakiye += miktar;
      print("Oyuncu: $_oyuncuAdi");
      print("$miktar altın eklendi.");
      print("Güncel kasa bakiyesi: $_bakiye altın");
    } else {
      print("0 altın eklenemez.");
    }
  }
}

void main() {
  Kasa kasa = Kasa("Ahmet");

  // Burada oyuncu adı ve bakiye gizlidir; ekrana yazılmaz.

  kasa.altinEkle(50);
  kasa.altinEkle(-20);
}