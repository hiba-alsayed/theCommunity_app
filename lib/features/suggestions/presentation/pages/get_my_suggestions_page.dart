import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/suggestions/presentation/pages/suggestion_details_page.dart';
import '../../../../core/app_color.dart';
import '../../../../core/widgets/gradiant_app_bar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../navigation/main_navigation_page.dart';
import '../../domain/entities/Suggestions.dart';
import '../bloc/suggestion_bloc.dart';
import '../widgets/suggestions_list_shimmer_widget.dart';
import '../widgets/suggestions_list_widget.dart';

class MySuggestionsPage extends StatefulWidget {
  const MySuggestionsPage({super.key});

  @override
  State<MySuggestionsPage> createState() => _MySuggestionsPageState();
}

class _MySuggestionsPageState extends State<MySuggestionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SuggestionBloc>().add(GetMySuggestionsEvent());
  }

  Future<void> _refreshMySuggestions() async {
    context.read<SuggestionBloc>().add(GetMySuggestionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.MidGreen, Colors.white],
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
                                  color: AppColors.MidGreen.withOpacity(0.5),
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
                                    builder: (context) =>
                                    const MainNavigationPage(),
                                  ),
                                );
                              },
                              tooltip: 'العودة',
                            ),
                          ),
                        ),
                        const Text(
                          'مبادراتي',
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
                    child: BlocListener<SuggestionBloc, SuggestionState>(
                      listener: (context, state) {
                        if (state is VoteOnSuggestionSuccess ||
                            state is SuggestionSubmittedSuccessState ||
                            state is VoteOnSuggestionFailure ||
                            state is SuggestionSubmittedErrorState ||
                            state is DeleteMySuggestionSuccess ||
                            state is DeleteMySuggestionFailure) {
                          context.read<SuggestionBloc>().add(
                            GetMySuggestionsEvent(),
                          );
                        }
                      },
                      child: RefreshIndicator(
                        onRefresh: _refreshMySuggestions,
                        color: AppColors.MidGreen,
                        backgroundColor: AppColors.WhisperWhite,
                        child: BlocBuilder<SuggestionBloc, SuggestionState>(
                          builder: (context, state) {
                            if (state is GetMySuggestionsLoading) {
                              return ListView(
                                children: const [
                                  Center(child: SuggestionsShimmerList()),
                                ],
                              );
                            } else if (state is GetMySuggestionsLoaded) {
                              if (state.suggestions.isEmpty) {
                                return ListView(
                                  children: const [
                                    SizedBox(
                                      height: 700,
                                      child: Center(
                                        child: Text(
                                          'لا يوجد لديك مبادرات.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return SuggestionsListWidget(
                                suggestion: state.suggestions,
                                isMySuggestionsPage: true,
                              );
                            } else if (state is GetMySuggestionsError) {
                              return ListView(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: Center(
                                      child: Text(
                                        'حدث خطأ أثناء تحميل المقترحات: ${state.message}',
                                        style: const TextStyle(color: Colors.red),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
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
