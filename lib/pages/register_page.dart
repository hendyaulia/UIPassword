import 'package:flutter/material.dart';
import 'package:flutter_login_register_nodejs/models/login_request_model.dart';
import 'package:flutter_login_register_nodejs/models/register_request_model.dart';
import 'package:flutter_login_register_nodejs/services/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool isApiCallProcess = false;
  bool hidePassword = true;
  bool _containsUppercase(String password) {
    // Kode untuk memeriksa apakah password mengandung huruf kapital
    return password.contains(RegExp(r'[A-Z]'));
  }

  bool _containsLowercase(String password) {
    // Kode untuk memeriksa apakah password mengandung huruf kecil
    return password.contains(RegExp(r'[a-z]'));
  }
  bool _containsSymbol(String password) {
    // Kode untuk memeriksa apakah password mengandung simbol
    return password.contains(RegExp(r'[.!@#%^&*()]'));
  }
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? userName;
  String? password;
  String? email;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#283B71"),
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _registerUI(context),
          ),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _registerUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(100),
                bottomLeft: Radius.circular(100),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/123.png",
                    fit: BoxFit.contain,
                    width: 250,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 30, top: 50),
            child: Text(
              "Register",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FormHelper.inputFieldWidget(
              context,
              //const Icon(Icons.person),
              "Username",
              "Masukkan Username",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'Username HARUS diisi';
                } else if (onValidateVal.contains(' ')) {
                  return 'Username tidak boleh mengandung spasi';
                }

                return null;
              },
              (onSavedVal) => {
                userName = onSavedVal,
              },
              initialValue: "",
              obscureText: false,
              borderFocusColor: Colors.white,
              prefixIconColor: Colors.white,
              borderColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.7),
              borderRadius: 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FormHelper.inputFieldWidget(
              context,
              // const Icon(Icons.lock),
              "Password",
              "Masukkan Password",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'Password HARUS diisi';
                } else if (onValidateVal.length < 8) {
                  return 'Password harus terdiri dari minimal 8 karakter.';
                } else if (!_containsUppercase(onValidateVal) ||
                    !_containsLowercase(onValidateVal)) {
                  return 'Password harus terdiri dari kombinasi huruf besar dan huruf kecil';
                } else if (!_containsSymbol(onValidateVal) ||
                    !_containsSymbol(onValidateVal)) {
                  return 'Password harus terdapat 1 simbol dari .!@#%^&*()';
                }

                return null;
              },
              (onSavedVal) => {
                password = onSavedVal,
              },
              initialValue: "",
              obscureText: hidePassword,
              borderFocusColor: Colors.white,
              prefixIconColor: Colors.white,
              borderColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.7),
              borderRadius: 10,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.white.withOpacity(0.7),
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FormHelper.inputFieldWidget(
              context,
              // const Icon(Icons.mail),
              "Email",
              "Masukkan Email",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'Email HARUS diisi';
                } else if (!RegExp(r'^[\w-\.]+@(gmail\.com|outlook\.com|yahoo\.co\.id|yahoo\.com|student\.poltekssn\.ac\.id)$')
                    .hasMatch(onValidateVal)) {
                  return 'Format email tidak valid';
                }

                return null;
              },
              (onSavedVal) => {
                email = onSavedVal,
              },
              initialValue: "",
              borderFocusColor: Colors.white,
              prefixIconColor: Colors.white,
              borderColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.7),
              borderRadius: 10,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: FormHelper.submitButton(
              "Register",
              () {
                if (validateAndSave()) {
                  setState(() {
                    isApiCallProcess = true;
                  });

                  RegisterRequestModel model = RegisterRequestModel(
                    username: userName,
                    password: password,
                    email: email,
                  );

                  APIService.register(model).then(
                    (response) {
                      setState(() {
                        isApiCallProcess = false;
                      });

                      if (response.data != null) {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          "Pendaftaran akun berhasil. Silahkan login ke akun Anda",
                          "OK",
                          () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          },
                        );
                      } else {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          response.message,
                          "OK",
                          () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    },
                  );
                }
              },
              btnColor: HexColor("283B71"),
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 10,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
