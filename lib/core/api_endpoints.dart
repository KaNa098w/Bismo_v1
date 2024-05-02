class ApiEndpoint {
  static const baseUrl = 'http://api.bismo.kz/';

  static const api = '${baseUrl}server/hs/all';

  static const getOtpForSignIn = '$api/smsdetail';
  static const login = '$api/login';

  static const List<String> urlsWithoutAuthorization = [
    "/api/product/book",
    "/api/product/review",
    "/api/product/category",
    "/api/user/auth/refresh-token",
    "/api/configuration",
  ];
}
