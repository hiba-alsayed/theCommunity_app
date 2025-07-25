import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/app_color.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import 'package:graduation_project/features/profile/domain/entity/profile_entity.dart';
import 'package:graduation_project/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/campaigns/presentation/pages/get_my_campaign.dart';
import '../features/complaints/presentation/pages/my_complaint_page.dart';
import '../features/suggestions/presentation/pages/get_my_suggestions_page.dart';
import 'package:graduation_project/features/auth/presentation/bloc/auth_bloc.dart';

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
  late final ProfileBloc _profileBloc;
  late final AuthBloc _authBloc;
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
    _profileBloc = GetIt.instance<ProfileBloc>();
    _authBloc = GetIt.instance<AuthBloc>();
    _profileBloc.add(GetMyProfileEvent());
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
    _profileBloc.add(GetMyProfileEvent());
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

  void _submitProfileUpdate(ProfileEntity currentProfile) async {
    if (_formKey.currentState!.validate()) {
      String deviceToken = "some_device_token_placeholder";
      _profileBloc.add(
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
          skills: _selectedSkills,
        ),
      );
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الخروج'),
          content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _authBloc.add(const PerformLogout());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: _profileBloc,
        ),
        BlocProvider.value(
          value: _authBloc,
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, authState) {
          if (authState is LogoutLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logging out...')),
            );
          } else if (authState is LogoutSuccess) {
            ScaffoldMessenger.of(context)
                .hideCurrentSnackBar(); // Hide any loading snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logged out successfully!')),
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
            );
          } else if (authState is LogoutFailure) {
            ScaffoldMessenger.of(context)
                .hideCurrentSnackBar(); // Hide any loading snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(authState.message)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('ملفي الشخصي',style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
            ),),
            elevation: 0,
            centerTitle: true,
            leading: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return IconButton(
                  icon: authState is LogoutLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.WhisperWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.CedarOlive.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.logout,)),
                  onPressed: authState is LogoutLoading ? null : _confirmLogout,
                  tooltip: 'Logout',
                );
              },
            ),
            actions: [
              BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (previous, current) =>
                current is ProfileLoaded ||
                    current is UpdateProfileLoading ||
                    current is UpdateProfileSuccess ||
                    current is UpdateProfileError,
                builder: (context, state) {
                  if (state is ProfileLoaded) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.WhisperWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.CedarOlive.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(_isEditing ? Icons.save : Icons.edit),
                        onPressed: () {
                          if (_isEditing) {
                            _submitProfileUpdate(state.profile);
                          } else {
                            _toggleEditMode(state.profile);
                          }
                        },
                        tooltip: _isEditing ? 'Save Profile' : 'Edit Profile',
                      ),
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
                } else if (state is UpdateProfileSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                  setState(() {
                    _isEditing = false;
                  });
                  _profileBloc.add(GetMyProfileEvent());
                } else if (state is UpdateProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is ProfileLoading || state is UpdateProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProfileLoaded) {
                  if (!_isEditing) {
                    _populateControllers(state.profile);
                  }
                  return _buildProfileContent(context, state.profile);
                } else if (state is ProfileError) {
                  return Center(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 60),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.red),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              _profileBloc.add(GetMyProfileEvent());
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(child: LoadingWidget());
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileEntity profile) {
    return Form(
      key: _formKey,
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
                _buildInfoRow(Icons.email, profile.email, isEditable: false),
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
            _buildSectionCard(
              context,
              title: 'عني',
              children: [
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
                    if (int.tryParse(value) == null ||
                        int.parse(value) <= 0) {
                      return 'الرجاء إدخال عمر صالح.';
                    }
                    return null;
                  },
                )
                    : _buildInfoRow(Icons.cake, 'العمر: ${profile.age}'),
                _isEditing
                    ? _buildGenderDropdown()
                    : _buildInfoRow(Icons.person, 'الجنس: ${profile.gender}'),
                const SizedBox(height: 12),
                _isEditing
                    ? _buildEditableTextField(
                  controller: _bioController,
                  label: 'السيرة الذاتية',
                  icon: Icons.text_fields,
                  maxLines: 3,
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
            _buildSectionCard(
              context,
              title: 'مجالات الاهتمام',
              children: [
                _isEditing
                    ? _buildMultiSelectDropdown(
                  label: 'مجالات الاهتمام',
                  icon: Icons.category,
                  options: volunteerFieldNameId.keys.toList(),
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

            if (!_isEditing)
              _buildSectionCard(
                context,
                title: 'أنشطتي',
                children: [
                  _buildNavigationTile(
                    context,
                    title: 'شكاويي',
                    icon: Icons.report_problem_outlined,
                    iconColor: AppColors.RichBerry,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyComplaintsPage()),
                      );
                    },
                  ),
                  _buildNavigationTile(
                    context,
                    title: 'مبادراتي',
                    icon: Icons.lightbulb_outline,
                    iconColor: AppColors.OceanBlue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MySuggestionsPage()),
                      );
                    },
                  ),
                  _buildNavigationTile(
                    context,
                    title: 'حملاتي',
                    icon: Icons.campaign_outlined,
                    iconColor: AppColors.SunsetOrange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyCampaignsPage()),
                      );
                    },
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Text(
              'تاريخ إنشاء الملف: ${profile.createdAt.toLocal().toIso8601String().split('T')[0]}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24), // Added space at the bottom for consistency
          ],
        ),
      ),
    );
  }

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
            fillColor: _isEditing ? Colors.grey[100] : Colors.grey[50],
            enabled: _isEditing,
            errorText: validator?.call(selectedItems),
          ),
          child: selectedItems.isEmpty
              ? Text(
            hintText ?? 'Select items',
            style: TextStyle(
                color: _isEditing
                    ? Theme.of(context).hintColor
                    : Colors.grey[600]),
          )
              : Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: selectedItems
                .map((item) => Chip(
              label: Text(item),
              onDeleted: _isEditing
                  ? () {
                setState(() {
                  selectedItems.remove(item);
                  onChanged(selectedItems);
                });
              }
                  : null,
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.1),
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              side: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.3)),
            ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileEntity profile) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: profile.imageUrl.isEmpty
              ? Colors.grey.shade300
              : Theme.of(context).primaryColor.withOpacity(0.1),
          child: profile.imageUrl.isEmpty
              ? Icon(
            Icons.person,
            size: 70,
            color: Colors.grey.shade600,
          )
              : (profile.imageUrl.startsWith('http')
              ? ClipOval(
            child: Image.network(
              profile.imageUrl,
              fit: BoxFit.cover,
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.person,
                size: 70,
                color: Colors.grey.shade600,
              ),
            ),
          )
              : Icon(Icons.person, size: 70, color: Colors.grey.shade600)),
        ),
        const SizedBox(height: 16),
        Text(
          profile.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          profile.email,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

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
                color: AppColors.OliveGrove,
              ),
            ),
            const Divider(
              height: 24,
              thickness: 1,
              color: Colors.black12,
            ),
            ...children,
          ],
        ),
      ),
    );
  }

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
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChips(List<String> items) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: items
          .map((item) => Chip(
        label: Text(item),
        backgroundColor:
        Theme.of(context).colorScheme.primary.withOpacity(0.1),
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.OliveMid,
          fontWeight: FontWeight.bold,
        ),
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ))
          .toList(),
    );
  }

  Widget _buildNavigationTile(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color iconColor,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 24, color: iconColor),
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