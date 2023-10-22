import 'dart:async';

import 'package:chat_gpt_api/app/chat_gpt.dart';
import 'package:chat_gpt_api/app/model/data_model/chat/chat_completion.dart';
import 'package:chat_gpt_api/app/model/data_model/chat/chat_request.dart';
import 'package:chat_gpt_api/app/model/models.dart';
import 'package:dio/dio.dart';

class Api {
  // instance of the dio http plugin
  final Dio _dio = Dio();

  // base url of the open api
  final String _baseUrl = 'https://api.openai.com/v1';

  // headers for the api call
  final Map<String, dynamic> _headers = {
    Headers.contentTypeHeader: 'application/json',
    'Authorization': 'Bearer ${ChatGPT.token}',
  };

  final StreamController<Completion> _controller =
      StreamController<Completion>.broadcast();

  /// Method to do text completion based on the given
  ///
  /// input prompt
  /// [request] is a required parameter
  /// the return type can be null
  ///
  Future<Completion?> textCompletion({
    required CompletionRequest request,
  }) async {
    String url = '$_baseUrl/completions';
    try {
      Response response = await _dio.post(
        url,
        data: request.toJson(),
        options: Options(
          headers: _headers,
        ),
      );

      return Completion.fromMap(response.data);
    } on DioError {
      return null;
    }
  }

  Future<ChatCompletion?> chatCompletion({
    required ChatRequest request,
  }) async {
    String url = '$_baseUrl/chat/completions';
    try {
      Response response = await _dio.post(
        url,
        data: request.toJson(),
        options: Options(
          headers: _headers,
        ),
      );

      return ChatCompletion.fromMap(response.data);
    } on DioError {
      return null;
    }
  }

  /// Method to generate the image(s) based on the given
  ///
  /// input prompt
  /// [request] is a required parameter
  /// the return type can be null
  Future<Images?> generateImage({
    required ImageRequest request,
  }) async {
    String url = '$_baseUrl/images/generations';
    Response response = await _dio.post(
      url,
      data: request.toJson(),
      options: Options(
        headers: _headers,
      ),
    );
    return Images.fromJson(response.data);
  }
}
