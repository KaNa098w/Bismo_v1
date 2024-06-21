class ApiEndpoint {
  static const baseUrl = 'http://188.95.95.122:2223/';

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
  static const setStatus = '$api/product/setstatus';
  static const getAddresses = '$api/all/user_adress';
  static const addAddress = '$api/all/add_adress';
  static const deleteAddress = '$api/all/delete_adress';
  static const search = '$api/product/searching';
  static const newGoods = '$api/product/newgoods';
  static const promocode = '$api/all/promokod';

  static const List<String> urlsWithoutAuthorization = [];
}
