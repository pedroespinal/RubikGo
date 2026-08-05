import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rubik_go/app.dart';
import 'package:rubik_go/screens/guide_screen.dart';
import 'package:rubik_go/screens/scan/manual_color_picker_screen.dart';

void main() {
  testWidgets('Home screen shows the main navigation buttons', (tester) async {
    await tester.pumpWidget(const RubikGoApp());
    await tester.pumpAndSettle();

    expect(find.text('RubikGo'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    expect(find.byIcon(Icons.palette), findsOneWidget);
    expect(find.byIcon(Icons.timer), findsOneWidget);
  });

  testWidgets('Manual picker opens from the home screen', (tester) async {
    await tester.pumpWidget(const RubikGoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.palette));
    await tester.pumpAndSettle();

    expect(find.byType(ManualColorPickerScreen), findsOneWidget);
  });

  testWidgets('Guide screen opens and shows its first section', (tester) async {
    await tester.pumpWidget(const RubikGoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu_book));
    await tester.pumpAndSettle();

    expect(find.byType(GuideScreen), findsOneWidget);
  });
}
