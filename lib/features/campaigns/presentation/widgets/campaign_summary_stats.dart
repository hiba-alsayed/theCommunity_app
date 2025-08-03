import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:graduation_project/features/campaigns/domain/entities/campaigns.dart';

class CampaignSummaryStats  extends StatelessWidget {
  final Campaigns campaign;

  const CampaignSummaryStats({
    Key? key,
    required this.campaign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: campaign.status == 'منجزة'
          ? _buildCompletedLayout(context)
          : _buildActiveLayout(context),
    );
  }
  Widget _buildCompletedLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ملخص إنجازات الحملة 🏆",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ).animate().fadeIn(delay: 200.ms).slideX(),
        const SizedBox(height: 24),

        _buildAnimatedDonationStat(
          context: context,
          total: campaign.donationTotal,
          required: double.tryParse(campaign.requiredAmount) ?? 0.0,
        ).animate().fadeIn(delay: 400.ms, duration: 800.ms).slideY(begin: 0.5),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAnimatedCountStat(
                context: context,
                title: 'عدد المشاركين النهائي',
                count: campaign.joinedParticipants,
                icon: Icons.people_alt_rounded,
                color: Colors.blue,
              ).animate().fadeIn(delay: 600.ms, duration: 800.ms).slideY(begin: 0.5),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAnimatedRatingStat(
                context: context,
                rating: campaign.avgRating ?? 0.0,
              ).animate().fadeIn(delay: 800.ms, duration: 800.ms).slideY(begin: 0.5),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildActiveLayout(BuildContext context) {
    return Row(
      children: [
        // Card 1
        Expanded(
          child: _buildAnimatedCountStat(
            context: context,
            title: 'المشاركون المطلوبون',
            count: campaign.numberOfParticipants ?? 0,
            icon: Icons.group_add_rounded,
            color: Colors.orange,
          ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.5),
        ),
        const SizedBox(width: 12),

        // Card 2
        Expanded(
          child: _buildAnimatedCountStat(
            context: context,
            title: 'المشاركون الحاليون',
            count: campaign.joinedParticipants,
            icon: Icons.people_alt_rounded,
            color: Colors.blue,
          ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.5),
        ),
        const SizedBox(width: 12),

        // Card 3
        Expanded(
          child: _buildAnimatedRatingStat(
            context: context,
            rating: campaign.avgRating ?? 0.0,
          ).animate().fadeIn(delay: 1600.ms).slideY(begin: 0.5),
        ),
      ],
    );
  }
}
Widget _buildAnimatedDonationStat({
  required BuildContext context,
  required double total,
  required double required,
}) {
  final double progress = required > 0 ? (total / required).clamp(0.0, 1.0) : 1.0;
  return Card(
    elevation: 4,
    shadowColor: Colors.green.withOpacity(0.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_money_rounded, color: Colors.green[600]),
              const SizedBox(width: 8),
              Text('المبلغ الذي تم جمعه', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          Animate(
            effects: [
              CustomEffect(
                duration: 2000.ms,
                curve: Curves.easeOutCubic,
                builder: (context, value, child) => Text(
                  "${(value * total).toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ),
            ],
            child: const Text(""),
          ),
          const SizedBox(height: 8),
          Animate(
            effects: [
              ScaleEffect(
                duration: 1500.ms,
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
                begin: const Offset(0, 1),
                end: const Offset(1, 1),
              ),
            ],
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.grey[200],
              color: Colors.green,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildAnimatedCountStat({
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
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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

Widget _buildAnimatedRatingStat({required BuildContext context, required double rating}) {
  return Card(
    elevation: 4,
    shadowColor: Colors.amber.withOpacity(0.4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Animate(
            effects: [
              ScaleEffect(delay: 500.ms, duration: 800.ms, curve: Curves.elasticOut),
              ThenEffect(delay: 200.ms),
              ShimmerEffect(duration: 1800.ms, color: Colors.yellow.withOpacity(0.7)),
            ],
            child: const Icon(Icons.star_rounded, size: 32, color: Colors.amber),
          ),
          const SizedBox(height: 12),
          Animate(
            effects: [
              CustomEffect(
                duration: 2000.ms,
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  final double currentRating = value * rating;
                  return Text(
                    currentRating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  );
                },
              ),
            ],
            child: const Text(""),
          ),
          const SizedBox(height: 4),
          Text('متوسط التقييم', style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}