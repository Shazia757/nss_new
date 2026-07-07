import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss_new/common_pages/custom_decorations.dart';
import 'package:nss_new/controller/blood_requirement_controller.dart';

class AddBloodRequirementScreen extends StatefulWidget {
  final BloodRequirement? requirement;

  const AddBloodRequirementScreen({super.key, this.requirement});

  @override
  State<AddBloodRequirementScreen> createState() =>
      _AddBloodRequirementScreenState();
}

class _AddBloodRequirementScreenState extends State<AddBloodRequirementScreen> {
  final _formKey = GlobalKey<FormState>();
  final BloodRequirementController controller =
      Get.find<BloodRequirementController>();

  late TextEditingController _patientNameController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _hospitalNameController;
  late TextEditingController _contactNumberController;
  late TextEditingController _dateTimeController;
  late TextEditingController _urgencyLevelController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final req = widget.requirement;
    _patientNameController = TextEditingController(
      text: req?.patientName ?? '',
    );
    _bloodGroupController = TextEditingController(text: req?.bloodGroup ?? '');
    _hospitalNameController = TextEditingController(
      text: req?.hospitalName ?? '',
    );
    _contactNumberController = TextEditingController(
      text: req?.contactNumber ?? '',
    );
    _dateTimeController = TextEditingController(text: req?.dateTime ?? '');
    _urgencyLevelController = TextEditingController(
      text: req?.urgencyLevel ?? '',
    );
    _descriptionController = TextEditingController(
      text: req?.description ?? '',
    );
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _bloodGroupController.dispose();
    _hospitalNameController.dispose();
    _contactNumberController.dispose();
    _dateTimeController.dispose();
    _urgencyLevelController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    if (!mounted) return;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final formattedTime =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    setState(() {
      _dateTimeController.text = "$formattedDate $formattedTime";
    });
  }

  void _saveRequirement() {
    if (_formKey.currentState!.validate()) {
      final req = widget.requirement;
      final newReq = BloodRequirement(
        id: req?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        patientName: _patientNameController.text.trim(),
        bloodGroup: _bloodGroupController.text.trim(),
        hospitalName: _hospitalNameController.text.trim(),
        contactNumber: _contactNumberController.text.trim(),
        dateTime: _dateTimeController.text.trim(),
        urgencyLevel: _urgencyLevelController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (req == null) {
        controller.addRequirement(newReq);
        Get.back();
        Get.snackbar(
          'Success',
          'Blood requirement added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
      } else {
        controller.updateRequirement(req.id, newReq);
        Get.back();
        Get.snackbar(
          'Success',
          'Blood requirement updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isEditMode = widget.requirement != null;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
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
                                'Back to requirements list',
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
                            isEditMode
                                ? 'Update emergency blood requisition'
                                : 'Create a new emergency blood requisiton',
                            style: tt.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isEditMode
                                ? 'Update the details of the active blood requirement'
                                : 'Fill the details below to raise a new emergency blood requirement',
                            style: tt.bodyMedium?.copyWith(
                              color: cs.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 24),

                          CustomWidgets().buildLabel(context, "Patient Name"),
                          TextFormField(
                            controller: _patientNameController,
                            style: TextStyle(color: cs.onSurface),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "Enter patient's full name",
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Please enter patient name"
                                : null,
                          ),

                          CustomWidgets().buildLabel(context, "Blood group"),
                          TextFormField(
                            controller: _bloodGroupController,
                            style: TextStyle(color: cs.onSurface),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "e.g., O+, A-, B+",
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Please enter blood group"
                                : null,
                          ),

                          CustomWidgets().buildLabel(context, "Hospital Name"),
                          TextFormField(
                            controller: _hospitalNameController,
                            style: TextStyle(color: cs.onSurface),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "Enter hospital name & location",
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Please enter hospital name"
                                : null,
                          ),

                          CustomWidgets().buildLabel(context, "Contact number"),
                          TextFormField(
                            controller: _contactNumberController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(color: cs.onSurface),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "Enter contact number",
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Please enter contact number"
                                : null,
                          ),

                          CustomWidgets().buildLabel(
                            context,
                            "Requirement Date & Time",
                          ),
                          TextFormField(
                            controller: _dateTimeController,
                            readOnly: true,
                            onTap: _selectDateTime,
                            style: TextStyle(color: cs.onSurface),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "Tap to select date & time",
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: cs.primary,
                              ),
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Please select date & time"
                                : null,
                          ),

                          CustomWidgets().buildLabel(context, "Urgency level"),
                          TextFormField(
                            controller: _urgencyLevelController,
                            style: TextStyle(color: cs.onSurface),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "e.g., Urgent, High, Medium, Low",
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Please enter urgency level"
                                : null,
                          ),

                          CustomWidgets().buildLabel(context, "Description"),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 3,
                            style: TextStyle(color: cs.onSurface),
                            decoration: CustomWidgets().buildInputDecoration(
                              context,
                              "Provide additional details",
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Please enter description"
                                : null,
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
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _saveRequirement,
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
                                  child: const Text('save requirement'),
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
