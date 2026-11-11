class CanSistemi{

  final String karakterAdi:
  double canPuani=100.0;

  CanSistemi({required this.karakterAdi});

  double get canPuani{
    return _canPuani;
  }

  set canPuani(double yeniCan){
    if(yeniCan <= 0.0) {
      _canPuani = 0.0;
      print("$karakterAdi canı tükendi ve yere yığıldı");
    } else if (yeniCan > 100.0;){

    }
  }
}

void main(){
  print("Can barı Güvenlik Sistemi");

  final savasciCani = CanSistemi(karakterAdi:"Meltem Demir");

  print("Başlangıç Canı  : HP ${savasciCani.canPuani}");
  print("35 Hasar Alındı");
  savasciCani.canPuani = 65.0;
  print("Kalan Can  : HP ${savasciCani}")

}