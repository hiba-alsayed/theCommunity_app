import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/campaigns/presentation/bloc/campaign_bloc.dart';
import '../../../../core/app_color.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../navigation/main_navigation_page.dart';
import '../widgets/campaign_complaint_shimmer_list_widget.dart';
import '../widgets/campaign_list_widget.dart';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({super.key});

  @override
  State<RecommendedPage> createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
  @override
  void initState() {
    super.initState();
    context.read<CampaignBloc>().add(GetRecommendedCampaignsEvent());
    _loadRecommendedCampaigns;
  }
  Future<void> _loadRecommendedCampaigns() async {
    context.read<CampaignBloc>().add(GetRecommendedCampaignsEvent());
  }
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
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20.0),
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
                              icon: const Icon(Icons.arrow_back, color: Colors.black),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => const MainNavigationPage()),
                                );
                              },
                              tooltip: 'العودة',
                            ),
                          ),
                        ),
                        const Text(
                          'حملات مقترحة',
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
                    child: RefreshIndicator(
                      color: AppColors.OceanBlue,
                      backgroundColor: AppColors.WhisperWhite,
                      onRefresh: _loadRecommendedCampaigns,
                      child: BlocBuilder<CampaignBloc, CampaignState>(
                        builder: (context, state) {
                          if (state is LoadingRecommendedCampaigns) {
                            return const Center(child: CampaignComplaintListShimmer());
                          } else if (state is RecommendedCampaignsLoaded) {
                            if (state.recommendedCampaigns.isEmpty) {
                              return const Center(
                                child: Text('لا توجد حملات موصى بها حالياً.'),
                              );
                            }
                            return CampaignListWidget(
                              campaigns: state.recommendedCampaigns,
                            );
                          } else if (state is CampaignErrorState) {
                            return Center(
                              child: Text(
                                'حدث خطأ: ${state.message}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}