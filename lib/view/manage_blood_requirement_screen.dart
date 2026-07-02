import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss_new/common_pages/custom_decorations.dart';
import 'package:nss_new/controller/blood_requirement_controller.dart';
import 'package:nss_new/view/add_blood_requirement_screen.dart';
import 'package:nss_new/view/home_screen.dart';

class ManageBloodRequirementScreen extends StatefulWidget {
  const ManageBloodRequirementScreen({super.key});

  @override
  State<ManageBloodRequirementScreen> createState() =>
      _ManageBloodRequirementScreenState();
}

class _ManageBloodRequirementScreenState
    extends State<ManageBloodRequirementScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final BloodRequirementController controller = Get.put(
    BloodRequirementController(),
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildRequirementCard(
    BuildContext context,
    BloodRequirement req,
    ColorScheme cs,
    TextTheme tt,
  ) {
    Color urgencyBg = Colors.grey.shade100;
    Color urgencyText = Colors.grey.shade800;
    if (req.urgencyLevel.toLowerCase().contains('urgent')) {
      urgencyBg = Colors.red.shade50;
      urgencyText = Colors.red.shade700;
    } else if (req.urgencyLevel.toLowerCase().contains('high')) {
      urgencyBg = Colors.orange.shade50;
      urgencyText = Colors.orange.shade700;
    } else if (req.urgencyLevel.toLowerCase().contains('medium')) {
      urgencyBg = Colors.blue.shade50;
      urgencyText = Colors.blue.shade700;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: cs.primary.withOpacity(0.1),
                      child: Text(
                        req.bloodGroup,
                        style: tt.titleMedium?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            req.patientName,
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.local_hospital_outlined,
                                size: 14,
                                color: cs.onSurface.withOpacity(0.5),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  req.hospitalName,
                                  style: tt.bodySmall?.copyWith(
                                    color: cs.onSurface.withOpacity(0.6),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: urgencyBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  req.urgencyLevel,
                  style: tt.labelSmall?.copyWith(
                    color: urgencyText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: cs.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          req.contactNumber,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: cs.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          req.dateTime,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: cs.primary,
                      size: 20,
                    ),
                    onPressed: () {
                      Get.to(() => AddBloodRequirementScreen(requirement: req));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: cs.error, size: 20),
                    onPressed: () {
                      _showDeleteConfirmation(context, req);
                    },
                  ),
                ],
              ),
            ],
          ),
          if (req.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              req.description,
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurface.withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, BloodRequirement req) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Requirement'),
        content: Text(
          'Are you sure you want to delete the blood requirement for ${req.patientName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteRequirement(req.id);
              Navigator.of(ctx).pop();
              Get.snackbar(
                'Deleted',
                'Requirement deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.withOpacity(0.9),
                colorText: Colors.white,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: cs.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddBloodRequirementScreen());
        },
        backgroundColor: cs.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 16.0,
                top: 12.0,
                bottom: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: cs.primary),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: cs.outline.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by patient name or hospital...',
                          hintStyle: tt.bodyMedium?.copyWith(
                            color: cs.onSurface.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: cs.onSurface.withOpacity(0.6),
                            size: 20,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: cs.onSurface.withOpacity(0.6),
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manage Blood Requirement',
                    style: tt.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Oversee and coordinate critical blood supply logistics',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;

                  if (isWide) {
                    return Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: "Active Requests",
                            value: controller.requirements.length.toString(),
                            icon: Icons.event_rounded,
                            backgroundColor: cs.primary,
                            textColor: cs.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomWidgets().buildSummaryCard(
                            context,
                            title: "Fulfilled Today",
                            value: '8',
                            icon: Icons.task_alt_rounded,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      StatCard(
                        title: "Active Requests",
                        value: controller.requirements.length.toString(),
                        icon: Icons.event_rounded,
                        backgroundColor: cs.primary,
                        textColor: cs.onPrimary,
                      ),
                      const SizedBox(height: 12),
                      CustomWidgets().buildSummaryCard(
                        context,
                        title: "Fulfilled Today",
                        value: '8',
                        icon: Icons.task_alt_rounded,
                        color: Colors.green,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Requirement Registry',
                      style: tt.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Obx(() {
                        final query = _searchQuery.toLowerCase().trim();
                        final filteredList = controller.requirements.where((
                          req,
                        ) {
                          return req.patientName.toLowerCase().contains(
                                query,
                              ) ||
                              req.hospitalName.toLowerCase().contains(query);
                        }).toList();

                        if (filteredList.isEmpty) {
                          return Center(
                            child: Text(
                              'No blood requirements found',
                              style: tt.bodyMedium?.copyWith(
                                color: cs.onSurface.withOpacity(0.5),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final req = filteredList[index];
                            return _buildRequirementCard(context, req, cs, tt);
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
