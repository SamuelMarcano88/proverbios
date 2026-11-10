import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:proverbios/features/quiz/domain/quiz_content.dart';

void main() {
  test('randomized quiz keeps all questions and their answer profiles', () {
    final randomized = createRandomizedQuiz(Random(42));

    expect(randomized, hasLength(quizQuestions.length));
    expect(
      randomized.map((question) => question.prompt).toSet(),
      quizQuestions.map((question) => question.prompt).toSet(),
    );
    expect(
      randomized.map((question) => question.prompt).toList(),
      isNot(quizQuestions.map((question) => question.prompt).toList()),
    );

    for (final question in randomized) {
      final original = quizQuestions.firstWhere(
        (candidate) => candidate.prompt == question.prompt,
      );
      expect(
        question.answers.map((answer) => answer.profile).toSet(),
        original.answers.map((answer) => answer.profile).toSet(),
      );
    }
  });

  test('quiz result is independent of question order', () {
    final answers = [
      WisdomProfile.wise,
      WisdomProfile.wise,
      WisdomProfile.wise,
      WisdomProfile.simple,
      WisdomProfile.simple,
      WisdomProfile.foolish,
      WisdomProfile.foolish,
      WisdomProfile.foolish,
    ];

    final result = scoreQuiz(answers);

    expect(result.profile, WisdomProfile.simple);
    expect(result.scores[WisdomProfile.wise], 3);
    expect(result.scores[WisdomProfile.simple], 2);
    expect(result.scores[WisdomProfile.foolish], 3);
  });
}
