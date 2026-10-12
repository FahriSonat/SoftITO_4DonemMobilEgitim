/* 

Future<void> fetchDashboardData() async{
  try{
    final result = await Future.wait([
      fetcUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ], eagerError: true);

    print("Tüm veriler geldi $result");
  } catch (e) {
    print("isteklerden Biri başarısız oldu $e");
  }
}

 */

import 'dart:async';

void main (){
  final controller=StreamController<int>();

  final subscription = controller.stream.listen(
    (data) => print("yeni Veri: $data"),
    onError: (err) => print("Hata Oluştu: $err"),
    onDone: () => print("Yayın Tamamlandı"),
  );

  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);

  final broadcastStream = controller.stream.asBroadcastStream();
  broadcastStream.listen((d) => print("UI Ekranı: $d"));
   broadcastStream.listen((d) => print("Analitik Servisi Ekranı: $d"));

  controller.close();
}