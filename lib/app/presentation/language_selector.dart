import 'package:flutter/material.dart';

import '../localization.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton<AppLanguage>(
      tooltip: l10n.text('language'),
      onSelected: l10n.onLanguageChanged,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AppLanguage.es,
          child: Row(
            children: [
              const Text('ES'),
              const SizedBox(width: 8),
              Text(l10n.text('spanish')),
            ],
          ),
        ),
        PopupMenuItem(
          value: AppLanguage.ptBr,
          child: Row(
            children: [
              const Text('PT-BR'),
              const SizedBox(width: 8),
              Text(l10n.text('portuguese_br')),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded, size: 21),
            const SizedBox(width: 6),
            Text(l10n.language == AppLanguage.es ? 'ES' : 'PT-BR'),
          ],
        ),
      ),
    );
  }
}
