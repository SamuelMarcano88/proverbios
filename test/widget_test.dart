import 'dart:ui' show Size;

import 'package:flutter_test/flutter_test.dart';
import 'package:proverbios/app/app.dart';

void main() {
  testWidgets('shows the three main options on mobile', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProverbiosApp());

    expect(find.text('¿QUÉ PERFIL ERES?'), findsOneWidget);
    expect(find.text('¿Qué tan sabio puedo ser?'), findsOneWidget);
    expect(find.text('Proverbio del día'), findsOneWidget);
    expect(find.text('Aprende a ser sabio'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the three main options on wide screens', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProverbiosApp());

    expect(find.text('Cada decisión cuenta.'), findsOneWidget);
    expect(find.text('¿Qué tan sabio puedo ser?'), findsOneWidget);
    expect(find.text('Proverbio del día'), findsOneWidget);
    expect(find.text('Aprende a ser sabio'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
