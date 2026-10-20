import 'package:flutter_test/flutter_test.dart';
import 'package:kanstoktakip/core/constants/app_constants.dart';
import 'package:kanstoktakip/features/inventory/models/blood_stock.dart';
import 'package:kanstoktakip/main.dart';

void main() {
  testWidgets('BloodDonationApp mounts and displays 4 navigation tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BloodDonationApp());
    await tester.pumpAndSettle();

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text('Ana Sayfa'), findsWidgets);
    expect(find.text('Randevular'), findsWidgets);
    expect(find.text('Stok'), findsWidgets);
    expect(find.text('Merkezler'), findsWidgets);
  });

  test('StockStatus threshold calculations verify correctly', () {
    expect(StockStatus.fromRatio(0.20), StockStatus.critical);
    expect(StockStatus.fromRatio(0.50), StockStatus.low);
    expect(StockStatus.fromRatio(0.90), StockStatus.sufficient);
    expect(StockStatus.fromRatio(1.30), StockStatus.surplus);
  });
}
