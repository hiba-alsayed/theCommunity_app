import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/campaign_bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حملاتي')),
      body: BlocBuilder<CampaignBloc, CampaignState>(
        builder: (context, state) {
          if (state is MyCampaignsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyCampaignsLoaded) {
            final List<Campaigns> activeCampaigns = state.myCampaigns
                .where((campaign) => campaign.status == 'نشطة')
                .toList();

            if (activeCampaigns.isEmpty) {
              return const Center(child: Text('لا توجد حملات نشطة حتى الآن.'));
            }

            return CampaignListWidget(campaigns: activeCampaigns);
          } else if (state is MyCampaignsError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('لا توجد بيانات للعرض.'));
          }
        },
      ),
    );
  }
}
