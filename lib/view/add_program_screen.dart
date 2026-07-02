import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss_new/common_pages/custom_decorations.dart';

class AddProgramScreen extends StatefulWidget {
  final Map<String, String>? program;

  const AddProgramScreen({super.key, this.program});

  @override
  State<AddProgramScreen> createState() => _AddProgramScreenState();
}

class _AddProgramScreenState extends State<AddProgramScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _hoursController;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final v = widget.program;
    _nameController = TextEditingController(text: v?['title'] ?? '');
    _hoursController = TextEditingController(text: v?['duration'] ?? '');
    _descriptionController = TextEditingController(
      text: v?['description'] ?? '',
    );

    if (v?['date'] != null && v!['date']!.isNotEmpty) {
      _selectedDate = _parseDate(v['date']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isEditMode = widget.program != null;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                'Back to programs list',
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
                          Text(
                            isEditMode ? 'Edit Program' : 'Add Program',
                            style: tt.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isEditMode
                                ? 'Update the program details'
                                : 'Add an upcoming event',
                            style: tt.bodyMedium?.copyWith(
                              color: cs.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomWidgets().buildLabel(context, "Program Name"),
                          TextFormField(
                            controller: _nameController,
                            style: TextStyle(color: cs.onSurface),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "e.g., Annual Health Awareness Campaign",
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Please enter program name"
                                : null,
                          ),
                          CustomWidgets().buildLabel(
                            context,
                            "Program Description",
                          ),

                          TextFormField(
                            controller: _descriptionController,
                            style: TextStyle(color: cs.onSurface),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "Describe the program...",
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Please add description"
                                : null,
                          ),
                          CustomWidgets().buildLabel(context, "Program Date"),
                          InkWell(
                            onTap: () => _selectDate(context),
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
                                    _selectedDate == null
                                        ? 'Select Date'
                                        : _formatDate(_selectedDate!),
                                    style: tt.bodyMedium?.copyWith(
                                      color: _selectedDate == null
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
                          CustomWidgets().buildLabel(context, "Expected Hours"),
                          TextFormField(
                            controller: _hoursController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: cs.onSurface),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "0.0",
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Please enter the expected hours"
                                : null,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cs.primary.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(12),
                              border: Border(
                                left: BorderSide(color: cs.primary, width: 4),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: cs.primary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Note',
                                      style: tt.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: cs.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Ensure all fields are accurate. These details will be visible to all volunteers and will be used for official NSS certification reports.',
                                  style: tt.bodySmall?.copyWith(
                                    color: cs.onSurface.withOpacity(0.8),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
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
                                  onPressed: _saveProgram,
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
                                        : 'Save Program',
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

  DateTime? _parseDate(String dobStr) {
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

  String _formatDate(DateTime date) {
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2005, 1, 1),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveProgram() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      Get.snackbar(
        "Required Field Missing",
        "Please select Program Date",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final hours = _hoursController.text.trim();
    final dateStr = _formatDate(_selectedDate!);

    // final volunteerController = Get.find<VolunteerController>();
    // final attendanceController = Get.isRegistered<AttendanceController>()
    //     ? Get.find<AttendanceController>()
    //     : Get.put(AttendanceController());

    final isEditMode = widget.program != null;

    if (isEditMode) {
      final updatedData = {'name': name};

      // if (index != -1) {
      //   volunteerController.volunteerDetailsList[index] = updatedData;
      // } else {
      //   volunteerController.volunteerDetailsList.add(updatedData);
      // }

      // Update in AttendanceController
      // final attIndex = attendanceController.volunteerList.indexWhere(
      //   (v) => v['admissionNo'] == originalAdmnNo,
      // );

      // if (attIndex != -1) {
      //   final existingAtt = attendanceController.volunteerList[attIndex];
      //   attendanceController.volunteerList[attIndex] = {
      //     'admissionNo': admissionNo,
      //     'name': name,
      //     'program': _selectedProgram!,
      //     'attendedPrograms': existingAtt['attendedPrograms'] ?? [],
      //   };
      // } else {
      //   attendanceController.volunteerList.add({
      //     'admissionNo': admissionNo,
      //     'name': name,
      //     'program': _selectedProgram!,
      //     'attendedPrograms': [],
      //   });
      // }

      // volunteerController.volunteerDetailsList.refresh();
      // attendanceController.volunteerList.refresh();

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
      // final exists = volunteerController.volunteerDetailsList.any(
      //   (v) => v['admissionNo'] == admissionNo,
      // );

      // if (exists) {
      //   Get.snackbar(
      //     "Duplicate Admission Number",
      //     "A volunteer with admission number $admissionNo already exists.",
      //     backgroundColor: Colors.red.shade100,
      //     colorText: Colors.red.shade900,
      //     snackPosition: SnackPosition.BOTTOM,
      //   );
      //   return;
      // }

      // final newData = {
      //   'admissionNo': admissionNo,
      //   'name': name,
      //   'email': email,
      //   'phone': phone,
      //   'program': _selectedProgram!,
      //   'year': _selectedYear!,
      //   'dob': dobStr,
      //   'caste': _selectedCaste!,
      //   'gender': _selectedGender!,
      //   'bloodGroup': _selectedBloodGroup!,
      // };

      // volunteerController.volunteerDetailsList.add(newData);

      // attendanceController.volunteerList.add({
      //   'admissionNo': admissionNo,
      //   'name': name,
      //   'program': _selectedProgram!,
      //   'attendedPrograms': [],
      // });

      // volunteerController.volunteerDetailsList.refresh();
      // attendanceController.volunteerList.refresh();

      // Get.snackbar(
      //   "Volunteer Added",
      //   "Successfully registered $name as a new NSS volunteer.",
      //   backgroundColor: Colors.green.shade100,
      //   colorText: Colors.green.shade900,
      //   snackPosition: SnackPosition.BOTTOM,
      // );

      Get.back();
    }
  }
}
