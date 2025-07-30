import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import 'package:graduation_project/features/complaints/presentation/bloc/complaint_bloc.dart';
import '../../../../core/app_color.dart';
import '../../../../navigation/main_navigation_page.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.RichBerry, Colors.white],
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
                                  color: AppColors.RichBerry.withOpacity(0.5),
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
                          'شكاويي',
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
                    child: BlocBuilder<ComplaintBloc, ComplaintState>(
                      builder: (context, state) {
                        if (state is LoadingMyComplaints) {
                          return const Center(
                            child: LoadingWidget(),
                          );
                        }
                        else if (state is MyComplaintsLoaded) {
                          if (state.complaints.isEmpty) {
                            return const Center(
                              child: Text(
                                'لا يوجد لديك شكاوى حالياً',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return ComplaintListView(
                            complaints: state.complaints,
                          );
                        }
                        else if (state is ComplaintErrorState) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'حدث خطأ أثناء تحميل الشكاوي: ${state.message}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return const Center(
                          child: LoadingWidget(),
                        );
                      },
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
