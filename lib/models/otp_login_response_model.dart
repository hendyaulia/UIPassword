import 'dart:convert';

OtpLoginResponseModel otploginResponseJSON(String str) =>
    OtpLoginResponseModel.fromJson(json.decode(str));

class OtpLoginResponseModel {
  OtpLoginResponseModel({
    required this.message,
  });
  late final String message;

  OtpLoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    return _data;
  }
}
