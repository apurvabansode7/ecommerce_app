import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/main.dart';



void main() {
  testWidgets('shows the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EcommerceApp());

    expect(find.text('E-commerence'), findsOneWidget);
  });
}