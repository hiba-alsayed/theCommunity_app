import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/my_donations_entity.dart';
import '../bloc/donation_bloc.dart';

class MyDonationsPage extends StatelessWidget {
  const MyDonationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DonationBloc>(context).add(const GetMyDonationsEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text('تبرعاتي'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<DonationBloc, DonationState>(
          builder: (context, state) {
            // MyDonationLoading state
            if (state is MyDonationLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            // MyDonationsSuccess state
            else if (state is MyDonationsSuccess) {
              if (state.donations.isEmpty) {
                return const Center(child: Text('لا توجد تبرعات حالياً.'));
              }
              return ListView.builder(
                itemCount: state.donations.length,
                itemBuilder: (context, index) {
                  final donation = state.donations[index];
                  return DonationCard(donation: donation);
                },
              );
            }
            // MyDonationFailure state
            else if (state is MyDonationFailure) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            }
            // Initial state or any other unhandled state
            return const Center(child: Text('اسحب لتحديث الصفحة'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Re-dispatch the event to refresh the data
          BlocProvider.of<DonationBloc>(context).add(const GetMyDonationsEvent());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class DonationCard extends StatelessWidget {
  final DonationItemEntity donation;

  const DonationCard({super.key, required this.donation});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
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
              ),
            ),
            const SizedBox(height: 8),
            // Amount and Status
            Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'المبلغ: ${donation.amount} ل.س',
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                Text(
                  'الحالة: ${donation.status}',
                  style: TextStyle(
                    fontSize: 16,
                    color: donation.status == 'مدفوع' ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Donation Date
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'تاريخ التبرع: ${donation.donatedAt.day}/${donation.donatedAt.month}/${donation.donatedAt.year}', // Donation Date: ...
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