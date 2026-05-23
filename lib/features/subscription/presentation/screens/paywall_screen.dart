import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streaksky/core/services/remote_config_service.dart';
import 'package:streaksky/core/constants/app_colors.dart';
import 'package:streaksky/features/subscription/presentation/providers/subscription_provider.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _isLoading = false;

  Future<void> _upgrade(String planType) async {
    setState(() => _isLoading = true);
    try {
      await ref.read(subscriptionControllerProvider).upgradeToPro(planType);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upgraded to StreakSky Pro successfully!')),
        );
        context.pop(); // Go back
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upgrade: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final remoteConfig = ref.watch(remoteConfigServiceProvider);
    final monthlyPrice = remoteConfig.monthlyPrice;
    final yearlyPrice = remoteConfig.yearlyPrice;

    return Scaffold(
      backgroundColor: AppColors.background, // Dark modern background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.diamond_outlined,
                size: 80,
                color: AppColors.primaryAccent,
              ),
              const SizedBox(height: 24),
              const Text(
                'Unlock StreakSky Pro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Get the full picture of your legacy. Unlimited tracking, multi-year heatmaps, career goals, and your personal AI agent.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              
              _buildFeatureRow(Icons.history, 'Multi-year Heatmap History'),
              const SizedBox(height: 16),
              _buildFeatureRow(Icons.flag_outlined, 'Advanced Career Goals'),
              const SizedBox(height: 16),
              _buildFeatureRow(Icons.smart_toy_outlined, 'Sky AI Personal Agent'),
              const SizedBox(height: 16),
              _buildFeatureRow(Icons.security, 'Unlimited Streak Shields'),
              
              const Spacer(),
              
              if (_isLoading)
                const Center(child: CircularProgressIndicator(color: AppColors.primaryAccent))
              else ...[
                ElevatedButton(
                  onPressed: () => _upgrade('monthly'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    '₹$monthlyPrice / month',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _upgrade('yearly'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    '₹$yearlyPrice / year (Save 44%)',
                    style: const TextStyle(
                      fontSize: 18, 
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryAccent, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
