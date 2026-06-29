import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss_new/common_pages/custom_decorations.dart';
import 'package:nss_new/controller/volunteer_controller.dart';
import 'package:nss_new/controller/attendance_controller.dart';

class AddVolunteerScreen extends StatefulWidget {
  final Map<String, String>? volunteer;
  const AddVolunteerScreen({super.key, this.volunteer});

  @override
  State<AddVolunteerScreen> createState() => _AddVolunteerScreenState();
}

class _AddVolunteerScreenState extends State<AddVolunteerScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _admissionNoController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  String? _selectedProgram;
  String? _selectedYear;
  DateTime? _selectedDOB;
  String? _selectedCaste;
  String? _selectedGender;
  String? _selectedBloodGroup;

  final List<String> _programs = [
    'B.Voc Software Development',
    'B.Sc Computer Science',
    'B.Com Finance',
    'BCA',
    'B.A English',
    'B.Sc Mathematics',
    'B.Com Computer Applications',
    'B.Sc Physics',
  ];

  final List<String> _years = ['1st Year', '2nd Year', '3rd Year'];

  final List<String> _castes = [
    'General',
    'OBC',
    'Muslim',
    'SC',
    'ST',
    'Others',
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  @override
  void initState() {
    super.initState();
    final v = widget.volunteer;
    _nameController = TextEditingController(text: v?['name'] ?? '');
    _admissionNoController = TextEditingController(
      text: v?['admissionNo'] ?? '',
    );
    _emailController = TextEditingController(text: v?['email'] ?? '');
    _phoneController = TextEditingController(text: v?['phone'] ?? '');

    _selectedProgram = v?['program'];
    _selectedYear = v?['year'];

    if (v?['dob'] != null && v!['dob']!.isNotEmpty) {
      _selectedDOB = _parseDOB(v['dob']!);
    }

    _selectedCaste = v?['caste'];
    _selectedGender = v?['gender'];
    _selectedBloodGroup = v?['bloodGroup'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _admissionNoController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  DateTime? _parseDOB(String dobStr) {
    try {
      final months = [
        'january',
        'february',
        'march',
        'april',
        'may',
        'june',
        'july',
        'august',
        'september',
        'october',
        'november',
        'december',
      ];
      final parts = dobStr.split(' ');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final monthStr = parts[1].toLowerCase();
        final month = months.indexOf(monthStr) + 1;
        final year = int.parse(parts[2]);
        if (month > 0) {
          return DateTime(year, month, day);
        }
      }
    } catch (_) {
      return DateTime.tryParse(dobStr);
    }
    return null;
  }

  String _formatDOB(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final dayStr = date.day.toString().padLeft(2, '0');
    return "$dayStr ${months[date.month - 1]} ${date.year}";
  }

  Future<void> _selectDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDOB ?? DateTime(2005, 1, 1),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDOB) {
      setState(() {
        _selectedDOB = picked;
      });
    }
  }


  List<DropdownMenuItem<String>> _buildDropdownItems(
    List<String> baseList,
    String? currentValue,
  ) {
    final Set<String> itemsSet = Set.from(baseList);
    if (currentValue != null && currentValue.isNotEmpty) {
      itemsSet.add(currentValue);
    }
    return itemsSet
        .map((val) => DropdownMenuItem<String>(value: val, child: Text(val)))
        .toList();
  }

  void _saveVolunteer() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDOB == null) {
      Get.snackbar(
        "Required Field Missing",
        "Please select Date of Birth",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_selectedProgram == null ||
        _selectedYear == null ||
        _selectedCaste == null ||
        _selectedGender == null ||
        _selectedBloodGroup == null) {
      Get.snackbar(
        "Required Field Missing",
        "Please select all dropdown options",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final name = _nameController.text.trim();
    final admissionNo = _admissionNoController.text.trim().toUpperCase();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final dobStr = _formatDOB(_selectedDOB!);

    final volunteerController = Get.find<VolunteerController>();
    final attendanceController = Get.isRegistered<AttendanceController>()
        ? Get.find<AttendanceController>()
        : Get.put(AttendanceController());

    final isEditMode = widget.volunteer != null;

    if (isEditMode) {
      final originalAdmnNo = widget.volunteer!['admissionNo']!;

      // Update in VolunteerController
      final index = volunteerController.volunteerDetailsList.indexWhere(
        (v) => v['admissionNo'] == originalAdmnNo,
      );

      final updatedData = {
        'admissionNo': admissionNo,
        'name': name,
        'email': email,
        'phone': phone,
        'program': _selectedProgram!,
        'year': _selectedYear!,
        'dob': dobStr,
        'caste': _selectedCaste!,
        'gender': _selectedGender!,
        'bloodGroup': _selectedBloodGroup!,
      };

      if (index != -1) {
        volunteerController.volunteerDetailsList[index] = updatedData;
      } else {
        volunteerController.volunteerDetailsList.add(updatedData);
      }

      // Update in AttendanceController
      final attIndex = attendanceController.volunteerList.indexWhere(
        (v) => v['admissionNo'] == originalAdmnNo,
      );

      if (attIndex != -1) {
        final existingAtt = attendanceController.volunteerList[attIndex];
        attendanceController.volunteerList[attIndex] = {
          'admissionNo': admissionNo,
          'name': name,
          'program': _selectedProgram!,
          'attendedPrograms': existingAtt['attendedPrograms'] ?? [],
        };
      } else {
        attendanceController.volunteerList.add({
          'admissionNo': admissionNo,
          'name': name,
          'program': _selectedProgram!,
          'attendedPrograms': [],
        });
      }

      volunteerController.volunteerDetailsList.refresh();
      attendanceController.volunteerList.refresh();

      Get.snackbar(
        "Volunteer Updated",
        "Successfully updated details for $name.",
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.back();
    } else {
      // Add mode: Check duplicate
      final exists = volunteerController.volunteerDetailsList.any(
        (v) => v['admissionNo'] == admissionNo,
      );

      if (exists) {
        Get.snackbar(
          "Duplicate Admission Number",
          "A volunteer with admission number $admissionNo already exists.",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final newData = {
        'admissionNo': admissionNo,
        'name': name,
        'email': email,
        'phone': phone,
        'program': _selectedProgram!,
        'year': _selectedYear!,
        'dob': dobStr,
        'caste': _selectedCaste!,
        'gender': _selectedGender!,
        'bloodGroup': _selectedBloodGroup!,
      };

      volunteerController.volunteerDetailsList.add(newData);

      attendanceController.volunteerList.add({
        'admissionNo': admissionNo,
        'name': name,
        'program': _selectedProgram!,
        'attendedPrograms': [],
      });

      volunteerController.volunteerDetailsList.refresh();
      attendanceController.volunteerList.refresh();

      Get.snackbar(
        "Volunteer Added",
        "Successfully registered $name as a new NSS volunteer.",
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isEditMode = widget.volunteer != null;

    return SafeArea(
      child: Scaffold(
        backgroundColor: cs.surface,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back to Volunteer List Row
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: cs.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Back to volunteer list',
                                style: tt.bodyMedium?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Solid Form Card containing Header, Title, Fields, and Save/Cancel
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cs.onPrimary,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: cs.outline.withOpacity(0.4),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Subtitle
                          Text(
                            isEditMode ? 'Edit Volunteer' : 'Add Volunteer',
                            style: tt.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isEditMode
                                ? 'Update the service record of volunteer'
                                : 'Register a new NSS volunteer for the current academic session',
                            style: tt.bodyMedium?.copyWith(
                              color: cs.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Full Name
                          CustomWidgets().buildLabel(context, "Full Name"),
                          TextFormField(
                            controller: _nameController,
                            style: TextStyle(color: cs.onSurface),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "Enter full name",
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Please enter full name"
                                : null,
                          ),

                          // Admission Number
                         CustomWidgets().buildLabel(context, "Admission Number"),
                          TextFormField(
                            controller: _admissionNoController,
                            enabled: !isEditMode,
                            style: TextStyle(
                              color: isEditMode
                                  ? cs.onSurface.withOpacity(0.6)
                                  : cs.onSurface,
                            ),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "Enter admission number",
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Please enter admission number"
                                : null,
                          ),

                          // Email Address
                          CustomWidgets().buildLabel(context, "Email Address"),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: cs.onSurface),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "Enter email address",
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return "Please enter email address";
                              }
                              if (!GetUtils.isEmail(val.trim())) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                          ),

                          // Phone Number
                         CustomWidgets().buildLabel(context, "Phone Number"),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(color: cs.onSurface),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "Enter phone number",
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Please enter phone number"
                                : null,
                          ),

                          // Program of Study
                         CustomWidgets().buildLabel(context, "Program of Study"),
                          DropdownButtonFormField<String>(
                            value: _selectedProgram,
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              'Select Program',
                            ),
                            items: _buildDropdownItems(
                              _programs,
                              _selectedProgram,
                            ),
                            style: TextStyle(color: cs.onSurface, fontSize: 15),
                            dropdownColor: cs.onPrimary,
                            borderRadius: BorderRadius.circular(12),
                            onChanged: (val) {
                              setState(() {
                                _selectedProgram = val;
                              });
                            },
                            validator: (val) => val == null
                                ? 'Please select program of study'
                                : null,
                          ),

                          // Year of Study
                          CustomWidgets().buildLabel(context, "Year of Study"),
                          DropdownButtonFormField<String>(
                            value: _selectedYear,
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              'Select Year',
                            ),
                            items: _buildDropdownItems(_years, _selectedYear),
                            style: TextStyle(color: cs.onSurface, fontSize: 15),
                            dropdownColor: cs.onPrimary,
                            borderRadius: BorderRadius.circular(12),
                            onChanged: (val) {
                              setState(() {
                                _selectedYear = val;
                              });
                            },
                            validator: (val) => val == null
                                ? 'Please select year of study'
                                : null,
                          ),

                          // Date of Birth
                          CustomWidgets().buildLabel(context, "Date of Birth"),
                          InkWell(
                            onTap: () => _selectDOB(context),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: cs.outline.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: cs.outline.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedDOB == null
                                        ? 'Select Date of Birth'
                                        : _formatDOB(_selectedDOB!),
                                    style: tt.bodyMedium?.copyWith(
                                      color: _selectedDOB == null
                                          ? cs.onSurface.withOpacity(0.3)
                                          : cs.onSurface,
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today,
                                    color: cs.primary,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Caste
                          CustomWidgets().buildLabel(context, "Caste"),
                          DropdownButtonFormField<String>(
                            value: _selectedCaste,
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              'Select Caste',
                            ),
                            items: _buildDropdownItems(_castes, _selectedCaste),
                            style: TextStyle(color: cs.onSurface, fontSize: 15),
                            dropdownColor: cs.onPrimary,
                            borderRadius: BorderRadius.circular(12),
                            onChanged: (val) {
                              setState(() {
                                _selectedCaste = val;
                              });
                            },
                            validator: (val) =>
                                val == null ? 'Please select caste' : null,
                          ),

                          // Gender
                          CustomWidgets().buildLabel(context, "Gender"),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              'Select Gender',
                            ),
                            items: _buildDropdownItems(
                              _genders,
                              _selectedGender,
                            ),
                            style: TextStyle(color: cs.onSurface, fontSize: 15),
                            dropdownColor: cs.onPrimary,
                            borderRadius: BorderRadius.circular(12),
                            onChanged: (val) {
                              setState(() {
                                _selectedGender = val;
                              });
                            },
                            validator: (val) =>
                                val == null ? 'Please select gender' : null,
                          ),

                          // Blood Group
                          CustomWidgets().buildLabel(context, "Blood Group"),
                          DropdownButtonFormField<String>(
                            value: _selectedBloodGroup,
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              'Select Blood Group',
                            ),
                            items: _buildDropdownItems(
                              _bloodGroups,
                              _selectedBloodGroup,
                            ),
                            style: TextStyle(color: cs.onSurface, fontSize: 15),
                            dropdownColor: cs.onPrimary,
                            borderRadius: BorderRadius.circular(12),
                            onChanged: (val) {
                              setState(() {
                                _selectedBloodGroup = val;
                              });
                            },
                            validator: (val) => val == null
                                ? 'Please select blood group'
                                : null,
                          ),

                          const SizedBox(height: 32),

                          // Cancel & Save Buttons Row
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    side: BorderSide(color: cs.outline),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: tt.labelLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _saveVolunteer,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cs.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    isEditMode
                                        ? 'Save Changes'
                                        : 'Save Volunteer',
                                    style: tt.labelLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
