import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sci_space_x/core/models/chat_model.dart';
import 'package:sci_space_x/core/models/models_model.dart';
import 'package:sci_space_x/core/services/api_service.dart';

void main() {
  testWidgets('ApiService Test', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // Arrange
      const message = 'Hello';
      const modelId = 'your_model_id';

      // Act
      final models = await ApiService.getModels();
      final chatModels =
          await ApiService.sendMessageGPT(message: message, modelId: modelId);
      final chatModels2 =
          await ApiService.sendMessage(message: message, modelId: modelId);

      // Assert
      expect(models, isA<List<ModelsModel>>());
      expect(chatModels, isA<List<ChatModel>>());
      expect(chatModels2, isA<List<ChatModel>>());
    });
  });
}
