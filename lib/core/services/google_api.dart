import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> translateText({
  required String text,
  required String sourceLanguage,
  required String targetLanguage,
}) async {
  var url = Uri.https('translate-plus.p.rapidapi.com', '/translate');
  var headers = {
    'content-type': 'application/json',
    'X-RapidAPI-Key': '2fa5c7e382msh33e1debd18eb0abp1b1270jsn43b2d21c5ccc',
    'X-RapidAPI-Host': 'translate-plus.p.rapidapi.com'
  };

  var body = jsonEncode({
    'text': text,
    'source': sourceLanguage,
    'target': targetLanguage,
  });

  var response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    var responseBody = jsonDecode(response.body);
    return responseBody['translatedText'];
  } else {
    throw Exception('Failed to translate text');
  }
}
