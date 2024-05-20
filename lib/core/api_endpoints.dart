class ApiEndpoint {
  static const baseUrl = 'http://api.bismo.kz/';

  static const api = '${baseUrl}server/hs';


  static const getOtpForSignIn = '$api/all/smsdetail';
  static const getCategories = '$api/provider/getskygroup';
  static const login = '$api/all/login';
  static const getProfile = '$api/all/getprofile';
  static const register = '$api/all/autorization';
  static const getGoods = '$api/product/getfullprice';
  static const setOrder = '$api/product/setorder';
  static const getAddress = '$api/all/user_adress';
  static const detalizationsOrder = '$api/product/detalizationsorder';
  static const getmyordersList = '$api/product/getmyorderslist';
  static const deleteOrder = '$api/product/deleteorder';
  static const setStatus = '$api/product/setstatus';// Добавлено
  static const List<String> urlsWithoutAuthorization = [];
}
