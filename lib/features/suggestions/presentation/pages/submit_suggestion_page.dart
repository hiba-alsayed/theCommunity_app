import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/widgets/glowing_gps.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/suggestion_bloc.dart';
import '../../../../core pages/location_picker_page.dart';

class SubmitSuggestionPage extends StatefulWidget {
  @override
  _SubmitSuggestionPageState createState() => _SubmitSuggestionPageState();
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});
}

class _SubmitSuggestionPageState extends State<SubmitSuggestionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _requiredAmountController =
      TextEditingController();
  // DateTime? _selectedDate;
  File? _imageFile;
  Category? _selectedCategory;
  LatLng? _selectedLocation;

  final List<Category> _categories = [
    Category(id: 1, name: 'إنارة الشوارع بالطاقة الشمسية'),
    Category(id: 2, name: 'تنظيف وتزيين الأماكن العامة'),
    Category(id: 3, name: 'يوم خيري'),
    Category(id: 4, name: 'حملات تشجير'),
    Category(id: 5, name: 'ترميم أضرار'),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _participantsController.dispose();
    _requiredAmountController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _imageFile = imageFile;
      });
      print('Image selected: ${imageFile.path}');
    } else {
      print('No image selected');
    }
  }
  void _submitSuggestion() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('الرجاء اختيار الفئة')));
        return;
      }


      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('الرجاء اختيار الموقع من الخريطة')),
        );
        return;
      }

      if (_imageFile == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('الرجاء إضافة صورة للمقترح')));
        return;
      }

      context.read<SuggestionBloc>().add(
        SubmitSuggestionEvent(
          title: _titleController.text,
          description: _descriptionController.text,
          requiredAmount: _requiredAmountController.text,
          area: _locationController.text,
          longitude: _selectedLocation!.longitude,
          latitude: _selectedLocation!.latitude,
          categoryId: _selectedCategory!.id,
          numberOfParticipants: _participantsController.text,
          imageUrl: _imageFile!.path,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BlocConsumer<SuggestionBloc, SuggestionState>(
          listener: (context, state) {
            if (state is SuggestionSubmittedErrorState) {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("حدث خطأ"),
                      content: Text(state.error),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            "حسناً",
                            style: TextStyle(color: Color(0xFF0172B2)),
                          ),
                        ),
                      ],
                    ),
              );
            } else if (state is SuggestionSubmittedSuccessState) {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("تم الإرسال بنجاح", style: TextStyle()),
                      content: Text(state.message),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "تم",
                            style: TextStyle(color: Color(0xFF0172B2)),
                          ),
                        ),
                      ],
                    ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                        gradient: LinearGradient(
                          colors: [Color(0xFF03045e), Color(0xFF0096c7)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                    ),
                    Expanded(child: Container(color: Colors.white)),
                  ],
                ),

                // App Bar
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'تقديم مقترح جديد',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // -----------Form-----------
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: 100,
                    left: 16,
                    right: 16,
                    bottom: 32,
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'شاركنا فكرتك وكن جزءًا من التغيير',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0172B2),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'املأ النموذج التالي لتقديم مقترحك',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Divider(
                              height: 24,
                              thickness: 1,
                              color: Colors.grey.shade300,
                            ),
                            _buildFormField(
                              controller: _titleController,
                              label: 'عنوان المقترح',
                              icon: Icons.title,
                              validator:
                                  (value) =>
                                      value?.isEmpty ?? true
                                          ? 'هذا الحقل مطلوب'
                                          : null,
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'يجب اختيار الموقع من الخريطة',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF848484),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _locationController,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF848484),
                                        ),
                                        decoration: const InputDecoration(
                                          labelText: 'اسم المنطقة (اختياري)',
                                          labelStyle: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF848484),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.gps_fixed,
                                            color: Color(0xFF0172B2),
                                          ),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF0172B2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    LocationPickerPage(),
                                          ),
                                        );
                                        if (result != null) {
                                          setState(() {
                                            _selectedLocation =
                                                result['location'];
                                          });
                                        }
                                      },
                                      child: Text(
                                        'اختر من الخريطة',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            DropdownButtonFormField<Category>(
                                  decoration: InputDecoration(
                                    labelText: 'الفئة',
                                    labelStyle: TextStyle(
                                      // Label style
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF848484),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.category,
                                      color: Color(0xFF0172B2),
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      _categories.map((Category category) {
                                        return DropdownMenuItem<Category>(
                                          value: category,
                                          child: Text(category.name),
                                        );
                                      }).toList(),
                                  onChanged: (Category? value) {
                                    setState(() {
                                      _selectedCategory = value;
                                    });
                                  },
                                  validator:
                                      (value) =>
                                          value == null
                                              ? 'الرجاء اختيار الفئة'
                                              : null,
                                )
                                .animate()
                                .fade(duration: 350.ms)
                                .slideY(begin: 0.2, curve: Curves.easeOut),
                            SizedBox(height: 16),
                            _buildFormField(
                              controller: _requiredAmountController,
                              label: 'المبلغ المطلوب',
                              icon: Icons.attach_money,
                              keyboardType: TextInputType.number,
                              validator:
                                  (value) =>
                                      value?.isEmpty ?? true
                                          ? 'هذا الحقل مطلوب'
                                          : null,
                            ),
                            SizedBox(height: 16),
                            GestureDetector(
                              onTap: _pickImage,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: 100,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child:
                                    _imageFile != null
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.file(
                                            _imageFile!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        )
                                        : Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.camera_alt,
                                                size: 28,
                                                color: Color(0xFF0172B2),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'اضغط لإضافة صورة',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xFF848484),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'الوصف',
                                labelStyle: TextStyle(
                                  // Label style
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF848484),
                                ),
                                prefixIcon: Icon(
                                  Icons.description,
                                  color: Color(0xFF0172B2),
                                ),
                                border: OutlineInputBorder(),
                              ),
                              validator:
                                  (value) =>
                                      value?.isEmpty ?? true
                                          ? 'هذا الحقل مطلوب'
                                          : null,
                            ),
                            SizedBox(height: 16),
                            _buildFormField(
                              controller: _participantsController,
                              label: 'عدد المشاركين المتوقع',
                              icon: Icons.people,
                              keyboardType: TextInputType.number,
                              validator:
                                  (value) =>
                                      value?.isEmpty ?? true
                                          ? 'هذا الحقل مطلوب'
                                          : null,
                            ),
                            SizedBox(height: 24),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0172B2),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed:
                                    state is SubmittingSuggestionState
                                        ? null
                                        : _submitSuggestion,
                                child:
                                    state is SubmittingSuggestionState
                                        ? LoadingWidget()
                                        : Text(
                                          'تقديم المقترح',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: Color(0xFF848484),
        ),
        prefixIcon: Icon(icon, color: Color(0xFF0172B2)),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
