import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss_new/controller/program_controller.dart';
import 'package:nss_new/model/programs_model.dart';
import 'package:nss_new/common_pages/custom_decorations.dart';

class StudentsEnrollmentScreen extends StatelessWidget {
  const StudentsEnrollmentScreen({super.key, this.data});
  final Program? data;

  @override
  Widget build(BuildContext context) {
    ProgramListController c = Get.find<ProgramListController>();
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.primary),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () => c.selectAllVolunteers(),
            child: const Text("Select all"),
          ),
        ],
        title: Text(
          data?.name ?? 'Participants',
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
      ),

      floatingActionButton: Obx(
        () => c.selectedVolList.isNotEmpty
            ? FloatingActionButton.extended(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
                onPressed: () => CustomWidgets().showConfirmationDialog(
                  title: "Submit Attendance",
                  content: SizedBox(
                    height: 240,
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Are you sure you want to mark attendance for these volunteers?",
                          style: tt.bodyMedium?.copyWith(
                            color: cs.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: cs.outline.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListView.builder(
                              itemCount: c.selectedVolList.length,
                              itemBuilder: (context, i) => ListTile(
                                dense: true,
                                trailing: Text(
                                  c.selectedVolList[i].admissionNo ?? '',
                                  style: tt.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                title: Text(
                                  c.selectedVolList[i].name ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  "${c.selectedVolList[i].department?.category ?? ''} ${c.selectedVolList[i].department?.name ?? ''}",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onConfirm: () {
                    c.addAttendance(data);
                  },
                  data: Obx(
                    () => c.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.red,
                            ),
                          )
                        : const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.red),
                          ),
                  ),
                ),
                icon: const Icon(Icons.check_circle),
                label: Text("Submit Attendance (${c.selectedVolList.length})"),
              )
            : const SizedBox(),
      ),
      body: SafeArea(
        child: Obx(() {
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (c.enrollmentList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline_rounded,
                    size: 64,
                    color: cs.onSurface.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No volunteers enrolled',
                    style: tt.titleMedium?.copyWith(
                      color: cs.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Top Info Card (Date picker & Duration field)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.onPrimary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cs.outline.withOpacity(0.4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Attendance Date",
                                style: tt.labelLarge?.copyWith(
                                  color: cs.onSurface.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now().subtract(
                                      const Duration(days: 365),
                                    ),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 365),
                                    ),
                                  ).then((value) {
                                    if (value != null) {
                                      c.programDate = value;
                                      c.showProgramDate.value =
                                          DateFormat.yMMMd().format(value);
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.edit_calendar_rounded,
                                  color: cs.primary,
                                  size: 18,
                                ),
                                label: Text(
                                  c.showProgramDate.value,
                                  style: TextStyle(
                                    color: cs.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hours Spent",
                                  style: tt.labelLarge?.copyWith(
                                    color: cs.onSurface.withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  height: 48,
                                  child: TextField(
                                    controller: c.durationController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: cs.onSurface),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                      suffixText: "Hrs",
                                      filled: true,
                                      fillColor: cs.outline.withOpacity(0.08),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: cs.outline.withOpacity(0.3),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: cs.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Volunteers Checklist Heading
                    Row(
                      children: [
                        Icon(
                          Icons.checklist_rounded,
                          color: cs.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Enrolled Volunteers List",
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Scrollable List
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: cs.onPrimary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: cs.outline.withOpacity(0.4),
                          ),
                        ),
                        child: ListView.separated(
                          itemCount: c.enrollmentList.length,
                          itemBuilder: (context, index) {
                            final vol = c.enrollmentList[index].volunteer;
                            if (vol == null) return const SizedBox();
                            return Obx(() {
                              final isSelected = c.selectedVolList.any(
                                (element) =>
                                    element.admissionNo == vol.admissionNo,
                              );
                              return CheckboxListTile(
                                activeColor: cs.primary,
                                checkColor: Colors.white,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                value: isSelected,
                                onChanged: (value) {
                                  if (value ?? false) {
                                    c.selectedVolList.add(vol);
                                  } else {
                                    c.selectedVolList.removeWhere(
                                      (element) =>
                                          element.admissionNo ==
                                          vol.admissionNo,
                                    );
                                  }
                                },
                                title: Text(
                                  vol.name ?? '',
                                  style: tt.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: cs.onSurface,
                                  ),
                                ),
                                subtitle: Text(
                                  "${vol.department?.category ?? ''} ${vol.department?.name ?? ''}\nAdmission No: ${vol.admissionNo ?? ''}",
                                  style: tt.bodySmall?.copyWith(
                                    color: cs.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              );
                            });
                          },
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            thickness: 0.8,
                            color: cs.outline.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
