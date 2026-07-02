import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss_new/common_pages/navbar.dart';
import 'package:nss_new/controller/account_controller.dart';
import 'package:nss_new/database/local_storage.dart';
import 'package:nss_new/view/add_program_screen.dart';
import 'package:nss_new/view/manage_attendance_screen.dart';
import 'package:nss_new/view/manage_blood_requirement_screen.dart';
import 'package:nss_new/view/manage_volunteer_screen.dart';
import 'package:nss_new/view/programs_screen.dart';
import 'package:nss_new/controller/blood_requirement_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bloodController = Get.put(BloodRequirementController());

    final notifications = [
      NotificationModel(
        icon: Icons.campaign_outlined,
        title: 'Blood Donation Camp',
        subtitle: 'Volunteers are invited to participate this Friday.',
        time: '2 hrs ago',
      ),
      NotificationModel(
        icon: Icons.event_available_outlined,
        title: 'Attendance Updated',
        subtitle: 'Your attendance has been updated for the recent event.',
        time: '5 hrs ago',
      ),
      NotificationModel(
        icon: Icons.warning_amber_outlined,
        title: 'Program Schedule Changed',
        subtitle: 'The environmental drive has been rescheduled.',
        time: '1 day ago',
      ),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xffF8F7FA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// HEADER
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xff26206B), Color(0xff5A52B3)],
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "INSTITUTIONAL CHAPTER",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: Colors.white70,
                                            letterSpacing: 1,
                                          ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "NSS Farook College",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(height: 25),
                                    Text(
                                      "Hello, ${LocalStorage().readUser().name}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "\"Not Me, But You\"",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: cs.surface.withOpacity(0.8),
                                            fontStyle: FontStyle.italic,
                                          ),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),

                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 8,
                                      color: Colors.black12,
                                    ),
                                  ],
                                ),
                                child: Image.asset('assets/logos/logo.png'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Transform.translate(
                      offset: const Offset(0, -25),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildStatsCard(context),
                      ),
                    ),
                    if (LocalStorage().readUser().role == 'sec') ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 5,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _actionCard(
                                icon: Icons.star,
                                bg: Colors.red.shade100,
                                iconColor: Colors.red,
                                title: "Manage Attendance",
                                onTap: () =>
                                    Get.to(() => ManageAttendanceScreen()),
                              ),
                              _actionCard(
                                icon: Icons.description_outlined,
                                bg: Colors.amber.shade100,
                                iconColor: Colors.orange,
                                title: "Add Program",
                                onTap: () => Get.to(() => AddProgramScreen()),
                              ),
                              _actionCard(
                                icon: Icons.menu_book_outlined,
                                bg: Colors.indigo.shade100,
                                iconColor: Colors.indigo,
                                title: "Manage Volunteer",
                                onTap: () =>
                                    Get.to(() => ManageVolunteerScreen()),
                              ),
                              _actionCard(
                                icon: Icons.bloodtype_outlined,
                                bg: Colors.red.shade100,
                                iconColor: Colors.red,
                                title: "Blood Requirement",
                                onTap: () => Get.to(
                                  () => ManageBloodRequirementScreen(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Stay updated with recent announcements and alerts',
                            style: tt.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),

                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: notifications.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) =>
                                _buildNotificationCard(
                                  context,
                                  notifications[index],
                                  cs,
                                  tt,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: notifications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return _buildNotificationCard(
                            context,
                            notification,
                            cs,
                            tt,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Upcoming Programs",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: cs.primary),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffECE6FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "View All",
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(color: cs.primary),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      height: 280,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        itemCount: ProgramsScreen.upcomingList.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final program = ProgramsScreen.upcomingList[index];
                          return _programCard(context, cs, program);
                        },
                      ),
                    ),

                    Obx(() {
                      if (bloodController.requirements.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Active Blood Requirements",
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: cs.primary),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 220,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              itemCount: bloodController.requirements.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final req = bloodController.requirements[index];
                                return _bloodRequirementCard(context, cs, req);
                              },
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xffF2EFF5),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "\"The best way to find yourself is\n"
                              "to lose yourself in the service of\n"
                              "others.\"",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(
                                    color: cs.primary,
                                    fontStyle: FontStyle.italic,
                                    height: 1.5,
                                  ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "— Mahatma Gandhi",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required Color bg,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),

              CircleAvatar(
                radius: 20,
                backgroundColor: bg,
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationModel notification,
    ColorScheme cs,
    TextTheme tt,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withOpacity(0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(notification.icon, color: cs.primary, size: 22),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification.title,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      notification.time,
                      style: tt.labelMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.subtitle,
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    value: .75,
                    strokeWidth: 7,
                    backgroundColor: Colors.grey.shade200,
                    color: cs.primary,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "15",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "ATTENDED",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: cs.primary.withOpacity(.8),
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Great Work!",
                  style: TextStyle(
                    color: Color(0xff5A52B3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text("You've completed 15\nprograms this semester."),
                SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  NotificationModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}

void _showEnrollConfirmationDialog(BuildContext context, String programTitle) {
  final cs = Theme.of(context).colorScheme;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Confirm Enrollment"),
      content: Text("Are you sure you want to enroll in \"$programTitle\"?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: TextStyle(color: cs.onSurface.withOpacity(0.6)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Get.snackbar(
              "Success",
              "Successfully enrolled in $programTitle",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.9),
              colorText: Colors.white,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Confirm", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

Widget _programCard(
  BuildContext context,
  ColorScheme cs,
  Map<String, String> program,
) {
  return Container(
    width: 280,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          program['title'] ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(color: cs.primary),
        ),
        const SizedBox(height: 8),
        Text(
          program['description'] ?? '',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 18),
            const SizedBox(width: 8),
            Text(program['date'] ?? ''),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.hourglass_empty, size: 18),
            const SizedBox(width: 8),
            Text(program['duration'] ?? ''),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              _showEnrollConfirmationDialog(context, program['title'] ?? '');
            },
            child: const Text(
              "Enroll Now",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _bloodRequirementCard(
  BuildContext context,
  ColorScheme cs,
  BloodRequirement req,
) {
  return Container(
    width: 280,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
      border: Border.all(color: cs.outline.withOpacity(0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: cs.primary.withOpacity(0.1),
              child: Text(
                req.bloodGroup,
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                req.patientName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.local_hospital_outlined,
              size: 16,
              color: cs.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                req.hospitalName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: cs.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(req.dateTime, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            onPressed: () {
              _showAcceptRequestConfirmationDialog(context, req);
            },
            child: const Text(
              "Accept Request",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}

void _showAcceptRequestConfirmationDialog(
  BuildContext context,
  BloodRequirement req,
) {
  final cs = Theme.of(context).colorScheme;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Accept Blood Request"),
      content: Text(
        "Are you sure you want to accept the request for patient \"${req.patientName}\" who requires \"${req.bloodGroup}\" blood at \"${req.hospitalName}\"?",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: TextStyle(color: cs.onSurface.withOpacity(0.6)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Get.snackbar(
              "Accepted",
              "You have accepted the request for ${req.patientName}. Thank you!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.9),
              colorText: Colors.white,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Confirm", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
