import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<dynamic> registerUser(
    String username,
    String email,
    String pwd,
    String firstName,
    String lastName,
  ) async {
    try {
      Response response = await _dio.post(
          'https://v70o6r5wlb.execute-api.us-east-1.amazonaws.com/dev/auth/signup',
          data: {
            "username": username,
            "password": pwd,
            "email": email,
            "firstName": firstName,
            "lastName": lastName
          },
          options: Options(headers: {
            'x-api-key': 'OHHxlXIgwo9pC8p0wXKfGaSmRcgja81w2hwpiB7y'
          }));
      return response.data;
    } on DioError catch (e) {
      return e.response.data;
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        'https://v70o6r5wlb.execute-api.us-east-1.amazonaws.com/dev/auth/signin',
        data: {'username': email, 'password': password, "device": "WINDOWS"},
        options: Options(
            headers: {'x-api-key': 'OHHxlXIgwo9pC8p0wXKfGaSmRcgja81w2hwpiB7y'}),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response.data;
    }
  }

  Future<dynamic> getGroups() async {
    try {
      Response response = await _dio.get(
        'https://v70o6r5wlb.execute-api.us-east-1.amazonaws.com/dev/group/getall',
        options: Options(
            headers: {'x-api-key': 'OHHxlXIgwo9pC8p0wXKfGaSmRcgja81w2hwpiB7y'}),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response.data;
    }
  }

  Future<dynamic> createGroup(String accessToken) async {
    try {
      Response response = await _dio.get(
        'https://v70o6r5wlb.execute-api.us-east-1.amazonaws.com/dev/group/create',
        options: Options(headers: {
          'x-api-key': 'OHHxlXIgwo9pC8p0wXKfGaSmRcgja81w2hwpiB7y',
          'Authorization': '$accessToken'
        }),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response.data;
    }
  }

  Future<dynamic> getUserProfileData(String username) async {
    try {
      Response response = await _dio.get(
        'https://v70o6r5wlb.execute-api.us-east-1.amazonaws.com/dev/user/getuser/' +
            username,
        options: Options(
            headers: {'x-api-key': 'OHHxlXIgwo9pC8p0wXKfGaSmRcgja81w2hwpiB7y'}),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response.data;
    }
  }

  Future<dynamic> getUserFeed(String accessToken, String userName) async {
    try {
      Response response = await _dio.post(
        'https://v70o6r5wlb.execute-api.us-east-1.amazonaws.com/dev/user/feed',
        data: {'username': userName},
        options: Options(headers: {
          'x-api-key': 'OHHxlXIgwo9pC8p0wXKfGaSmRcgja81w2hwpiB7y',
          'Authorization': '$accessToken'
        }),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response.data;
    }
  }

  Future<dynamic> createPost(
      String accessToken, String groupId, String title, String content) async {
    try {
      Response response = await _dio.post(
        'https://v70o6r5wlb.execute-api.us-east-1.amazonaws.com/dev/group/post/create',
        data: {"groupId": groupId, "title": title, "content": content},
        options: Options(headers: {
          'x-api-key': 'OHHxlXIgwo9pC8p0wXKfGaSmRcgja81w2hwpiB7y',
          'Authorization': '$accessToken'
        }),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response.data;
    }
  }

  Future<dynamic> joinGroup(String accessToken, String groupId) async {
    try {
      Response response = await _dio.post(
        'https://v70o6r5wlb.execute-api.us-east-1.amazonaws.com/dev/group/join',
        data: {
          "groupId": groupId,
        },
        options: Options(headers: {
          'x-api-key': 'OHHxlXIgwo9pC8p0wXKfGaSmRcgja81w2hwpiB7y',
          'Authorization': '$accessToken'
        }),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response.data;
    }
  }
}
