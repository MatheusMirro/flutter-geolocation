import 'package:flutter/material.dart';

/// Definição de cores utilizadas no aplicativo
class AppColors {
  static const Color primaryColor = Color(0xFF6200EA); // Roxo principal
  static const Color secondaryColor = Color(0xFF03DAC6); // Verde água secundário
  static const Color backgroundColor = Color(0xFFF5F5F5); // Fundo claro
  static const Color textColor = Color(0xFF000000); // Texto principal
  static const Color errorColor = Color(0xFFB00020); // Vermelho para erros

  // Outros exemplos de cores
  static const Color accentColor = Color(0xFFBB86FC); // Acento roxo claro
  static const Color buttonColor = Color(0xFF3700B3); // Cor para botões

  /// Gradientes
  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryColor, accentColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}