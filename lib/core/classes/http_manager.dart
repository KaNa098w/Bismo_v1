import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bismo/core/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class Http extends HttpManager {
  Http({String? baseUrl, Map<String, dynamic>? headers})
      : super(baseUrl!, headers!);
}

class HttpManager {
  final Dio _dio = Dio();

  HttpManager([String baseUrl = '', Map<String, dynamic>? headers]) {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = headers;
    _dio.options.preserveHeaderCase = true;

    // how to solve flutter CERTIFICATE_VERIFY_FAILED error while performing a POST request?
    // if (kIsWeb) {
    //   _dio.options.headers['content-Type'] = '*';
    //   _dio.options.headers['Access-Control-Allow-Methods'] = '*';
    // }

    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // _dio.interceptors.clear();
    _dio.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));

    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      // AppCache ac = AppCache();
      // var isLogin = await ac.isLogin();
      // if (isLogin) {
      // var oauth2tokenInfo = await ac.getTokens();

      if (ApiEndpoint.urlsWithoutAuthorization.contains(options.uri.path)) {
        return handler.next(options);
      } else {
        // options.headers.putIfAbsent(
        //     'Authorization', () => 'Basic d2ViOjc3NTc0OTk0NTFkbA==');
        String username = 'web';
        String password = '7757499451dl';
        options.headers.putIfAbsent('Authorization',
            () => 'Basic ${base64.encode(utf8.encode('$username:$password'))}');
        return handler.next(options);
      }
      // }
      // log("dio request started");
      // print(options.headers);
      // return handler.next(options);
    }, onResponse: (response, handler) {
      handler.next(response);
    }, onError: (DioException err, handler) async {
      if (err.response != null) {
        handler.reject(err);
      } else {
        handler.reject(err);
      }
    }));
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? progress,
  }) async {
    Response? response;
    log("request url:$url");
    try {
      response = await _dio.get(
        url,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: progress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? sendProgress,
    Function(int progress, int total)? receiveProgress,
  }) async {
    log("request url:$url");
    Response? response;
    try {
      response = await _dio.post(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? sendProgress,
    Function(int progress, int total)? receiveProgress,
  }) async {
    log("request url:$url");
    Response? response;
    try {
      response = await _dio.put(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? sendProgress,
    Function(int progress, int total)? receiveProgress,
  }) async {
    log("request url:$url");
    Response? response;
    try {
      response = await _dio.patch(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
  }) async {
    log("request url:$url");
    Response? response;
    try {
      response = await _dio.delete(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> download(
    String url,
    dynamic savePath, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? receiveProgress,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
  }) async {
    Response? response;
    try {
      response = await _dio.download(
        url,
        savePath,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: receiveProgress,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> head(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
  }) async {
    Response? response;
    try {
      response = await _dio.head(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> fetch(RequestOptions requestOptions) async {
    Response? response;
    try {
      response = await _dio.fetch(requestOptions);
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> getUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.getUri(
        uri,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> headUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.headUri(
        uri,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> postUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? sendProgress,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.postUri(
        uri,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: sendProgress,
        onReceiveProgress: receiveProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> putUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? sendProgress,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.putUri(
        uri,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: sendProgress,
        onReceiveProgress: receiveProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> patchUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? sendProgress,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.patchUri(
        uri,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: sendProgress,
        onReceiveProgress: receiveProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> deleteUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? sendProgress,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.deleteUri(
        uri,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> downloadUri(Uri uri, dynamic savePath,
      {dynamic data,
      Options? options,
      CancelToken? cancelToken,
      void Function(int progress, int total)? receiveProgress,
      bool deleteOnError = true,
      String lengthHeader = Headers.contentLengthHeader}) async {
    Response? response;
    try {
      response = await _dio.downloadUri(
        uri,
        savePath,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
        data: data,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> request(
    String path, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? receiveProgress,
    void Function(int progress, int total)? sendProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.request(
        path,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> requestUri(
    Uri uri, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? receiveProgress,
    void Function(int progress, int total)? sendProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.requestUri(
        uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }
}
