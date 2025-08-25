import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_color.dart';
import '../../domain/entity/my_donations_entity.dart';
import '../bloc/donation_bloc.dart';

class MyDonationsPage extends StatefulWidget {
  const MyDonationsPage({super.key});

  @override
  State<MyDonationsPage> createState() => _MyDonationsPageState();
}

class _MyDonationsPageState extends State<MyDonationsPage> {
  @override
  void initState() {
    super.initState();
    _fetchDonations();
  }

  Future<void> _fetchDonations() async {
    context.read<DonationBloc>().add(const GetMyDonationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'تبرعاتي',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.OceanBlue, Colors.white],
            stops: [0.0, 0.2],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BlocBuilder<DonationBloc, DonationState>(
            builder: (context, state) {
              if (state is MyDonationLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MyDonationsSuccess) {
                if (state.donations.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _fetchDonations,
                    color: AppColors.OceanBlue,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height - kToolbarHeight,
                        alignment: Alignment.center,
                        child: const Text(
                          'لا توجد تبرعات حالياً.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: _fetchDonations,
                  color: AppColors.OceanBlue,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.donations.length,
                    itemBuilder: (context, index) {
                      final donation = state.donations[index];
                      return DonationCard(donation: donation);
                    },
                  ),
                );
              } else if (state is MyDonationFailure) {
                return RefreshIndicator(
                  onRefresh: _fetchDonations,
                  color: AppColors.OceanBlue,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height - kToolbarHeight,
                      alignment: Alignment.center,
                      child: Text(
                        state.errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }
              // This is the initial state before any data is loaded or refreshed.
              return RefreshIndicator(
                onRefresh: _fetchDonations,
                color: AppColors.OceanBlue,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height - kToolbarHeight,
                    alignment: Alignment.center,
                    child: const Text(
                      'اسحب لتحديث الصفحة',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DonationCard extends StatelessWidget {
  final DonationItemEntity donation;

  const DonationCard({super.key, required this.donation});

  @override
  Widget build(BuildContext context) {
    final isPaid = donation.status == 'مدفوع';

    return Card(
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Title
            Text(
              donation.project.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.OceanBlue,
              ),
            ),
            const SizedBox(height: 12),

            // Amount + Status
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.green.withOpacity(0.1),
                  child: const Icon(Icons.monetization_on, color: Colors.green, size: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  '${donation.amount} ل.س',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPaid ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    donation.status,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isPaid ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Donation Date
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  child: const Icon(Icons.calendar_today, color: Colors.grey, size: 14),
                ),
                const SizedBox(width: 8),
                Text(
                  '${donation.donatedAt.day}/${donation.donatedAt.month}/${donation.donatedAt.year}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}