import 'package:nss_new/model/department_model.dart';
import 'package:nss_new/model/user_model.dart';

class VolunteerList {
  bool? status;
  String? message;
  List<Volunteer>? data;

  VolunteerList({this.status, this.message, this.data});

  factory VolunteerList.fromJson(Map<String, dynamic> json) {
    return VolunteerList(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Volunteer.fromJson(e as Map<String, dynamic>))
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
      volunteerDetails: json['volunteer_details'] != null
          ? Users.fromJson(json['volunteer_details'])
          : null,
    );
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
  String? bloodGroup;
  String? address;
  String? phoneNumber;

  Volunteer({
    this.admissionNo,
    this.name,
    this.department,
    this.role,
    this.bloodGroup,
    this.address,
    this.phoneNumber,
  });

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      admissionNo: json['admission_number'] as String?,
      name: json['name'] as String?,
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
      role: json['role'] as String?,
      bloodGroup: json['blood_group'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admission_number': admissionNo,
      'name': name,
      'department': department?.toJson(),
      'role': role,
      'blood_group': bloodGroup,
      'address': address,
      'phone_number': phoneNumber,
    };
  }
}
