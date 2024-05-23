import 'dart:convert';

import 'package:ai_converse_chatbot_app/components/api_key.dart';
import 'package:http/http.dart' as http;

class OpenSourceImage {
  static generateImage(String text, String size) async {
    try {
      final res = await http.post(Uri.parse("$baseUrl2/generations"),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer $openSourceKey"
          },
          body: jsonEncode({"prompt": text, "n": 1, "size": size}));
      if (res.statusCode == 200) {
        final String content = jsonDecode(res.body)["data"][0]["url"];
        content.trim();
        return content;
      }
      return "Something went wrong";
    } catch (e) {
      print(e.toString());
    }
  }
}
