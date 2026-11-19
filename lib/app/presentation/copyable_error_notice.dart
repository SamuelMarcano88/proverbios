import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../localization.dart';
import '../theme/app_theme.dart';

class CopyableErrorNotice extends StatelessWidget {
  const CopyableErrorNotice({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.terracottaTint,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: SingleChildScrollView(
                child: SelectableText(
                  message,
                  style: const TextStyle(color: AppColors.terracotta),
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: context.tr('copy_error'),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: message));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.tr('error_copied'))),
              );
            },
            icon: const Icon(Icons.copy_rounded),
          ),
        ],
      ),
    );
  }
}
