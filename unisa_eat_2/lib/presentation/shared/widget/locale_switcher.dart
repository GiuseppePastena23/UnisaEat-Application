import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/core/configs/localization/locale_cubit.dart';
import 'package:unisa_eat_2/core/configs/localization/supported_locales.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';

class LocaleSwitcher extends StatelessWidget {
  const LocaleSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: l10n.language,
      onSelected: (Locale locale) {
        context.read<LocaleCubit>().setLocale(locale);
      },
      itemBuilder: (BuildContext context) {
        return SupportedLocales.all.map((Locale locale) {
          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              children: [
                Text(SupportedLocales.getLocaleName(locale)),
                const Spacer(),
                BlocBuilder<LocaleCubit, Locale>(
                  builder: (context, currentLocale) {
                    return Icon(
                      Icons.check,
                      color: currentLocale.languageCode == locale.languageCode
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    );
                  },
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
