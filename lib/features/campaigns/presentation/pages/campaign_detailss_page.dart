import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/campaign_bloc.dart';
import '../widgets/campaign_shimmer_widget.dart';
import 'campaign_details_page.dart';

class CampaignDetailssPage extends StatelessWidget {
  final int campaignId;

  const CampaignDetailssPage({Key? key, required this.campaignId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CampaignBloc>()..add(GetDetailsCampaignEvent(campaignId)),
      child: Scaffold(
        body: BlocBuilder<CampaignBloc, CampaignState>(
          buildWhen: (previous, current) {
            //  نعيد بناء الواجهة فقط إذا الحالة فيها تفاصيل الحملة
            return current is CampaignDetailsLoaded ||
                current is CampaignDetailsError ||
                current is LoadingCampaignDetails;
          },
          builder: (context, state) {
            if (state is LoadingCampaignDetails) {
              return const CampaignDetailsShimmer();
            } else if (state is CampaignDetailsError) {
              return Center(child: Text(state.message));
            } else if (state is CampaignDetailsLoaded) {
              return CampaignDetailsPage(campaign: state.campaign);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
