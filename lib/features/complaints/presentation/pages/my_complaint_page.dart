import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/complaints/presentation/bloc/complaint_bloc.dart';
import '../widgets/complaint_list_widget.dart';

class MyComplaintsPage extends StatefulWidget {
  const MyComplaintsPage({super.key});

  @override
  State<MyComplaintsPage> createState() => _MyComplaintsPageState();
}

class _MyComplaintsPageState extends State<MyComplaintsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ComplaintBloc>().add(GetMyComplaintsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<ComplaintBloc, ComplaintState>(
            builder: (context, state) {
              if (state is LoadingMyComplaints) {
                return const Center(child: CircularProgressIndicator());
              }
              else if (state is MyComplaintsLoaded) {
                if (state.complaints.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا يوجد لديك شكاوى حالياً',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
                return ComplaintListView(complaints: state.complaints);
              }
              else if (state is ComplaintErrorState) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'حدث خطأ: ${state.message}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: const Text('شكاويي'),
              backgroundColor: const Color(0xFF1E88E5),
              elevation: 1,
            ),
          ),
        ],
      ),
    );
  }
}