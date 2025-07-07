import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/profile/domain/entity/profile_entity.dart';
import 'package:graduation_project/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';
import '../features/campaigns/presentation/pages/get_my_campaign.dart';
import '../features/complaints/presentation/pages/my_complaint_page.dart';
import '../features/suggestions/presentation/pages/get_my_suggestions_page.dart';



// These maps are only needed in the UI to get the list of available options
// and to display the names. They are NOT used for ID conversion in the UI anymore.
const Map<String, int> skillNameToId = {
  'تمريض': 1,
  'طبخ': 2,
  'جمع تبرعات': 3,
  'تصوير': 4,
  'مهنية': 5,
};

const Map<String, int> volunteerFieldNameId = {
  'ترميم بيوت': 1,
  'توزيع مساعدات': 2,
  'تنظيم فعالية': 3,
  'إغاثة الكوارث': 4,
  'مساعدات الطريق': 5,
  'تنظيف البيئة': 6,
};


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileBloc _bloc;
  bool _isEditing = false;
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  List<String> _selectedSkills = [];
  List<String> _selectedVolunteerFields = [];
  String? _selectedGender;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.instance<ProfileBloc>();
    _bloc.add(GetMyProfileEvent());
  }

  @override
  void dispose() {
    _bioController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void _populateControllers(ProfileEntity profile) {
    _bioController.text = profile.bio;
    _phoneController.text = profile.phone;
    _ageController.text = profile.age.toString();
    _selectedGender = profile.gender.isEmpty ? null : profile.gender;
    _areaController.text = profile.location.name;
    _selectedSkills = List.from(profile.skills);
    _selectedVolunteerFields = List.from(profile.fields);
  }
  Future<void> _onRefresh() async {
    _bloc.add(GetMyProfileEvent());
    await Future.delayed(const Duration(milliseconds: 500));
    if (_isEditing) {
      setState(() {
        _isEditing = false;
      });
    }
  }
  void _toggleEditMode(ProfileEntity? profile) {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing && profile != null) {
        _populateControllers(profile);
      }
    });
  }

  /// Submits the updated profile data to the BLoC.
  void _submitProfileUpdate(ProfileEntity currentProfile) async {
    // Validate form fields
    if (_formKey.currentState!.validate()) {
      String deviceToken = "some_device_token_placeholder";
      _bloc.add(
        UpdateClientProfileEvent(
          age: int.tryParse(_ageController.text) ?? 0,
          phone: _phoneController.text,
          gender: _selectedGender ?? '',
          bio: _bioController.text,
          deviceToken: deviceToken,
          volunteerFields: _selectedVolunteerFields,
          longitude: currentProfile.location.longitude,
          latitude: currentProfile.location.latitude,
          area: _areaController.text,
          skills: _selectedSkills, // Pass List<String>
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ملفي الشخصي'),
          elevation: 0,
          centerTitle: true,
          actions: [
            BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (previous, current) =>
              current is ProfileLoaded ||
                  current is UpdateProfileLoading ||
                  current is UpdateProfileSuccess ||
                  current is UpdateProfileError,
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return IconButton(
                    icon: Icon(_isEditing ? Icons.save : Icons.edit),
                    onPressed: () {
                      if (_isEditing) {
                        _submitProfileUpdate(state.profile);
                      } else {
                        _toggleEditMode(state.profile);
                      }
                    },
                  );
                } else if (state is UpdateProfileLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
              else if (state is UpdateProfileSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                setState(() {
                  _isEditing = false;
                });
                _bloc.add(GetMyProfileEvent());
              }
              // Handle profile update error
              else if (state is UpdateProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading || state is UpdateProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              else if (state is ProfileLoaded) {
                if (!_isEditing) {
                  _populateControllers(state.profile);
                }
                return _buildProfileContent(context, state.profile);
              }
              else if (state is ProfileError) {
                return Center(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 60),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              _bloc.add(GetMyProfileEvent());
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    ));
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  /// Builds the main content of the profile page, switching between view and edit modes.
  Widget _buildProfileContent(BuildContext context, ProfileEntity profile) {
    return Form(
      key: _formKey, // Attach form key for validation
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileHeader(profile),
            const SizedBox(height: 24),
            _buildSectionCard(
              context,
              title: 'معلومات الاتصال',
              children: [
                _buildInfoRow(Icons.email, profile.email, isEditable: false), // Email is not editable
                _isEditing
                    ? _buildEditableTextField(
                  controller: _phoneController,
                  label: 'رقم الهاتف',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لا يمكن أن يكون رقم الهاتف فارغًا.';
                    }
                    return null;
                  },
                )
                    : _buildInfoRow(Icons.phone, profile.phone),
                // Area row
                _isEditing
                    ? _buildEditableTextField(
                  controller: _areaController,
                  label: 'المنطقة',
                  icon: Icons.location_on,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لا يمكن أن تكون المنطقة فارغة.';
                    }
                    return null;
                  },
                )
                    : _buildInfoRow(Icons.location_on, profile.location.name),
              ],
            ),
            const SizedBox(height: 16),
            // About Me section
            _buildSectionCard(
              context,
              title: 'عني',
              children: [
                // Age row
                _isEditing
                    ? _buildEditableTextField(
                  controller: _ageController,
                  label: 'العمر',
                  icon: Icons.cake,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لا يمكن أن يكون العمر فارغًا.';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'الرجاء إدخال عمر صالح.';
                    }
                    return null;
                  },
                )
                    : _buildInfoRow(Icons.cake, 'العمر: ${profile.age}'),
                // Gender dropdown
                _isEditing
                    ? _buildGenderDropdown()
                    : _buildInfoRow(Icons.person, 'الجنس: ${profile.gender}'),
                const SizedBox(height: 12),
                // Bio field
                _isEditing
                    ? _buildEditableTextField(
                  controller: _bioController,
                  label: 'السيرة الذاتية',
                  icon: Icons.text_fields,
                  maxLines: 3, // Allow multiple lines for bio
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لا يمكن أن تكون السيرة الذاتية فارغة.';
                    }
                    return null;
                  },
                )
                    : Text(
                  profile.bio,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Skills section
            _buildSectionCard(
              context,
              title: 'المهارات',
              children: [
                _isEditing
                    ? _buildMultiSelectDropdown(
                  label: 'المهارات',
                  icon: Icons.lightbulb_outline,
                  options: skillNameToId.keys.toList(),
                  selectedItems: _selectedSkills,
                  onChanged: (List<String> newSelected) {
                    setState(() {
                      _selectedSkills = newSelected;
                    });
                  },
                  hintText: 'اختر مهاراتك',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء اختيار مهارة واحدة على الأقل.';
                    }
                    return null;
                  },
                )
                    : (profile.skills.isNotEmpty
                    ? _buildChips(profile.skills)
                    : const Text('لم يتم إدراج مهارات بعد.')),
              ],
            ),
            const SizedBox(height: 16),
            // Fields of Interest section
            _buildSectionCard(
              context,
              title: 'مجالات الاهتمام',
              children: [
                _isEditing
                    ? _buildMultiSelectDropdown(
                  label: 'مجالات الاهتمام',
                  icon: Icons.category,
                  options: volunteerFieldNameId.keys.toList(), // Use the globally defined map
                  selectedItems: _selectedVolunteerFields,
                  onChanged: (List<String> newSelected) {
                    setState(() {
                      _selectedVolunteerFields = newSelected;
                    });
                  },
                  hintText: 'اختر مجالات اهتمامك',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء اختيار مجال اهتمام واحد على الأقل.';
                    }
                    return null;
                  },
                )
                    : (profile.fields.isNotEmpty
                    ? _buildChips(profile.fields)
                    : const Text('لم يتم إدراج مجالات اهتمام بعد.')),
              ],
            ),
            const SizedBox(height: 16),
            // New Navigation Section
            if (!_isEditing) // Only show navigation links in view mode
              _buildSectionCard(
                context,
                title: 'أنشطتي',
                children: [
                  _buildNavigationTile(
                    context,
                    title: 'شكواي',
                    icon: Icons.report_problem_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyComplaintsPage()),
                      );
                    },
                  ),
                  _buildNavigationTile(
                    context,
                    title: 'اقتراحاتي',
                    icon: Icons.lightbulb_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MySuggestionsPage()),
                      );
                    },
                  ),
                  _buildNavigationTile(
                    context,
                    title: 'حملاتي',
                    icon: Icons.campaign_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyCampaignsPage()),
                      );
                    },
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Text(
              'تاريخ إنشاء الملف: ${profile.createdAt.toLocal().toIso8601String().split('T')[0]}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget to build editable TextFormFields.
  Widget _buildEditableTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: validator,
      ),
    );
  }

  /// Helper widget to build the Gender Dropdown.
  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender == '' ? null : _selectedGender,
        decoration: InputDecoration(
          labelText: 'Gender',
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        items: const [
          DropdownMenuItem(value: 'male', child: Text('ذكر')),
          DropdownMenuItem(value: 'female', child: Text('أنثى')),
        ],
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select your gender.';
          }
          return null;
        },
      ),
    );
  }
  Widget _buildMultiSelectDropdown({
    required String label,
    required IconData icon,
    required List<String> options,
    required List<String> selectedItems,
    required ValueChanged<List<String>> onChanged,
    String? hintText,
    String? Function(List<String>?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          if (!_isEditing) return;

          final List<String>? results = await showDialog<List<String>>(
            context: context,
            builder: (BuildContext context) {
              return MultiSelectDialog(
                title: label,
                options: options,
                selectedItems: selectedItems,
              );
            },
          );

          if (results != null) {
            onChanged(results);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: _isEditing ? Colors.grey[100] : Colors.grey[50], // Slightly different background if not editable
            enabled: _isEditing, // Disable input if not editing
            errorText: validator?.call(selectedItems), // Use validator here
          ),
          child: selectedItems.isEmpty
              ? Text(
            hintText ?? 'Select items',
            style: TextStyle(color: _isEditing ? Theme.of(context).hintColor : Colors.grey[600]),
          )
              : Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: selectedItems
                .map((item) => Chip(
              label: Text(item),
              onDeleted: _isEditing // Only allow deletion in edit mode
                  ? () {
                setState(() {
                  selectedItems.remove(item);
                  onChanged(selectedItems); // Update the state
                });
              }
                  : null, // No delete button if not editing
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
            ))
                .toList(),
          ),
        ),
      ),
    );
  }

  /// Helper widget to build the profile header (display-only).
  Widget _buildProfileHeader(ProfileEntity profile) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: profile.imageUrl.isEmpty ? Colors.grey.shade300 : Theme.of(context).primaryColor.withOpacity(0.1),
          child: profile.imageUrl.isEmpty
              ? Icon(
            Icons.person,
            size: 70,
            color: Colors.grey.shade600,
          )
              : (profile.imageUrl.startsWith('http') // Check if imageUrl is a valid URL
              ? ClipOval(
            child: Image.network(
              profile.imageUrl,
              fit: BoxFit.cover,
              width: 120, // Match radius * 2
              height: 120, // Match radius * 2
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.person,
                size: 70,
                color: Colors.grey.shade600,
              ),
            ),
          )
              : Icon(Icons.person, size: 70, color: Colors.grey.shade600)), // Fallback for invalid/empty URL
        ),
        const SizedBox(height: 16),
        Text(
          profile.name, // Name is not editable via the API
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          profile.email, // Email is not editable via the API
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  /// Helper widget to build a section card with a title and children widgets.
  Widget _buildSectionCard(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const Divider(height: 24, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  /// Helper widget to build a display-only information row.
  Widget _buildInfoRow(IconData icon, String text, {bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis, // Prevents text overflow
            ),
          ),
        ],
      ),
    );
  }

  /// Helper widget to build skill/interest chips.
  Widget _buildChips(List<String> items) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: items
          .map((item) => Chip(
        label: Text(item),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
      ))
          .toList(),
    );
  }

  /// New helper widget to build navigation tiles.
  Widget _buildNavigationTile(BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1, // Slightly less elevation for individual tiles within the card
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}

// MultiSelectDialog widget (remains the same)
class MultiSelectDialog extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> selectedItems;

  const MultiSelectDialog({
    super.key,
    required this.title,
    required this.options,
    required this.selectedItems,
  });

  @override
  State<MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _tempSelectedItems;

  @override
  void initState() {
    super.initState();
    _tempSelectedItems = List.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.options.map((option) {
            return CheckboxListTile(
              value: _tempSelectedItems.contains(option),
              title: Text(option),
              onChanged: (bool? isChecked) {
                setState(() {
                  if (isChecked != null && isChecked) {
                    _tempSelectedItems.add(option);
                  } else {
                    _tempSelectedItems.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _tempSelectedItems);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}