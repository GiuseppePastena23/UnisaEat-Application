import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisa_eat_2/core/configs/localization/locale_cubit.dart';
import 'package:unisa_eat_2/core/configs/localization/supported_locales.dart';
import 'package:unisa_eat_2/core/configs/theme/theme_cubit.dart';
import 'package:unisa_eat_2/domain/auth/usecases/logout.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_state.dart';
import 'package:unisa_eat_2/presentation/shared/widget/custom_card.dart';
import 'package:unisa_eat_2/service_locator.dart';
import 'package:unisa_eat_2/core/services/time_service.dart';
import 'package:unisa_eat_2/presentation/notification/bloc/notification_cubit.dart';
import 'package:unisa_eat_2/presentation/notification/bloc/notification_state.dart';
import 'package:unisa_eat_2/data/notification/sources/notification_api_service.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _debugMode = false;

  @override
  void initState() {
    super.initState();
    _loadDebugMode();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: _toggleDebugMode,
          child: Text(l10n.settings),
        ),
      ),
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, profileState) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Profile Section
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.profile,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      if (profileState is UserProfileSuccess) ...[
                        Text(
                          '${profileState.user.nome} ${profileState.user.cognome}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _infoRow(context, Icons.email, l10n.email_label, profileState.user.email.toString()),
                        const SizedBox(height: 8),
                        _infoRow(context, Icons.badge, 'Codice Fiscale', profileState.user.codiceFiscale.toString()),
                        if (profileState.user.phone != null && profileState.user.phone!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _infoRow(context, Icons.phone, l10n.phone_number, profileState.user.phone.toString()),
                        ],
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            sl<LogoutUsecase>().call();
                            context.read<UserProfileCubit>().reset();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: Text(l10n.log_out),
                        ),
                      ] else if (profileState is UserProfileLoading) ...[
                        const Center(child: CircularProgressIndicator()),
                      ] else if (profileState is UserProfileFailure) ...[
                        Center(child: Text(l10n.error_loading)),
                        ElevatedButton(
                          onPressed: () => context.read<UserProfileCubit>().getUser(),
                          child: Text(l10n.retry),
                        ),
                      ] else ...[
                        Center(child: Text(l10n.error_loading)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Language Section
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.language,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                       BlocBuilder<LocaleCubit, Locale>(
                         builder: (context, currentLocale) {
                           return DropdownButton<Locale>(
                             value: currentLocale,
                             dropdownColor: Theme.of(context).colorScheme.surface,
                             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                               color: Theme.of(context).colorScheme.onSurface,
                             ),
                             items: SupportedLocales.all.map((Locale locale) {
                               return DropdownMenuItem<Locale>(
                                 value: locale,
                                 child: Text(
                                   SupportedLocales.getLocaleName(locale),
                                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                     color: Theme.of(context).colorScheme.onSurface,
                                   ),
                                 ),
                               );
                             }).toList(),
                             onChanged: (Locale? newLocale) {
                               if (newLocale != null) {
                                 context.read<LocaleCubit>().setLocale(newLocale);
                               }
                             },
                           );
                         },
                       ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Theme Section
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.theme,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                       BlocBuilder<ThemeCubit, ThemeMode>(
                         builder: (context, currentThemeMode) {
                           return DropdownButton<ThemeMode>(
                             value: currentThemeMode,
                             dropdownColor: Theme.of(context).colorScheme.surface,
                             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                               color: Theme.of(context).colorScheme.onSurface,
                             ),
                             items: ThemeMode.values.map((ThemeMode mode) {
                               return DropdownMenuItem<ThemeMode>(
                                 value: mode,
                                 child: Text(
                                   _getThemeModeName(mode),
                                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                     color: Theme.of(context).colorScheme.onSurface,
                                   ),
                                 ),
                               );
                             }).toList(),
                             onChanged: (ThemeMode? newMode) {
                               if (newMode != null) {
                                 context.read<ThemeCubit>().setThemeMode(newMode);
                               }
                             },
                           );
                         },
                       ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Biometric Section
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.enable_biometric,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<bool>(
                        future: _checkBiometricAvailability(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.data == true) {
                            return FutureBuilder<bool>(
                              future: _getBiometricEnabled(),
                              builder: (context, enabledSnapshot) {
                                if (enabledSnapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                return SwitchListTile(
                                  title: Text(l10n.enable_biometric),
                                  value: enabledSnapshot.data ?? false,
                                  onChanged: (value) async {
                                    await _setBiometricEnabled(value);
                                    setState(() {});
                                  },
                                  contentPadding: EdgeInsets.zero,
                                );
                              },
                            );
                          } else {
                            return Text(l10n.biometric_not_available);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Notification Section
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.notificationSettings,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      BlocProvider(
                        create: (context) => NotificationCubit(sl<NotificationApiService>())..loadPreferences(),
                        child: BlocBuilder<NotificationCubit, NotificationState>(
                          builder: (context, state) {
                            if (state is NotificationPreferencesLoaded) {
                              return Column(
                                children: [
                                  SwitchListTile(
                                    title: Text(l10n.enable_notifications),
                                    subtitle: Text(l10n.turn_on_notifications),
                                    value: state.notificationsEnabled,
                                    onChanged: (value) {
                                      context.read<NotificationCubit>().setNotificationsEnabled(value);
                                    },
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  const Divider(),
                                  _notificationToggle(
                                    context,
                                    l10n.low_balance_alerts,
                                    l10n.balance_low_message,
                                    state.lowBalanceAlerts,
                                    state.notificationsEnabled,
                                    (value) => context.read<NotificationCubit>().updatePreferences(lowBalanceAlerts: value),
                                  ),
                                  _notificationToggle(
                                    context,
                                    l10n.order_status_updates,
                                    l10n.order_status_message,
                                    state.orderStatusAlerts,
                                    state.notificationsEnabled,
                                    (value) => context.read<NotificationCubit>().updatePreferences(orderStatusAlerts: value),
                                  ),
                                  _notificationToggle(
                                    context,
                                    l10n.transaction_alerts,
                                    l10n.transaction_message,
                                    state.transactionAlerts,
                                    state.notificationsEnabled,
                                    (value) => context.read<NotificationCubit>().updatePreferences(transactionAlerts: value),
                                  ),
                                  _notificationToggle(
                                    context,
                                    l10n.canteen_open,
                                    l10n.canteen_message,
                                    state.canteenOpenAlerts,
                                    state.notificationsEnabled,
                                    (value) => context.read<NotificationCubit>().updatePreferences(canteenOpenAlerts: value),
                                  ),
                                  _notificationToggle(
                                    context,
                                    l10n.affluence_updates,
                                    l10n.affluence_message,
                                    state.affluenceAlerts,
                                    state.notificationsEnabled,
                                    (value) => context.read<NotificationCubit>().updatePreferences(affluenceAlerts: value),
                                  ),
                                ],
                              );
                            }
                            if (state is NotificationLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (state is NotificationError) {
                              return Column(
                                children: [
                                  Text(state.message, style: const TextStyle(color: Colors.red)),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () => context.read<NotificationCubit>().loadPreferences(),
                                    child: Text(l10n.retry),
                                  ),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Help & Support Section
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.help_support,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(Icons.help_outlined),
                        title: Text(l10n.faq),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          context.push('/settings/faq');
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.feedback_outlined),
                        title: Text(l10n.send_feedback),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          context.push('/settings/feedback');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (_debugMode) ...[
                const SizedBox(height: 16),
                // Debug Section
                CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debug Mode',
                           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                             color: Theme.of(context).colorScheme.error,
                           ),
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: Text(l10n.bypass_time),
                          subtitle: Text(l10n.bypass_message),
                          value: true,
                          onChanged: null,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _showDebugInfo,
                          child: Text(l10n.show_debug_info),
                        ),
                        const SizedBox(height: 8),
                         Text(
                           'Debug mode is enabled. You can order outside normal hours and select any menu dates.',
                           style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                         ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<bool> _checkBiometricAvailability() async {
    try {
      final localAuth = LocalAuthentication();
      return await localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _getBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('biometric_enabled') ?? false;
  }

  Future<void> _setBiometricEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', value);
  }

  Future<void> _loadDebugMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _debugMode = prefs.getBool('debug_mode') ?? false;
    });
  }

  Future<void> _toggleDebugMode() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !_debugMode;
    await prefs.setBool('debug_mode', newValue);
    setState(() {
      _debugMode = newValue;
    });

    // Reload the app when debug mode is toggled
    await SystemNavigator.pop();
  }

  void _showDebugInfo() {
    final l10n = AppLocalizations.of(context)!;
    final now = sl<TimeService>().now();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.debug_info),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current Date/Time: ${now.toString()}'),
              Text('Weekday: ${now.weekday} (${_getWeekdayName(now.weekday)})'),
              Text('Hour: ${now.hour}'),
              const SizedBox(height: 16),
              const Text('App Version: 0.1.0'),
              const Text('Environment: Development'),
              const SizedBox(height: 16),
              FutureBuilder<String>(
                future: _getDeviceInfo(),
                builder: (context, snapshot) {
                  return Text('Device: ${snapshot.data ?? 'Loading...'}');
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<UserProfileCubit, UserProfileState>(
                builder: (context, state) {
                  if (state is UserProfileSuccess) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${state.user.nome} ${state.user.cognome}'),
                        Text('Email: ${state.user.email}'),
                        Text('Fiscal Code: ${state.user.codiceFiscale}'),
                        Text('Balance: €${state.user.saldo?.toStringAsFixed(2) ?? 'N/A'}'),
                      ],
                    );
                  }
                  return const Text('User: Not loaded');
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Future<String> _getDeviceInfo() async {
    // Simple device info
    return 'Flutter App';
  }

  String _getWeekdayName(int weekday) {
    const names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return names[weekday - 1];
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  Widget _notificationToggle(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    bool enabled,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      onChanged: enabled ? onChanged : null,
      contentPadding: EdgeInsets.zero,
    );
  }
}
