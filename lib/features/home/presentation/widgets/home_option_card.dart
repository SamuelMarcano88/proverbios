import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class HomeOptionCard extends StatelessWidget {
  const HomeOptionCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.iconBackgroundColor,
    required this.onTap,
    super.key,
  });

  final String number;
  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;
  final Color iconBackgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          constraints: const BoxConstraints(minHeight: 282),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(icon, color: accentColor, size: 29),
                  ),
                  Text(
                    number,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.mutedInk.withValues(alpha: 0.65),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 27),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Text(
                    'EXPLORAR',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, color: accentColor, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
