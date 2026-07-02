import 'dart:convert';
import 'dart:developer';

import 'package:nss_new/config/urls.dart';
import 'package:nss_new/config/utils.dart';
import 'package:nss_new/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:nss_new/model/volunteer_model.dart';

class Api {
    Future<LoginResponse?> login(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.login),
            body: jsonEncode(data),
            headers: await getHeader(),
          )
          .timeout(Duration(seconds: 60));

      if (checkValidations(response.body)) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return LoginResponse.fromJson(responseJson);
      }
    } catch (e) {
      checkConnectivity();
      log('Api error during login:$e');
    }
    return null;
  }

    //------------------Version check---------------------------//

  Future<GeneralResponse?> checkVersion() async {
    try {
      final response = await http
          .post(Uri.parse(Urls.checkVersion),
              body: jsonEncode({}), headers: await getHeader())
          .timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return GeneralResponse(status: true);
    }
  }

  //------------------List Volunteer---------------------------//

  Future<VolunteerList?> getVolunteers() async {
    try {
      final response = await http
          .get(Uri.parse(Urls.getVolunteers), headers: await getHeader())
          .timeout(Duration(seconds: 60));

      if (checkValidations(response.body)) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return VolunteerList.fromJson(responseJson);
      }
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
    }
    return null;
  }



//------------------Get Volunteer Details---------------------------//

  Future<VolunteerDetailResponse?> volunteerDetails(String admissionNo) async {
    try {
      final response = await http
          .post(Uri.parse(Urls.volunteerDetails),
              body: jsonEncode({'admission_number': admissionNo}),
              headers: await getHeader())
          .timeout(Duration(seconds: 60));

      if (checkValidations(response.body)) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return VolunteerDetailResponse.fromJson(responseJson);
      }
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
    }
    return null;
  }

//------------------Add Volunteer---------------------------//

  Future<GeneralResponse?> addVolunteer(Map<String, dynamic> user) async {
    try {
      final response = await http
          .post(Uri.parse(Urls.addVolunteer),
              body: jsonEncode(user), headers: await getHeader())
          .timeout(Duration(seconds: 60));

      if (checkValidations(response.body)) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return GeneralResponse.fromJson(responseJson);
      }
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
    }
    return null;
  }

//------------------Update Volunteer---------------------------//

  Future<GeneralResponse?> updateVolunteer(Map<String, dynamic> data) async {
    try {
      final response = await http
          .patch(Uri.parse(Urls.updateVolunteer),
              body: jsonEncode(data), headers: await getHeader())
          .timeout(Duration(seconds: 60));

      if (checkValidations(response.body)) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return GeneralResponse.fromJson(responseJson);
      }
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
    }
    return null;
  }

//------------------Delete Volunteer---------------------------//

  Future<GeneralResponse?> deleteVolunteer(String id) async {
    try {
      final response = await http
          .delete(Uri.parse(Urls.deleteVolunteer),
              body: jsonEncode({'volunteer': id}), headers: await getHeader())
          .timeout(Duration(seconds: 60));
      if (checkValidations(response.body)) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return GeneralResponse.fromJson(responseJson);
      }
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
    }
    return null;
  }
 //------------------Logout---------------------------//

  Future<LoginResponse?> logout() async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.logout),
            body: jsonEncode({}),
            headers: await getHeader(),
          )
          .timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during logout:$e');
    }
    return null;
  }
}