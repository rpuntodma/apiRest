import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:api_consumer/ApiConstants.dart';
import 'package:api_consumer/UsersModel.dart';

class ApiService {
  Future<List<UsersModel>?> getUsers() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<UsersModel> model = usersModelFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}