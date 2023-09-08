import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.message,
    this.data,
  });
  late final String message;
  Data? data;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    print(json['data3']);
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.username,
    required this.email,
    // required this.password,
    required this.date,
    required this.id,
    required this.otpCode,
    required this.otpHash,
    required this.token,
  });
  late final String username;
  late final String email;
  // late final String password;
  late final String date;
  late final String id;
  late final String otpCode;
  late final String otpHash;
  late final String token;

  Data.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    // password = json['password'];
    date = json['date'];
    id = json['id'];
    otpCode = json['otpCode'];
    otpHash = json['otpHash'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['email'] = email;
    // _data['password'] = password;
    _data['date'] = date;
    _data['id'] = id;
    _data['otpCode'] = otpCode;
    _data['otpHash'] = otpHash;
    _data['token'] = token;
    return _data;
  }
}
