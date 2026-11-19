import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proverbios/app/app.dart';

void main() {
  testWidgets('Portuguese translates content inside each main option', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProverbiosApp());
    await tester.tap(find.byTooltip('Idioma'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Portugués de Brasil'));
    await tester.pumpAndSettle();

    final quizOption = find.text('Quão sábio posso ser?');
    await tester.ensureVisible(quizOption);
    await tester.tap(quizOption);
    await tester.pumpAndSettle();
    expect(find.text('PERGUNTA 1 DE 8'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.data != null &&
            (widget.data!.startsWith('Quando ') ||
                widget.data!.startsWith('O que você ') ||
                widget.data!.startsWith('Como você ')),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    final dailyOption = find.text('Provérbio do dia');
    await tester.ensureVisible(dailyOption);
    await tester.tap(dailyOption);
    await tester.pumpAndSettle();
    expect(find.text('PARA REFLETIR'), findsOneWidget);
    expect(
      find.text('Reina-Valera 1909 · Texto em domínio público'),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    final learningOption = find.text('Aprenda a ser sábio');
    await tester.ensureVisible(learningOption);
    await tester.tap(learningOption);
    await tester.pumpAndSettle();
    expect(find.text('Três maneiras de responder à vida'), findsOneWidget);
    expect(find.text('O sábio'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
