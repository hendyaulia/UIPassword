import 'package:flutter/material.dart';
import 'package:flutter_login_register_nodejs/services/api_service.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../config.dart';

class OtpVerifyPage extends StatefulWidget {
  final String? email;
  final String? otpCode;
  final String? otpHash;
  const OtpVerifyPage({this.email, this.otpCode, this.otpHash});

  @override
  OtpVerifyPageState createState() => OtpVerifyPageState(
      email: this.email, otpCode: this.otpCode, otpHash: this.otpHash);
}

class OtpVerifyPageState extends State<OtpVerifyPage> {
  final String? email;
  final String? otpCode;
  final String? otpHash;
  String _otpCode = "";
  final int _otpCodeLength = 6;
  bool isAPICallProcess = false;
  FocusNode myFocusNode = FocusNode();

  OtpVerifyPageState({this.email, this.otpCode, this.otpHash});

  @override
  void initState() {
    super.initState();
    print(email);
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();
    SmsAutoFill().listenForCode.call();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ProgressHUD(
          child: verifyOtpUI(),
          inAsyncCall: isAPICallProcess,
          opacity: .3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    myFocusNode.dispose();
    super.dispose();
  }

  verifyOtpUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/otp.png",
          height: 140,
          fit: BoxFit.contain,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Verifikasi OTP ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            "Masukkan 6 digit kode OTP yang dikirimkan ke $email",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: PinFieldAutoFill(
            decoration: UnderlineDecoration(
              textStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              colorBuilder: FixedColorBuilder(Colors.black.withOpacity(.3)),
            ),
            currentCode: _otpCode,
            codeLength: _otpCodeLength,
            onCodeChanged: (code) {
              if (code!.length == _otpCodeLength) {
                _otpCode = code;
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: FormHelper.submitButton(
            "Verifikasi",
            () {
              setState(() {
                isAPICallProcess = true;
              });

              print('VERIFY CALLED');

              print(widget.otpHash);
              print(_otpCode);

              APIService.verifyOTP(
                email!,
                _otpCode,
                otpHash!,
              ).then(
                (response) async {
                  setState(() {
                    isAPICallProcess = false;
                  });

                  if (response.message == "Success") {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/fingerprint',
                      (route) => false,
                    );
                  } else {
                    FormHelper.showSimpleAlertDialog(
                      context,
                      Config.appName,
                      "Kode OTP Salah!!",
                      "OK",
                      () {
                        Navigator.of(context).pop();
                      },
                    );
                  }
                },
              );
            },
            borderColor: HexColor("#78D0B1"),
            btnColor: HexColor("#78D0B1"),
            txtColor: HexColor("#000000"),
            borderRadius: 20,
          ),
        ),
      ],
    );
  }
}
