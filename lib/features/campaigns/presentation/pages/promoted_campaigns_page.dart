import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/campaigns/presentation/bloc/campaign_bloc.dart';
import '../../../../core/app_color.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../navigation/main_navigation_page.dart';
import '../widgets/campaign_complaint_shimmer_list_widget.dart';
import '../widgets/campaign_list_widget.dart';

class PromotedCampaignsPage extends StatefulWidget {
  const PromotedCampaignsPage({super.key});

  @override
  State<PromotedCampaignsPage> createState() => _PromotedCampaignsPageState();
}

class _PromotedCampaignsPageState extends State<PromotedCampaignsPage> {
  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }
  Future<void> _loadCampaigns() async {
    context.read<CampaignBloc>().add(GetPromotedCampaignsEvent());
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
                          'حملات معاد نشرها',
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
                      onRefresh: _loadCampaigns,
                      child: BlocBuilder<CampaignBloc, CampaignState>(
                        builder: (context, state) {
                          if (state is LoadingPromotedCampaigns) {
                            return const Center(
                              child: CampaignComplaintListShimmer(),
                            );
                          } else if (state is PromotedCampaignsLoaded) {
                            if (state.promotedCampaigns.isEmpty) {
                              return const Center(
                                child: Text('لا توجد حملات مدعومة حالياً.'),
                              );
                            }
                            return CampaignListWidget(
                              campaigns: state.promotedCampaigns,
                            );
                          } else if (state is PromotedCampaignsError) {
                            return Center(
                              child: Text(
                                state.message,
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }return const SizedBox();
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