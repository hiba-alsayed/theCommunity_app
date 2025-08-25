import 'package:flutter/material.dart';
import 'package:graduation_project/features/campaigns/domain/entities/campaigns.dart';
import 'package:graduation_project/features/campaigns/presentation/widgets/promoted_carousel_ltem_widget.dart';

class HorizontalPromotedListWidget extends StatelessWidget {
  final List<Campaigns> campaigns;

  const HorizontalPromotedListWidget({super.key, required this.campaigns});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: campaigns.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return PromotedListItem(campaign: campaigns[index]);
        },
      ),
    );
  }
}


