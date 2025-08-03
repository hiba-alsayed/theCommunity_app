import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/app_color.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import 'package:graduation_project/features/suggestions/domain/entities/Suggestions.dart';
import '../../../../core/widgets/glowing_gps.dart';
import '../../../../core/widgets/snack_bar.dart';
import '../widgets/vote_statistics_card.dart';
import '../../../profile/presentation/pages/get_profile_by_userid_page.dart';
import '../bloc/suggestion_bloc.dart';
import '../widgets/suggestions_summery_stats.dart';
import '../widgets/vote_widget.dart';
import '../../../../core pages/location_map_view_page.dart';

class SuggestionDetailsPage extends StatefulWidget {
  final Suggestions suggestion;
  final bool isMySuggestions;
  const SuggestionDetailsPage({
    super.key,
    required this.suggestion,
    this.isMySuggestions = false,
  });

  @override
  State<SuggestionDetailsPage> createState() => _SuggestionDetailsPageState();
}

class _SuggestionDetailsPageState extends State<SuggestionDetailsPage> {

  void _openMap(BuildContext context) {
    if (widget.suggestion.location.latitude == null ||
        widget.suggestion.location.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        buildGlassySnackBar(
          message: 'إحداثيات الموقع غير متوفرة',
          color: AppColors.CedarOlive,
          context: context,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LocationMapPage(
              latitude: widget.suggestion.location.latitude!,
              longitude: widget.suggestion.location.longitude!,
              locationName: widget.suggestion.location.name ?? 'موقع المقترح',
            ),
      ),
    );
  }

  final Map<String, Map<String, dynamic>> categoryIcons = {
    'تنظيف وتزيين الأماكن العامة': {
      'icon': Icons.cleaning_services,
      'color': Colors.lightBlue,
    },
    'حملات تشجير': {'icon': Icons.nature, 'color': Colors.green},
    'يوم خيري': {'icon': Icons.volunteer_activism, 'color': Colors.pink},
    'ترميم أضرار (كوارث , عدوان)': {
      'icon': Icons.home_repair_service,
      'color': Colors.brown,
    },
    'إنارة الشوارع بالطاقة الشمسية': {
      'icon': Icons.lightbulb,
      'color': Colors.amber,
    },
  };

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.suggestion.imageUrl;
    final suggestion = widget.suggestion;

    final categoryData =
        categoryIcons[widget.suggestion.category] ??
        {'icon': Icons.category, 'color': Colors.grey};
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null && imageUrl.isNotEmpty)
                Container(
                  margin: const EdgeInsets.all(16),
                  height: 250,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, _) =>
                                Center(child: Text("فشل تحميل الصورة")),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: LoadingWidget());
                        },
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  height: 250,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(child: Text('لا توجد صورة')),
                ),
              // Title +category
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.suggestion.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: categoryData['color'].withOpacity(
                          0.2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: categoryData['color'],
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            categoryData['icon'],
                            size: 16, // Icon size
                            color: categoryData['color'],
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            widget.suggestion.category,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  categoryData['color'],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // User info + date
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GetProfileByUserIdPage(
                              userId: suggestion.user.userid,
                              userName: suggestion.user.createdBy,),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.person,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                          "بواسطة: ${widget.suggestion.user.createdBy }",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14,
                            color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          widget.suggestion.createdat,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.suggestion.description,
                  style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.grey[800]),
                ),
              ),
              const SizedBox(height: 24),
              // Location
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _openMap(context),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الموقع',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              GlowingGPSIcon(),
                              const SizedBox(width: 4),
                              if (widget.suggestion.location.name != null)
                                Text(widget.suggestion.location.name!),
                              const SizedBox(width: 8),
                              Text(
                                '(اضغط لعرض الموقع على الخريطة)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  // decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (widget.suggestion.location.latitude != null &&
                              widget.suggestion.location.longitude != null)
                            LocationPreview(
                              latitude: widget.suggestion.location.latitude!,
                              longitude: widget.suggestion.location.longitude!,
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Stats
              BlocConsumer<SuggestionBloc, SuggestionState>(
                listener: (context, state) {
                  if (state is VoteOnSuggestionSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      buildGlassySnackBar(
                        message: 'تم التصويت بنجاح',
                        color: AppColors.CedarOlive,
                        context: context,
                      ),
                    );
                  } else if (state is VoteOnSuggestionFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      buildGlassySnackBar(
                        message: 'لقد قمت بالتصويت بالفعل',
                        color: AppColors.RichBerry,
                        context: context,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final currentSuggestion = (state is VoteOnSuggestionSuccess)
                      ? state.updatedSuggestion
                      : widget.suggestion;
                  return SuggestionSummaryStats(
                    totalVotes: currentSuggestion.likes,
                    requiredParticipants: currentSuggestion.numberOfParticipants,
                    requiredAmount: currentSuggestion.requiredAmount,
                  );
                },
              ),
              const SizedBox(height: 24),
              // Voting
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: Colors.blueGrey.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ما رأيك في هذا المقترح؟',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<SuggestionBloc, SuggestionState>(
                          builder: (context, state) {
                            final currentSuggestion =
                            (state is VoteOnSuggestionSuccess)
                                ? state.updatedSuggestion
                                : widget.suggestion;
                            return VotingSlider(suggestion: currentSuggestion);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<SuggestionBloc, SuggestionState>(
                builder: (context, state) {
                  final currentSuggestion = (state is VoteOnSuggestionSuccess)
                      ? state.updatedSuggestion
                      : widget.suggestion;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: VoteStatisticsCard(
                      likes: currentSuggestion.likes,
                      dislikes: currentSuggestion.dislikes,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
