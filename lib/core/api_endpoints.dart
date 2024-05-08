class ApiEndpoint {
  static const baseUrl = 'http://api.bismo.kz/';

  static const api = '${baseUrl}server/hs/all';

  static const getOtpForSignIn = '$api/smsdetail';
  static const getCategories = '${baseUrl}server/hs/provider/getskygroup';
  static const login = '$api/login';
  static const getProfile = '$api/getprofile';
  static const register = '$api/autorization';

  static const List<String> urlsWithoutAuthorization = [];
}
