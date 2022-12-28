import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:etebase_flutter_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app can start', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('etebase flutter plugin'), findsOneWidget);
    expect(
      find.text('etebase default server URL: https://api.etebase.com/'),
      findsOneWidget,
    );
  });
}
