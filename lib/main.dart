import 'package:flutter/material.dart'; // Importa el paquete de Material Design para Flutter
import 'package:mqtt_line_chart/screens/home_screen.dart'; // Importa la pantalla de inicio
import 'package:mqtt_line_chart/screens/menu_screen.dart'; // Importa la pantalla del menú (si se utiliza)

void main() {
  runApp(const MyApp()); // Ejecuta la aplicación usando el widget MyApp
}

// Clase principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor de la clase con clave opcional

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wearable Fit', // Título de la aplicación, que se usa en la barra de título del sistema
      theme: ThemeData(
        primarySwatch: Colors.blue, // Establece el color primario de la aplicación
        visualDensity: VisualDensity.adaptivePlatformDensity, // Ajusta la densidad visual para diferentes plataformas
      ),
      debugShowCheckedModeBanner: false, // Desactiva la banderola de modo de depuración en la esquina superior derecha
      home: const HomeScreen(), // Pantalla inicial de la aplicación
    );
  }
}
