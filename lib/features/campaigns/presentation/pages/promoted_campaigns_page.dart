import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/campaigns/presentation/bloc/campaign_bloc.dart';
import 'package:graduation_project/features/campaigns/presentation/widgets/promoted_list_widget.dart';

class PromotedCampaignsPage extends StatefulWidget {
  const PromotedCampaignsPage({super.key});

  @override
  State<PromotedCampaignsPage> createState() => _PromotedCampaignsPageState();
}

class _PromotedCampaignsPageState extends State<PromotedCampaignsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CampaignBloc>().add(GetPromotedCampaignsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحملات المميزة'),
      ),
      body: BlocBuilder<CampaignBloc, CampaignState>(
        builder: (context, state) {
          if (state is LoadingPromotedCampaigns) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (state is PromotedCampaignsLoaded) {
            return PromotedCampaignsListView(
              campaigns: state.promotedCampaigns,
            );
          }
          else if (state is PromotedCampaignsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(
            child: Text('اسحب للأسفل لتحديث الصفحة'),
          );
        },
      ),
    );
  }
}