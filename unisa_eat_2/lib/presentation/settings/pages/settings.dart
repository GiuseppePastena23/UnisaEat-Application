import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        _infoRow(context, Icons.email, 'Email', profileState.user.email.toString()),
                        const SizedBox(height: 8),
                        _infoRow(context, Icons.badge, 'Codice Fiscale', profileState.user.codiceFiscale.toString()),
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
                        const Center(child: Text('Error loading profile')),
                        ElevatedButton(
                          onPressed: () => context.read<UserProfileCubit>().getUser(),
                          child: const Text('Retry'),
                        ),
                      ] else ...[
                        const Center(child: Text('No profile data')),
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
                        'Biometric Login',
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
                                  title: const Text('Enable Biometric Login'),
                                  value: enabledSnapshot.data ?? false,
                                  onChanged: (value) async {
                                    await _setBiometricEnabled(value);
                                    setState(() {});
                                  },
                                );
                              },
                            );
                          } else {
                            return const Text('Biometric authentication not available on this device');
                          }
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
                          title: const Text('Bypass Time Restrictions'),
                          subtitle: const Text('Allow ordering anytime'),
                          value: true, // Always on in debug
                          onChanged: null, // Disabled, always enabled
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _showDebugInfo,
                          child: const Text('Show Debug Info'),
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
    final now = sl<TimeService>().now();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Debug Information'),
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
            child: const Text('Close'),
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
}
