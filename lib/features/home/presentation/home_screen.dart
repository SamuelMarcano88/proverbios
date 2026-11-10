import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import 'widgets/home_option_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _options = [
    _HomeOption(
      number: '01',
      title: '¿Qué tan sabio puedo ser?',
      description:
          'Reflexiona sobre tus decisiones cotidianas a la luz de Proverbios.',
      icon: Icons.lightbulb_outline_rounded,
      accentColor: AppColors.gold,
      iconBackgroundColor: AppColors.goldTint,
    ),
    _HomeOption(
      number: '02',
      title: 'Proverbio del día',
      description:
          'Una enseñanza de la Palabra para inspirar y orientar tu día.',
      icon: Icons.menu_book_rounded,
      accentColor: AppColors.blue,
      iconBackgroundColor: AppColors.blueTint,
    ),
    _HomeOption(
      number: '03',
      title: 'Aprende a ser sabio',
      description:
          'Conoce cómo responden el sabio, el simple y el insensato.',
      icon: Icons.auto_stories_rounded,
      accentColor: AppColors.terracotta,
      iconBackgroundColor: AppColors.terracottaTint,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            final horizontalPadding = constraints.maxWidth < 600 ? 22.0 : 40.0;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 22,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Header(),
                        SizedBox(height: isWide ? 74 : 52),
                        _Introduction(isWide: isWide),
                        const SizedBox(height: 34),
                        if (isWide)
                          Row(
                            children: [
                              for (var index = 0;
                                  index < _options.length;
                                  index++) ...[
                                if (index > 0) const SizedBox(width: 20),
                                Expanded(
                                  child: SizedBox(
                                    height: 340,
                                    child: _buildOptionCard(
                                      context,
                                      _options[index],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          )
                        else
                          Column(
                            children: [
                              for (final option in _options) ...[
                                _buildOptionCard(context, option),
                                const SizedBox(height: 16),
                              ],
                            ],
                          ),
                        const SizedBox(height: 28),
                        const _Footer(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, _HomeOption option) {
    return HomeOptionCard(
      number: option.number,
      icon: option.icon,
      title: option.title,
      description: option.description,
      accentColor: option.accentColor,
      iconBackgroundColor: option.iconBackgroundColor,
      onTap: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Esta sección se desarrollará en la siguiente etapa.'),
            ),
          );
      },
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.goldTint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: AppColors.gold,
            size: 23,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '¿QUÉ PERFIL ERES?',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.25,
            ),
          ),
        ),
        const Icon(
          Icons.account_circle_outlined,
          color: AppColors.mutedInk,
          size: 21,
        ),
        const SizedBox(width: 7),
        Text('Invitado', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _Introduction extends StatelessWidget {
  const _Introduction({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UN CAMINO DE REFLEXIÓN',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.gold,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Cada decisión cuenta.',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: isWide ? 48 : 38,
          ),
        ),
        const SizedBox(height: 13),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            'Tres maneras de vivir. Una invitación a la sabiduría. '
            'Explora las enseñanzas de Proverbios y encuentra nuevas '
            'formas de crecer cada día.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );

    if (!isWide) return textColumn;

    return Row(
      children: [
        Expanded(child: textColumn),
        const SizedBox(width: 36),
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: AppColors.goldTint.withValues(alpha: 0.72),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.spa_outlined,
            color: AppColors.gold,
            size: 66,
          ),
        ),
        const SizedBox(width: 54),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Una pausa para pensar. Un paso para crecer.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.mutedInk.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

class _HomeOption {
  const _HomeOption({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.iconBackgroundColor,
  });

  final String number;
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final Color iconBackgroundColor;
}
