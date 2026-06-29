import 'package:get/get.dart';

class BloodRequirement {
  String id;
  String patientName;
  String bloodGroup;
  String hospitalName;
  String contactNumber;
  String dateTime;
  String urgencyLevel;
  String description;

  BloodRequirement({
    required this.id,
    required this.patientName,
    required this.bloodGroup,
    required this.hospitalName,
    required this.contactNumber,
    required this.dateTime,
    required this.urgencyLevel,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientName': patientName,
        'bloodGroup': bloodGroup,
        'hospitalName': hospitalName,
        'contactNumber': contactNumber,
        'dateTime': dateTime,
        'urgencyLevel': urgencyLevel,
        'description': description,
      };

  factory BloodRequirement.fromJson(Map<String, dynamic> json) => BloodRequirement(
        id: json['id'] ?? '',
        patientName: json['patientName'] ?? '',
        bloodGroup: json['bloodGroup'] ?? '',
        hospitalName: json['hospitalName'] ?? '',
        contactNumber: json['contactNumber'] ?? '',
        dateTime: json['dateTime'] ?? '',
        urgencyLevel: json['urgencyLevel'] ?? '',
        description: json['description'] ?? '',
      );
}

class BloodRequirementController extends GetxController {
  final RxList<BloodRequirement> requirements = <BloodRequirement>[
    BloodRequirement(
      id: '1',
      patientName: 'Rahul Sharma',
      bloodGroup: 'O+',
      hospitalName: 'Aster MIMS Hospital',
      contactNumber: '+91 9876543210',
      dateTime: '2026-06-30 10:00 AM',
      urgencyLevel: 'High',
      description: 'Urgent need of O+ blood for cardiac surgery.',
    ),
    BloodRequirement(
      id: '2',
      patientName: 'Ananya Das',
      bloodGroup: 'A-',
      hospitalName: 'Farook College Health Centre',
      contactNumber: '+91 8765432109',
      dateTime: '2026-06-29 04:30 PM',
      urgencyLevel: 'Urgent',
      description: 'Accident case. Immediate transfusion required.',
    ),
  ].obs;

  void addRequirement(BloodRequirement req) {
    requirements.add(req);
  }

  void updateRequirement(String id, BloodRequirement updatedReq) {
    int index = requirements.indexWhere((element) => element.id == id);
    if (index != -1) {
      requirements[index] = updatedReq;
    }
  }

  void deleteRequirement(String id) {
    requirements.removeWhere((element) => element.id == id);
  }
}
