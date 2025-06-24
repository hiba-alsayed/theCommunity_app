import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entites/complaint.dart';
import '../bloc/complaint_bloc.dart';
import '../widgets/complaint_list_widget.dart';

class AllNearbyComplaintsPage extends StatefulWidget {
  const AllNearbyComplaintsPage({super.key});

  @override
  State<AllNearbyComplaintsPage> createState() => _AllNearbyComplaintsPageState();
}

class _AllNearbyComplaintsPageState extends State<AllNearbyComplaintsPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch the event to fetch all nearby complaints when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<ComplaintBloc>(context).add(GetAllNearbyComplaintsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الشكاوى القريبة', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color
        centerTitle: true,
      ),
      body: BlocConsumer<ComplaintBloc, ComplaintState>(
        listener: (context, state) {
          // Optional: Listen for error states to show a SnackBar or dialog
          if (state is ComplaintErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          // Show loading indicator
          if (state is LoadingAllNearbyComplaints) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }
          // Display the complaints when loaded
          else if (state is AllNearbyComplaintsLoaded) {
            if (state.complaints.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد شكاوى قريبة في الوقت الحالي.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ComplaintListView(complaints: state.complaints);
          }
          // Show error message
          else if (state is ComplaintErrorState) {
            return Center(
              child: Text(
                'خطأ في تحميل الشكاوى: ${state.message}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }
          // Initial or unexpected state
          return const Center(
            child: Text('اسحب لتحديث الشكاوى القريبة',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
          );
        },
      ),
    );
  }
}