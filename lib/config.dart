class Config {
  static const String appName = "Passwordless";
  static const String apiURL = '27.112.78.59:5000'; //PROD_URL
  static const loginAPI = "/users/login";
  static const registerAPI = "/users/register";
  static const userProfileAPI = "/users/user-Profile";
  static const otpLoginAPI = "/users/otpLogin";
  static const otpVerifyAPI = "/users/otpVerify";
  static const fingerprintAuth = "/users/fingerprint";
}
