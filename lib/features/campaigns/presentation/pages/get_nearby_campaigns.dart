import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/gradiant_app_bar.dart';
import '../../../suggestions/presentation/pages/submit_suggestion_page.dart';
import '../bloc/campaign_bloc.dart';
import '../widgets/campaign_list_widget.dart';

class GetNearbyCampaignsPage extends StatefulWidget {
  const GetNearbyCampaignsPage({Key? key}) : super(key: key);

  @override
  State<GetNearbyCampaignsPage> createState() => _GetNearbyCampaignsPageState();
}

class _GetNearbyCampaignsPageState extends State<GetNearbyCampaignsPage> {
  bool _hasInteractedWithSlider = false;
  double _selectedDistance = 2.0;
  int? _selectedCategoryId;
  List<Category> _categories = [];
  bool _loadingCategories = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() async {
    final bloc = context.read<CampaignBloc>();
    bloc.add(GetCategoriesEvent());
  }

  void _onCategorySelected(int? id) {
    setState(() {
      _selectedCategoryId = id;
    });
  }

  void _openCategorySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocBuilder<CampaignBloc, CampaignState>(
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
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'اختر تصنيف',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.all_inclusive, color: Colors.blue),
                      title: const Text('الكل'),
                      onTap: () {
                        _onCategorySelected(null);
                        Navigator.pop(context);
                      },
                    ),
                    ...categories.map((category) {
                      return ListTile(
                        leading: Icon(Icons.category, color: Colors.grey),
                        title: Text(category.name),
                        onTap: () {
                          _onCategorySelected(category.id);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ],
                ),
              );
            } else if (state is CampaignErrorState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'حدث خطأ: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  void _searchNearbyCampaigns() {
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار تصنيف')),
      );
      return;
    }
    context.read<CampaignBloc>().add(
      GetNearbyCampaignsEvent(
        categoryId: _selectedCategoryId!,
        distance: _selectedDistance,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        titleContent: Text(
          "الحملات القريبة",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Category selector button that opens bottom sheet
            ElevatedButton.icon(
              onPressed: _openCategorySelector,  // Always active
              icon: Icon(Icons.category),
              label: Text(_selectedCategoryId == null ? 'اختر التصنيف' : 'تم اختيار تصنيف'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0172B2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                elevation: 3,
              ),
            ),

            const SizedBox(height: 16),

            // Distance slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اختر المسافة (كم): ${_selectedDistance.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF848484),
                  ),
                ),
                Listener(
                  onPointerDown: (_) {
                    setState(() {
                      _hasInteractedWithSlider = true;
                    });
                  },
                  child: Slider(
                    value: _selectedDistance,
                    min: 1.0,
                    max: 20.0,
                    divisions: 19,
                    label: '${_selectedDistance.toStringAsFixed(1)} كم',
                    activeColor: _hasInteractedWithSlider ? Color(0xFF0172B2) : Colors.grey,
                    onChanged: (value) {
                      setState(() {
                        _selectedDistance = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Search button
            ElevatedButton.icon(
              onPressed: _selectedCategoryId != null ? _searchNearbyCampaigns : null,
              icon: Icon(Icons.search, color: Colors.white),
              label: Text(
                'عرض الحملات',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0172B2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                elevation: 3,
              ),
            ),

            const SizedBox(height: 24),

            // Result list using BlocBuilder
            Expanded(
              child: BlocBuilder<CampaignBloc, CampaignState>(
                builder: (context, state) {
                  if (state is LoadingNearbyCampaigns) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is NearbyCampaignsLoaded) {
                    if (state.nearbyCampaigns.isEmpty) {
                      return Center(child: Text('لا توجد حملات قريبة'));
                    }
                    // Replace with your widget to show campaigns list
                    return CampaignListWidget(campaigns: state.nearbyCampaigns);
                  } else if (state is NearbyCampaignsError) {
                    return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
                  }
                  return Center(child: Text('اختر تصنيفًا ومسافة لعرض النتائج'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
