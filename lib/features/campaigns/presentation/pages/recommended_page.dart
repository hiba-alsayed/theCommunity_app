import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/campaigns/presentation/bloc/campaign_bloc.dart';
import '../../../../core/app_color.dart';
import '../../../../core/widgets/loading_widget.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.CedarOlive, Colors.white],
              stops: [0.0, 0.2],
            ),
          ),
          child: BlocBuilder<CampaignBloc, CampaignState>(
            builder: (context, state) {
              if (state is LoadingRecommendedCampaigns) {
                return const Center(child: CircularProgressIndicator());
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
              }
              else {
                return const Center(child: LoadingWidget());
              }
            },
          ),
        ),
      ),
    );
  }
}