bool isEmailValid(String? email) {
  final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  return emailRegex.hasMatch(email ?? "");
}

bool isPhoneNumberValid(String? phoneNumber) {
  final phoneNumberRegex = RegExp(r'^\+7 \(\d{3}\) \d{3}-\d{2}-\d{2}$');
  return phoneNumberRegex.hasMatch(phoneNumber ?? "");
}

bool validatePostalCode(String? value) {
  if (value == null) return false;
  const pattern = r'^[a-zA-Z0-9]{3,9}$';
  final regExp = RegExp(pattern);
  if (value.isEmpty) {
    return false;
  } else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}
