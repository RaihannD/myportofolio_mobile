import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('renders the portfolio home screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortofolio'), findsOneWidget);
    expect(find.text('NPM'), findsOneWidget);
    expect(find.text('2506620021'), findsOneWidget);
  });
}
