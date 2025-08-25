import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import '../../../../core/app_color.dart';
import '../../../../navigation/main_navigation_page.dart';
import '../bloc/campaign_bloc.dart';
import '../widgets/campaign_complaint_shimmer_list_widget.dart';
import '../widgets/campaign_list_widget.dart';
import '../../domain/entities/campaigns.dart';

class MyCampaignsPage extends StatefulWidget {
  const MyCampaignsPage({super.key});

  @override
  State<MyCampaignsPage> createState() => _MyCampaignsPageState();
}

class _MyCampaignsPageState extends State<MyCampaignsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CampaignBloc>(context).add(GetMyCampaignsEvent());
  }

  Future<void> _onRefresh() async {
    BlocProvider.of<CampaignBloc>(context).add(GetMyCampaignsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.SunsetOrange, Colors.white],
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
                                  color: AppColors.SunsetOrange.withOpacity(0.5),
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
                                    builder:
                                        (context) => const MainNavigationPage(),
                                  ),
                                );
                              },
                              tooltip: 'العودة',
                            ),
                          ),
                        ),
                        const Text(
                          'حملات انضممت إليها',
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
                      onRefresh: _onRefresh,
                      child: BlocBuilder<CampaignBloc, CampaignState>(
                        builder: (context, state) {
                          if (state is MyCampaignsLoading) {
                            return const Center(
                              child: CampaignComplaintListShimmer(),
                            );
                          } else if (state is MyCampaignsLoaded) {
                            final List<Campaigns> activeCampaigns =
                            state.myCampaigns.where((campaign) => campaign.status == 'نشطة').toList();

                            if (activeCampaigns.isEmpty) {
                              return ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: const [
                                  SizedBox(height: 300),
                                  Center(
                                    child: Text(
                                      'لا توجد حملات انضممت إليها حتى الآن.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return CampaignListWidget(campaigns: activeCampaigns);
                          }else if (state is MyCampaignsError) {
                            return Center(child: Text(state.message));
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
