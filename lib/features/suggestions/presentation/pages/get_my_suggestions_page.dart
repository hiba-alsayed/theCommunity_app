import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/suggestions/presentation/pages/suggestion_details_page.dart';
import '../../../../core/widgets/gradiant_app_bar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/Suggestions.dart';
import '../bloc/suggestion_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        titleContent:
        // Icon(Icons.menu, color: Colors.white, size: 28),
        // SizedBox(width: 10),
        Text(
          "مقترحاتي",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<SuggestionBloc, SuggestionState>(
        listener: (context, state) {
          if (state is VoteOnSuggestionSuccess ||
              state is SuggestionSubmittedSuccessState ||
              state is VoteOnSuggestionFailure ||
              state is SuggestionSubmittedErrorState ||
              state is DeleteMySuggestionSuccess ||
              state is DeleteMySuggestionFailure) {
            context.read<SuggestionBloc>().add(GetMySuggestionsEvent());
          }
        },
        child: BlocBuilder<SuggestionBloc, SuggestionState>(
          builder: (context, state) {
            if (state is GetMySuggestionsLoading) {
              return const Center(child: LoadingWidget());
            } else if (state is GetMySuggestionsLoaded) {
              if (state.suggestions.isEmpty) {
                return const Center(
                  child: Text(
                    'لا يوجد لديك مقترحات.',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                );
              }
              return SuggestionsListWidget(
                suggestion: state.suggestions,
                isMySuggestionsPage: true,
              );
            } else if (state is GetMySuggestionsError) {
              return Center(
                child: Text(
                  'حدث خطأ أثناء تحميل المقترحات: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
