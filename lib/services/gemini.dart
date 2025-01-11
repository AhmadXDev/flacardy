import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Gemini {
  Future<dynamic> sendRequest(String prompt) async {
    final String apiKey = dotenv.env['geminiKey'] ?? '';
    if (apiKey.isEmpty) throw Exception("Gemini API key is missing.");

    final String link =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";
    final Uri uri = Uri.parse(link);

    var headers = {"Content-Type": "application/json"};
    var body = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    };

    final response =
        await http.post(uri, headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Response Data: $data");

      // Ensure the expected structure exists
      if (data["candidates"] == null ||
          data["candidates"].isEmpty ||
          data["candidates"][0]["content"] == null ||
          data["candidates"][0]["content"]["parts"] == null ||
          data["candidates"][0]["content"]["parts"].isEmpty) {
        throw Exception("Invalid response format or missing fields.");
      }

      // Parse the content as text
      String textResponse =
          data["candidates"][0]["content"]["parts"][0]["text"];
      String cleanedText =
          textResponse.replaceAll("```json", "").replaceAll("```", "").trim();
      print("Cleaned Text: $cleanedText");
      return json.decode(cleanedText);
    } else {
      throw Exception("Failed to get data: ${response.body}");
    }
  }

  generateFlashCards(String title) async {
    final String structuredPrompt = '''
      You are tasked with creating 10 flashcards for the title: "$title". 

      Please generate a list of flashcards in JSON format where each flashcard has the following structure:
      {
        "front": "The front text of the flashcard",
        "back": "The back text of the flashcard"
      }

      Ensure the response is a JSON array of objects, and each object contains exactly the "front" and "back" fields.
      ''';

    return await sendRequest(structuredPrompt);
  }
}
