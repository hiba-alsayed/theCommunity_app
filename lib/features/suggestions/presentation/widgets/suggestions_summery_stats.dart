import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SuggestionSummaryStats extends StatelessWidget {
  final int totalVotes;
  final int requiredParticipants;
  final String requiredAmount;

  const SuggestionSummaryStats({
    super.key,
    required this.totalVotes,
    required this.requiredParticipants,
    required this.requiredAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildAnimatedStatCard(
              context: context,
              title: 'إجمالي الموافقين',
              count: totalVotes,
              icon: Icons.how_to_vote,
              color: Colors.blueAccent,
            ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.5),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: _buildAnimatedStatCard(
              context: context,
              title: 'المشاركون المطلوبون',
              count: requiredParticipants,
              icon: Icons.group_add_rounded,
              color: Colors.orange,
            ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.5),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: _buildAmountStatCard(
              context: context,
              title: 'المبلغ المطلوب',
              amount: requiredAmount,
              icon: Icons.attach_money,
              color: Colors.green,
            ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStatCard({
    required BuildContext context,
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: Animate(
                    effects: [
                      CustomEffect(
                        duration: 2000.ms,
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          final int currentCount = (value * count).round();
                          return FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "$currentCount",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                          );
                        },
                      ),
                    ],
                    child: const Text(""),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountStatCard({
    required BuildContext context,
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      amount,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}