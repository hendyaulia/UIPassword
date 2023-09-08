import 'dart:convert';
import 'dart:io';

import 'package:flutter_login_register_nodejs/models/login_request_model.dart';
import 'package:flutter_login_register_nodejs/models/login_response_model.dart';
import 'package:flutter_login_register_nodejs/models/otp_login_response_model.dart';
import 'package:flutter_login_register_nodejs/models/register_request_model.dart';
import 'package:flutter_login_register_nodejs/models/register_response_model.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import 'shared_service.dart';

class APIService {
  static var client = http.Client();

  static Future<LoginResponseModel> login(
    LoginRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.loginAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    print(response);

    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(
        loginResponseJson(
          response.body,
        ),
      );
    }
    return loginResponseJson(response.body);
  }

  static Future<RegisterResponseModel> register(
    RegisterRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.registerAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    return registerResponseJson(
      response.body,
    );
  }

  static Future<String> getUserProfile() async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${loginDetails!.data?.token}'
    };

    var url = Uri.http(Config.apiURL, Config.userProfileAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  }

  static Future<OtpLoginResponseModel> otpLogin(String email) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.otpLoginAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {"phone": email},
      ),
    );

    return otploginResponseJSON(response.body);
  }

  static Future<OtpLoginResponseModel> verifyOTP(
      String email, String otpCode, String otpHash) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.otpVerifyAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {
          "phone": email,
          "otp": otpCode,
          "hash": otpHash,
        },
      ),
    );
    print(response.body);
    return otploginResponseJSON(response.body);
  }
}
