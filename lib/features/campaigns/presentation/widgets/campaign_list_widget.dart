import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/widgets/glowing_gps.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/app_color.dart';
import '../../../../injection_container.dart' as di;
import '../../../Donation/presentation/bloc/donation_bloc.dart';
import '../../domain/entities/campaigns.dart';
import '../pages/campaign_details_page.dart';

class CampaignListWidget extends StatefulWidget {
  final List<Campaigns> campaigns;

  const CampaignListWidget({Key? key, required this.campaigns}) : super(key: key);

  @override
  State<CampaignListWidget> createState() => _CampaignListWidgetState();
}
class _CampaignListWidgetState extends State<CampaignListWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      // physics:  NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(14),
      itemCount: widget.campaigns.length,
      itemBuilder: (context, index) {
        final campaign = widget.campaigns[index];
        final animationDelay = Duration(milliseconds: 100 + index * 50);

        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                animationDelay.inMilliseconds / _animationController.duration!.inMilliseconds,
                1.0,
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                  animationDelay.inMilliseconds / _animationController.duration!.inMilliseconds,
                  1.0,
                  curve: Curves.easeOutCubic,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CampaignCard(campaign: campaign),
            ),
          ),
        );
      },
    );
  }
}

//card
class CampaignCard extends StatelessWidget {
  final Campaigns campaign;

  const CampaignCard({Key? key, required this.campaign}) : super(key: key);


  CampaignStatus get _campaignStatus {
    switch (campaign.status) {
      case 'نشطة':
        return CampaignStatus.active;
      case 'منجزة':
        return CampaignStatus.completed;
      case 'ملغية':
        return CampaignStatus.canceled;
      default:
        return CampaignStatus.unknown;
    }
  }
  Color getStatusColor(CampaignStatus status) {
    switch (status) {
      case CampaignStatus.active:
        return Colors.green.shade600;
      case CampaignStatus.completed:
        return AppColors.SunsetOrange;
      case CampaignStatus.canceled:
        return Colors.red;
      default:
        return Colors.grey.shade500;
    }
  }
  IconData getStatusIcon(CampaignStatus status) {
    switch (status) {
      case CampaignStatus.active:
        return Icons.rocket_launch_outlined;
      case CampaignStatus.completed:
        return Icons.check_circle_outline;
      case CampaignStatus.canceled:
        return Icons.cancel;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(_campaignStatus);
    final isCompleted = _campaignStatus == CampaignStatus.completed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.sl<DonationBloc>(),
                  child: CampaignDetailsPage(campaign: campaign),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: campaign.imageUrl != null
                      ?
                  Image.network(
                    campaign.imageUrl!,
                    width: 100,
                    height: 120,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 100,
                          height: 120,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 120,
                      color: Colors.grey[200],
                      child: Icon(Icons.broken_image, size: 40, color: Colors.grey[400]),
                    ),
                  )
                      : Container(
                    width: 100,
                    height: 120,
                    color: Colors.grey[200],
                    child: Icon(Icons.image, size: 40, color: Colors.grey[400]),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              campaign.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isCompleted)
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: 0.5 + (0.5 * value),
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: statusColor.withOpacity(0.4),
                                          blurRadius: 6 * value,
                                          spreadRadius: 2 * value,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          else
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        campaign.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    GlowingGPSIcon(),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        campaign.campaignLocation.name ?? 'غير محدد',
                                        style: Theme.of(context).textTheme.labelMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.people_outline, size: 16, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${campaign.joinedParticipants ?? 0}',
                                      style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month_outlined, size: 16, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(
                                      campaign.executionDate ?? 'غير محدد',
                                      style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            avatar: Icon(
                              getStatusIcon(_campaignStatus),
                              size: 16,
                              color: statusColor,
                            ),
                            label: Text(
                              campaign.status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: statusColor.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: statusColor.withOpacity(0.3)),
                            ),
                            elevation: 4,
                            shadowColor: statusColor.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ],

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
enum CampaignStatus { active, completed,canceled, unknown }