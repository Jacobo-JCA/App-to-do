import 'package:flutter/material.dart';

class AppStyles {
  // Color de fondo para la app
  static const Color backgroundColor = Color(0xFFF4F4F9);
  
  // Color principal de la app, más neutral
  static const Color primaryColor = Color(0xFF00796B);
  
  // Estilo del contenedor de las tareas (más moderno)
  static BoxDecoration taskContainerDecoration = BoxDecoration(
    color: Colors.white, 
    borderRadius: BorderRadius.circular(10),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0, 4),
        blurRadius: 10,
      ),
    ],
  );
}
