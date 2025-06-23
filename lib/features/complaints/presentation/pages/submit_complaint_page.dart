import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graduation_project/features/complaints/domain/entites/complaint_category_entity.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../suggestions/presentation/pages/location_picker_page.dart';
import '../../domain/entites/regions_entity.dart';
import '../bloc/complaint_bloc.dart';


class SubmitComplaintPage extends StatefulWidget {
  const SubmitComplaintPage({super.key});

  @override
  _SubmitComplaintPageState createState() => _SubmitComplaintPageState();
}

class _SubmitComplaintPageState extends State<SubmitComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<File> _complaintImages = [];
  ComplaintCategory? _selectedCategory;
  RegionEntity? _selectedRegion;
  LatLng? _selectedLocation;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage(
      imageQuality: 80,
    );
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _complaintImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _complaintImages.removeAt(index);
    });
  }

  // --- MODIFICATION 1: Correctly handle the returned result ---
  void _navigateAndPickLocation() async {
    // Navigate and wait for a result.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerPage()),
    );

    // Check if the result is a Map and contains the 'location' key.
    if (result != null && result is Map && result.containsKey('location')) {
      setState(() {
        // Extract the LatLng object from the Map.
        _selectedLocation = result['location'] as LatLng;
      });
    }
  }

  void _submitComplaint() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار تصنيف الشكوى')));
        return;
      }
      if (_selectedRegion == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار المنطقة')));
        return;
      }
      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار الموقع من الخريطة')));
        return;
      }
      if (_complaintImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إضافة صورة واحدة على الأقل للشكوى')));
        return;
      }

      context.read<ComplaintBloc>().add(
        SubmitComplaintEvent(
          title: _titleController.text,
          description: _descriptionController.text,
          area: _selectedRegion!.name,
          latitude: _selectedLocation!.latitude,
          longitude: _selectedLocation!.longitude,
          complaintCategoryId: _selectedCategory!.categoryId,
          complaintImages: _complaintImages,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تقديم شكوى جديدة'),
          centerTitle: true,
        ),
        body: BlocConsumer<ComplaintBloc, ComplaintState>(
          listener: (context, state) {
            if (state is ComplaintErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('خطأ: ${state.message}'), backgroundColor: Colors.red),
              );
            } else if (state is ComplaintSubmittedSuccessfully) {
              showDialog(
                context: context,
                barrierDismissible: false, // Prevent dismissing by tapping outside
                builder: (dialogContext) => AlertDialog(
                  title: const Text("تم إرسال الشكوى بنجاح"),
                  content: const Text("شكراً لك، سيتم مراجعة الشكوى من قبل الجهات المختصة."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // --- CHANGE IS HERE ---
                        // First, pop the dialog
                        Navigator.of(dialogContext).pop();
                        // Then, pop the SubmitComplaintPage and return 'true' to signal success
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("حسناً"),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            //... (the rest of your builder code remains the same)
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField(
                      controller: _titleController,
                      label: 'عنوان الشكوى',
                      icon: Icons.title,
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<ComplaintBloc, ComplaintState>(
                      buildWhen: (previous, current) => current is CategoriesLoaded || current is LoadingCategories,
                      builder: (context, state) {
                        if (state is CategoriesLoaded) {
                          return _buildCategoryDropdown(state.categories);
                        }
                        return _buildLoadingDropdown('جاري تحميل التصنيفات...');
                      },
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<ComplaintBloc, ComplaintState>(
                      buildWhen: (previous, current) => current is RegionsLoaded || current is LoadingRegions,
                      builder: (context, state) {
                        if (state is RegionsLoaded) {
                          return _buildRegionDropdown(state.regions);
                        }
                        return _buildLoadingDropdown('جاري تحميل المناطق...');
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildLocationPicker(),
                    const SizedBox(height: 16),
                    _buildFormField(
                      controller: _descriptionController,
                      label: 'وصف الشكوى',
                      icon: Icons.description,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    const Text('صور الشكوى', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildImagePicker(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: state is SubmittingComplaint ? null : _submitComplaint,
                        icon: const Icon(Icons.send),
                        label: state is SubmittingComplaint
                            ? const LoadingWidget()
                            : const Text('تقديم الشكوى', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //... (all your helper widgets like _buildFormField, etc. remain the same)
  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
    );
  }

  Widget _buildCategoryDropdown(List<ComplaintCategory> categories) {
    return DropdownButtonFormField<ComplaintCategory>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'تصنيف الشكوى',
        prefixIcon: Icon(Icons.category),
        border: OutlineInputBorder(),
      ),
      items: categories.map((category) {
        return DropdownMenuItem<ComplaintCategory>(
          value: category,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      validator: (value) => value == null ? 'الرجاء اختيار التصنيف' : null,
    );
  }

  Widget _buildRegionDropdown(List<RegionEntity> regions) {
    return DropdownButtonFormField<RegionEntity>(
      value: _selectedRegion,
      decoration: const InputDecoration(
        labelText: 'المنطقة',
        prefixIcon: Icon(Icons.map_outlined),
        border: OutlineInputBorder(),
      ),
      items: regions.map((region) {
        return DropdownMenuItem<RegionEntity>(
          value: region,
          child: Text(region.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedRegion = value;
        });
      },
      validator: (value) => value == null ? 'الرجاء اختيار المنطقة' : null,
    );
  }

  // --- NEW HELPER FOR A BETTER LOADING UI ---
  Widget _buildLoadingDropdown(String label) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.hourglass_top),
          border: const OutlineInputBorder(),
          suffixIcon: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(strokeWidth: 2),
          )
      ),
    );
  }


  Widget _buildLocationPicker() {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _selectedLocation == null
                ? 'لم يتم تحديد الموقع على الخريطة'
                : 'تم تحديد الموقع بنجاح',
            style: TextStyle(
              color: _selectedLocation == null ? Colors.grey.shade600 : Colors.green.shade700,
            ),
          ),
        ),
        TextButton(
          onPressed: _navigateAndPickLocation,
          child: const Text('اختر من الخريطة'),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_complaintImages.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _complaintImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          _complaintImages[index],
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.add_a_photo),
          label: const Text('أضف صورة'),
        ),
      ],
    );
  }
}