import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VoteStatisticsCard extends StatelessWidget {
  final int likes;
  final int dislikes;

  const VoteStatisticsCard({
    super.key,
    required this.likes,
    required this.dislikes,
  });

  @override
  Widget build(BuildContext context) {
    final int totalVoters = likes + dislikes;
    final double likeRatio = totalVoters > 0 ? likes / totalVoters : 0.0;
    final double dislikeRatio = totalVoters > 0 ? dislikes / totalVoters : 0.0;

    return Card(
      elevation: 4,
      shadowColor: Colors.blueGrey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
            'إحصائيات التصويت',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              ),
            const SizedBox(height: 16),
            // Total Voters Count
            Row(
              children: [
                Text(
                  'عدد المصوتين:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(width: 8),
                Animate(
                  effects: [
                    CustomEffect(
                      duration: 1500.ms,
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        final int currentCount = (value * totalVoters).round();
                        return Text(
                          "$currentCount",
                          style:TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                            fontSize: 16
                          ),
                        );
                      },
                    ),
                  ],
                  child: const Text(""),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Like/Dislike Progress Bar
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildVoteBarSegment(
                        context,
                        value: likeRatio,
                        color: Colors.green,
                        icon: Icons.thumb_up_alt_rounded,
                        label: 'إعجاب',
                      ).animate().fadeIn(delay: 1600.ms, duration: 800.ms).slideX(
                        begin: -1.0,
                        curve: Curves.easeOutCubic,
                      ),
                      const SizedBox(height: 12),
                      _buildVoteBarSegment(
                        context,
                        value: dislikeRatio,
                        color: Colors.red,
                        icon: Icons.thumb_down_alt_rounded,
                        label: 'عدم إعجاب',
                      ).animate().fadeIn(delay: 1800.ms, duration: 800.ms).slideX(
                        begin: -1.0,
                        curve: Curves.easeOutCubic,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoteBarSegment(
      BuildContext context, {
        required double value,
        required Color color,
        required IconData icon,
        required String label,
      }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          '${(value * 100).toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Animate(
            effects: [
              CustomEffect(
                duration: 1200.ms,
                curve: Curves.easeOutCubic,
                builder: (context, animValue, child) => LinearProgressIndicator(
                  value: animValue * value,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                  backgroundColor: color.withOpacity(0.15),
                  color: color,
                ),
              ),
            ],
            child: const SizedBox(height: 10),
          ),
        ),
      ],
    );
  }
}