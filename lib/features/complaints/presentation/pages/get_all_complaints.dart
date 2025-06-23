import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import 'package:graduation_project/features/complaints/presentation/pages/submit_complaint_page.dart';
import 'package:graduation_project/features/suggestions/presentation/pages/submit_suggestion_page.dart';
import '../../domain/entites/complaint.dart';
import '../bloc/complaint_bloc.dart';
import '../widgets/complaint_list_widget.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  String? _selectedCategoryName;

  @override
  void initState() {
    super.initState();
    context.read<ComplaintBloc>().add(GetAllComplaintsEvent());
  }

  // --- THE ONLY CHANGE IS IN THIS METHOD ---
  void _navigateToSubmitComplaint() async {
    final complaintBloc = context.read<ComplaintBloc>();
    complaintBloc.add(GetCategoriesEvent());
    complaintBloc.add(GetAllRegionsEvent());

    // Await the navigation to complete.
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SubmitComplaintPage()),
    );

    // ALWAYS refresh the primary list of this page when returning.
    // This handles both successful submissions and pressing the back button.
    context.read<ComplaintBloc>().add(GetAllComplaintsEvent());
  }
  void _openFilterDialog() {
    context.read<ComplaintBloc>().add(GetCategoriesEvent());
    showModalBottomSheet(
      context: context,
      builder: (bContext) {
        return BlocBuilder<ComplaintBloc, ComplaintState>(
          bloc: BlocProvider.of<ComplaintBloc>(context),
          builder: (context, state) {
            if (state is LoadingCategories) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is CategoriesLoaded) {
              final categories = state.categories;
              final Map<String, Map<String, dynamic>> categoryIcons = {
                'نظافة': {'icon': Icons.cleaning_services, 'color': Colors.lightBlue},
                'صيانة': {'icon': Icons.build, 'color': Colors.green},
                'انارة': {'icon': Icons.lightbulb, 'color': Colors.yellow.shade700},
                'كهرباء': {'icon': Icons.electrical_services, 'color': Colors.deepOrange},
                'صرف صحي': {'icon': Icons.water_damage, 'color': Colors.deepPurpleAccent},
                'مياه': {'icon': Icons.water, 'color': Colors.blue},
                'ارصفة و طرقات': {'icon': Icons.edit_road, 'color': Colors.black},
                'أخرى': {'icon': Icons.category, 'color': Colors.grey},
              };

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('اختر تصنيف', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.all_inclusive, color: Colors.blue),
                        title: const Text('الكل'),
                        onTap: () {
                          setState(() { _selectedCategoryName = null; });
                          context.read<ComplaintBloc>().add(GetAllComplaintsEvent());
                          Navigator.pop(bContext);
                        },
                      ),
                      ...categories.map((category) {
                        final iconData = categoryIcons[category.name] ?? {'icon': Icons.category, 'color': Colors.grey};
                        return ListTile(
                          leading: Icon(iconData['icon'], color: iconData['color']),
                          title: Text(category.name),
                          onTap: () {
                            setState(() { _selectedCategoryName = category.name; });
                            context.read<ComplaintBloc>().add(GetComplaintsByCategoryEvent(category.categoryId));
                            Navigator.pop(bContext);
                          },
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            } else if (state is ComplaintErrorState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('حدث خطأ: ${state.message}', style: const TextStyle(color: Colors.red)),
              );
            }
            return const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'تقديم شكوى',
        onPressed: _navigateToSubmitComplaint,
        child: const Icon(Icons.add_comment_outlined),
      ),
      body: SafeArea(
        child: BlocConsumer<ComplaintBloc, ComplaintState>(
          buildWhen: (previous, current) {
            if (current is LoadingCategories || current is CategoriesLoaded || current is LoadingRegions || current is RegionsLoaded) {
              return false;
            }
            return true;
          },
          listener: (context, state) {
            if (state is ComplaintErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('حدث خطأ: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            final complaints = (state is ComplaintsLoaded)
                ? state.complaints
                : (state is ComplaintsByCategoryLoaded)
                ? state.complaints
                : null;

            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: _selectedCategoryName != null ? 112.0 : 56.0),
                  child: _buildBody(state, complaints),
                ),
                Column(
                  children: [
                    AppBar(
                      automaticallyImplyLeading: false,
                      title: Text(_selectedCategoryName ?? 'جميع الشكاوى'),
                      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                      elevation: 0,
                      actions: [
                        IconButton(
                          onPressed: _openFilterDialog,
                          icon: const Icon(Icons.filter_list),
                          tooltip: 'فلترة الشكاوى',
                        ),
                      ],
                    ),
                    if (_selectedCategoryName != null)
                      Container(
                        color: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('التصنيف: $_selectedCategoryName', style: const TextStyle(fontSize: 14, color: Colors.black87)),
                            TextButton.icon(
                              onPressed: () {
                                setState(() { _selectedCategoryName = null; });
                                context.read<ComplaintBloc>().add(GetAllComplaintsEvent());
                              },
                              icon: const Icon(Icons.close, size: 18, color: Colors.red),
                              label: const Text('إزالة الفلتر', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(ComplaintState state, List<ComplaintEntity>? complaints) {
    if (state is LoadingComplaints || state is LoadingComplaintsByCategory) {
      return const Center(child: CircularProgressIndicator());
    }
    if (complaints != null) {
      if (complaints.isEmpty) {
        return const Center(child: Text('لا توجد شكاوى لعرضها'));
      }
      return ComplaintListView(complaints: complaints);
    }
    if (state is ComplaintErrorState) {
      return Center(child: Text('حدث خطأ: ${state.message}', style: const TextStyle(color: Colors.red)));
    }
    return const Center(child: CircularProgressIndicator());
  }
}