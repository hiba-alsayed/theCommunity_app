import 'package:flutter/material.dart';
import 'package:graduation_project/core/app_color.dart';
import '../../../profile/presentation/pages/get_profile_by_userid_page.dart';
import '../../domain/entities/campaigns.dart';
import '../../domain/entities/rating.dart';
import 'campaign_details_page.dart';

class AllRatingsPage extends StatelessWidget {
  final List<Rating> ratings;
  final String campaignTitle;
  final Campaigns campaign;

  const AllRatingsPage({
    Key? key,
    required this.ratings,
    required this.campaignTitle,
    required this.campaign,

  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.OceanBlue, Colors.white],
            stops: [0.0, 0.2],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.WhisperWhite,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.OceanBlue.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => CampaignDetailsPage(campaign: campaign),
                              ),
                            );
                          },
                          tooltip: 'العودة',
                        ),
                      ),
                    ),
                     Text('تقييمات الحملة',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ratings.isEmpty
                    ? const Center(
                  child: Text("لا توجد تقييمات لعرضها."),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  itemCount: ratings.length,
                  itemBuilder: (context, index) {
                    return RatingCard(rating: ratings[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RatingCard extends StatelessWidget {
  final Rating rating;

  const RatingCard({
    Key? key,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GetProfileByUserIdPage(
              userId: rating.ratingid,
              userName: rating.user,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.OceanBlue.withOpacity(0.2),
                    child: Text(
                      rating.user.isNotEmpty ? rating.user[0].toUpperCase() : 'U',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.OceanBlue),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rating.user,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          rating.date,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                          (index) => Icon(
                        index < rating.rating ? Icons.star_rounded : Icons.star_border_rounded,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              if (rating.comment.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  rating.comment,
                  style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}