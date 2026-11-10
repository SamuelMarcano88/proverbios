import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proverbios/app/app.dart';
import 'package:proverbios/features/quiz/domain/quiz_content.dart';

void main() {
  testWidgets('shows the three main options on mobile', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProverbiosApp());

    expect(find.text('¿QUÉ PERFIL ERES?'), findsOneWidget);
    expect(
      find.textContaining('Puedes hacer el test sin registrarte.'),
      findsOneWidget,
    );
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

  testWidgets('keeps account registration optional on the home screen', (
    tester,
  ) async {
    await tester.pumpWidget(const ProverbiosApp());

    expect(find.text('¿Qué tan sabio puedo ser?'), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);

    await tester.tap(find.text('Crear cuenta'));
    await tester.pumpAndSettle();

    expect(find.text('Activa tu cuenta'), findsOneWidget);
    expect(
      find.textContaining('El test funciona sin registro.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens the daily proverb section', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProverbiosApp());
    final dailyOption = find.text('Proverbio del día');
    await tester.ensureVisible(dailyOption);
    await tester.tap(dailyOption);
    await tester.pumpAndSettle();

    expect(find.textContaining('PROVERBIOS'), findsOneWidget);
    expect(find.text('Guardar en favoritos'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens the learning section', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProverbiosApp());
    final learningOption = find.text('Aprende a ser sabio');
    await tester.ensureVisible(learningOption);
    await tester.tap(learningOption);
    await tester.pumpAndSettle();

    expect(find.text('El sabio'), findsOneWidget);
    expect(find.text('El simple'), findsOneWidget);
    expect(find.text('El insensato'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('completes the quiz and shows a reflective result', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProverbiosApp());
    final quizOption = find.text('¿Qué tan sabio puedo ser?');
    await tester.ensureVisible(quizOption);
    await tester.tap(quizOption);
    await tester.pumpAndSettle();

    for (var index = 0; index < quizQuestions.length; index++) {
      final answer = find.byType(Card).first;
      await tester.ensureVisible(answer);
      await tester.tap(answer);
      await tester.pumpAndSettle();
    }

    expect(find.text('TU REFLEXIÓN'), findsOneWidget);
    expect(
      find.textContaining('Completaste el test sin registrarte.'),
      findsOneWidget,
    );
    expect(find.text('Guardar resultado'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
