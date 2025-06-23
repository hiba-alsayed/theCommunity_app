import 'package:flutter/material.dart';
import 'package:graduation_project/features/campaigns/domain/entities/campaigns.dart';
import 'package:graduation_project/features/campaigns/presentation/pages/campaign_details_page.dart'; // Make sure this import is correct

class PromotedCampaignsListView extends StatelessWidget {
  final List<Campaigns> campaigns;

  const PromotedCampaignsListView({
    super.key,
    required this.campaigns,
  });

  @override
  Widget build(BuildContext context) {
    if (campaigns.isEmpty) {
      return const Center(
        child: Text('لا توجد حملات مميزة حالياً.'),
      );
    }
    return ListView.builder(
      itemCount: campaigns.length,
      itemBuilder: (context, index) {
        final campaign = campaigns[index];
        return _PromotedCampaignListItem(campaign: campaign);
      },
    );
  }
}

class _PromotedCampaignListItem extends StatelessWidget {
  final Campaigns campaign;

  const _PromotedCampaignListItem({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CampaignDetailsPage(campaign: campaign),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campaign Image
            if (campaign.imageUrl != null)
              Image.network(
                campaign.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 48);
                },
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    campaign.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}