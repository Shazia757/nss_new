import 'package:get/get.dart';

class AttendanceController extends GetxController {
  final volunteerList = <Map<String, dynamic>>[
    {
      'admissionNo': 'FCBSC001',
      'name': 'Aisha Rahman',
      'program': 'B.Voc Software Development',
      'attendedPrograms': [
        {
          'title': 'Anti-Drug Awareness Rally',
          'date': 'May 15, 2026',
          'hours': '2',
        },
        {'title': 'Blood Donation Camp', 'date': 'June 12, 2026', 'hours': '4'},
      ],
    },
    {
      'admissionNo': 'FCBSC002',
      'name': 'Muhammed Shamil',
      'program': 'B.Sc Computer Science',
      'attendedPrograms': [
        {
          'title': 'Summer Camp for Kids',
          'date': 'April 22, 2026',
          'hours': '6',
        },
        {
          'title': 'Tree Plantation Drive',
          'date': 'July 05, 2026',
          'hours': '3',
        },
      ],
    },
    {
      'admissionNo': 'FCBSC003',
      'name': 'Fathima Nisa',
      'program': 'B.Com Finance',
      'attendedPrograms': [
        {
          'title': 'Palliative Care Training',
          'date': 'March 10, 2026',
          'hours': '6',
        },
      ],
    },
    {
      'admissionNo': 'FCBSC004',
      'name': 'Adil Mohammed',
      'program': 'B.Voc Software Development',
      'attendedPrograms': [
        {
          'title': 'Beach Cleaning Drive',
          'date': 'August 08, 2026',
          'hours': '4',
        },
        {
          'title': 'Independence Day Celebration',
          'date': 'August 15, 2026',
          'hours': '5',
        },
      ],
    },
    {
      'admissionNo': 'FCBSC005',
      'name': 'Jishad Ali',
      'program': 'BCA',
      'attendedPrograms': [
        {
          'title': 'Health Awareness Campaign',
          'date': 'September 03, 2026',
          'hours': '3',
        },
        {
          'title': 'Flood Relief Collection',
          'date': 'September 18, 2026',
          'hours': '7',
        },
      ],
    },
  ].obs;

  void markAttendance({
    required List<String> selectedAdmissions,
    required String programTitle,
    required String date,
    required String hours,
    String remarks = '',
  }) {
    for (var i = 0; i < volunteerList.length; i++) {
      final volunteer = volunteerList[i];
      if (selectedAdmissions.contains(volunteer['admissionNo'])) {
        final List<Map<String, dynamic>> attended = List<Map<String, dynamic>>.from(volunteer['attendedPrograms'] ?? []);
        attended.add({
          'title': programTitle,
          'date': date,
          'hours': hours,
          'remarks': remarks,
        });
        
        volunteerList[i] = {
          ...volunteer,
          'attendedPrograms': attended,
        };
      }
    }
    volunteerList.refresh();
  }
}
