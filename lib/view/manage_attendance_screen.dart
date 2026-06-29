import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss_new/controller/attendance_controller.dart';
import 'package:nss_new/view/home_screen.dart';
import 'package:nss_new/view/view_attendance_screen.dart';
import 'package:nss_new/view/record_attendance_screen.dart';

class ManageAttendanceScreen extends StatefulWidget {
  const ManageAttendanceScreen({super.key});

  @override
  State<ManageAttendanceScreen> createState() => _ManageAttendanceScreenState();
}

class _ManageAttendanceScreenState extends State<ManageAttendanceScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final AttendanceController controller = Get.put(AttendanceController());

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: cs.surface,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => const RecordAttendanceScreen());
          },
          backgroundColor: cs.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Column(
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
                          hintText:
                              'Search by volunteer name or admission ID...',
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
                    'Manage Attendance',
                    style: tt.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage and track volunteer participation and service hours across all programs.',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final filteredVolunteers = controller.volunteerList.where((p) {
                final nameMatch =
                    p['name']?.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ??
                    false;
                final idMatch =
                    p['admissionNo']?.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ??
                    false;
                return nameMatch || idMatch;
              }).toList();

              return Expanded(
                child: filteredVolunteers.isEmpty
                    ? Center(
                        child: Text(
                          'No volunteers found',
                          style: tt.bodyMedium?.copyWith(
                            color: cs.onSurface.withOpacity(0.5),
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          controller.volunteerList.refresh();
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 4.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: cs.onPrimary,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: cs.outline.withOpacity(0.3),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: cs.shadow.withOpacity(0.04),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(
                                      cs.primary.withOpacity(0.06),
                                    ),
                                    columnSpacing: 24,
                                    showCheckboxColumn: false,
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          'Volunteer',
                                          style: tt.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: cs.primary,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Last Program',
                                          style: tt.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: cs.primary,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Date',
                                          style: tt.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: cs.primary,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Hours',
                                          style: tt.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: cs.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: filteredVolunteers.map((v) {
                                      final List<dynamic> attendedList =
                                          v['attendedPrograms'] ?? [];
                                      final hasAttended =
                                          attendedList.isNotEmpty;
                                      final lastProgram = hasAttended
                                          ? attendedList.last
                                          : null;

                                      return DataRow(
                                        onSelectChanged: (_) {
                                          Get.to(
                                            () =>
                                                AttendanceScreen(volunteer: v),
                                          );
                                        },
                                        cells: [
                                          DataCell(
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  v['name'] ?? '',
                                                  style: tt.bodyMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: cs.onSurface,
                                                      ),
                                                ),
                                                Text(
                                                  v['admissionNo'] ?? '',
                                                  style: tt.bodySmall?.copyWith(
                                                    color: cs.onSurface
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              lastProgram?['title'] ??
                                                  'No program',
                                              style: tt.bodyMedium?.copyWith(
                                                color: hasAttended
                                                    ? cs.onSurface
                                                    : cs.onSurface.withOpacity(
                                                        0.4,
                                                      ),
                                                fontStyle: hasAttended
                                                    ? FontStyle.normal
                                                    : FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              lastProgram?['date'] ?? '-',
                                              style: tt.bodyMedium?.copyWith(
                                                color: hasAttended
                                                    ? cs.onSurface
                                                    : cs.onSurface.withOpacity(
                                                        0.4,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            hasAttended
                                                ? Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: cs.secondary
                                                          .withOpacity(0.12),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '${lastProgram?['hours']} hrs',
                                                      style: tt.labelMedium
                                                          ?.copyWith(
                                                            color: cs.secondary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  )
                                                : Text(
                                                    '-',
                                                    style: tt.bodyMedium
                                                        ?.copyWith(
                                                          color: cs.onSurface
                                                              .withOpacity(0.4),
                                                        ),
                                                  ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
