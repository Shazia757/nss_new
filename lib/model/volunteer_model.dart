import 'package:nss_new/model/department_model.dart';
import 'package:nss_new/model/user_model.dart';

class VolunteerList {
  bool? status;
  String? message;
  List<Users>? data;

  VolunteerList({this.status, this.message, this.data});

  factory VolunteerList.fromJson(Map<String, dynamic> json) {
    return VolunteerList(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Users.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class VolunteerDetailResponse {
  bool? status;
  String? message;
  Users? volunteerDetails;

  VolunteerDetailResponse({this.status, this.message, this.volunteerDetails});

  factory VolunteerDetailResponse.fromJson(Map<String, dynamic> json) {
    return VolunteerDetailResponse(
        status: json['status'] as bool?,
        message: json['message'] as String?,
        volunteerDetails: Users.fromJson(json['volunteer_details']));
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'volunteer_details': volunteerDetails?.toJson(),
    };
  }
}

class Volunteer {
  String? admissionNo;
  String? name;
  Department? department;
  String? role;

  Volunteer({this.admissionNo, this.name, this.department, this.role});

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
        admissionNo: json['admission_number'] as String?,
        name: json['name'] as String?,
        department: Department.fromJson(json['department']),
        role: json['role'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      'admission_number': admissionNo,
      'name': name,
      'department': department?.toJson(),
      'role': role
    };
  }
}

