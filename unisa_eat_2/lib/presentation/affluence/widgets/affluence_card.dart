import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/data/affluence/models/affluence_model.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/presentation/affluence/bloc/affluence_cubit.dart';

class AffluenceCard extends StatefulWidget {
  const AffluenceCard({super.key});

  @override
  State<AffluenceCard> createState() => _AffluenceCardState();
}

class _AffluenceCardState extends State<AffluenceCard> {
  Timer? _pollingTimer;
  double _slideOffset = 0;

  @override
  void initState() {
    super.initState();
    // Load affluence data immediately
    context.read<AffluenceCubit>().fetchAffluence();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        context.read<AffluenceCubit>().fetchAffluence();
      }
    });
  }

  String _getAffluenceLevelText(String level, AppLocalizations l10n) {
    switch (level.toLowerCase()) {
      case 'good':
        return l10n.affluence_good;
      case 'medium':
        return l10n.affluence_medium;
      case 'high':
        return l10n.affluence_high;
      case 'full':
        return l10n.affluence_full;
      default:
        return l10n.affluence_unknown;
    }
  }

  Color _getAffluenceColor(String level) {
    switch (level.toLowerCase()) {
      case 'good':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'full':
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AffluenceCubit, AffluenceState>(
      builder: (context, state) {
        if (state is AffluenceLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Loading affluence data...'),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        } else if (state is AffluenceLoaded) {
          final data = state.affluence;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: data.status == 'closed'
                  ? _buildClosedState(context, data)
                  : _buildOpenState(context, data),
            ),
          );
        } else if (state is AffluenceError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Failed to load affluence data',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.error,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<AffluenceCubit>().fetchAffluence(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.error_outline, size: 50),
                ],
              ),
            ),
          );
        } else {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Loading affluence data...'),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildClosedState(BuildContext context, AffluenceModel data) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.affluence_closed,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                data.message ?? l10n.affluence_closed,
              ),
            ],
          ),
        ),
        Icon(
          Icons.access_time,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildOpenState(BuildContext context, AffluenceModel data) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getAffluenceLevelText(data.level ?? 'unknown', l10n),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getAffluenceColor(data.level ?? 'unknown'),
                  ),
                ),
                if (data.historicalNote != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    data.historicalNote!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '~${data.estimatedWait ?? 'N/A'}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.wait_time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Progress bar at bottom
        Container(
          width: double.infinity,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFE1BEE7), // Light purple background
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (data.occupancyPercentage ?? 0) / 100,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getAffluenceColor(data.level ?? 'unknown'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}