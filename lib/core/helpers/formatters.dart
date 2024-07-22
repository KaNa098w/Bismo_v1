import 'package:flutter/services.dart';

class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedText = newValue.text;

    if (formattedText.isNotEmpty) {
      // Удаление всех символов, кроме цифр
      formattedText = formattedText.replaceAll(RegExp(r'\D'), '');

      // Добавление "+" в начало строки
      formattedText = '+7${formattedText.substring(1)}';

      if (formattedText.length > 2) {
        // Вставка " (" после "+7"
        formattedText =
            '${formattedText.substring(0, 2)} (${formattedText.substring(2, formattedText.length)}';
      }

      if (formattedText.length > 7) {
        // Вставка ") " после следующих 3 цифр
        formattedText =
            '${formattedText.substring(0, 7)}) ${formattedText.substring(7, formattedText.length)}';
      }

      if (formattedText.length > 12) {
        // Вставка "-" после следующих 2 цифр
        formattedText =
            '${formattedText.substring(0, 12)}-${formattedText.substring(12, formattedText.length)}';
      }

      if (formattedText.length > 15) {
        // Вставка "-" после последних 2 цифр
        formattedText =
            '${formattedText.substring(0, 15)}-${formattedText.substring(15, formattedText.length)}';
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
