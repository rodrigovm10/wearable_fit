import 'package:flutter/material.dart';
import 'package:mqtt_line_chart/screens/menu_screen.dart';

// Pantalla principal de la aplicación
class HomeScreen extends StatelessWidget {
  // Constructor de la clase
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior de la aplicación
      appBar: AppBar(
        title: const Text('Wearable Fit'), // Título de la barra superior
        actions: [
          // Botón de información en la barra superior
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Muestra un diálogo de información cuando se presiona el botón
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Información'),
                    content: const Text('Seleccione una gráfica para visualizar los datos.'),
                    actions: [
                      // Botón para cerrar el diálogo
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      // Cuerpo de la pantalla principal
      body: const HomePage(),
      // Menú lateral de la aplicación
      drawer: const MenuScreen(),
    );
  }
}

// Pantalla principal del contenido de la aplicación
class HomePage extends StatelessWidget {
  // Constructor de la clase
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0), // Espaciado interno del contenedor
      decoration: BoxDecoration(
        // Fondo con imagen y filtro de color
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'), // Imagen de fondo
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Contenedor para el título de la aplicación
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9), // Fondo con opacidad
              borderRadius: BorderRadius.circular(15), // Bordes redondeados
              boxShadow: [
                // Sombra del contenedor
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Fila para el icono y el título
                Row(
                  children: [
                    Icon(Icons.fitness_center, color: Colors.blueAccent, size: 40), // Icono de fitness
                    const SizedBox(width: 10), // Espacio entre el icono y el texto
                    Text(
                      'Fit Wearable', // Texto del título
                      style: TextStyle(
                        fontSize: 48, // Tamaño de la fuente
                        fontWeight: FontWeight.bold, // Negrita
                        color: Colors.blueAccent, // Color del texto
                        letterSpacing: 1.5, // Espaciado entre letras
                        shadows: [
                          // Sombra del texto
                          Shadow(
                            offset: Offset(3, 3),
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center, // Alineación del texto
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Espacio debajo del título
                Divider(color: Colors.blueAccent, thickness: 2), // Línea divisoria
              ],
            ),
          ),
          const SizedBox(height: 30), // Espacio entre los contenedores
          // Contenedor para la visión de la aplicación
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9), // Fondo con opacidad
              borderRadius: BorderRadius.circular(15), // Bordes redondeados
              boxShadow: [
                // Sombra del contenedor
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fila para el icono y el título de la visión
                Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.blueAccent, size: 30), // Icono de visión
                    const SizedBox(width: 10), // Espacio entre el icono y el texto
                    Text(
                      'Visión', // Texto del título de visión
                      style: TextStyle(
                        fontSize: 28, // Tamaño de la fuente
                        fontWeight: FontWeight.bold, // Negrita
                        color: Colors.blueAccent, // Color del texto
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15), // Espacio debajo del título
                Text(
                  'Nuestra visión es redefinir la experiencia del ejercicio y las actividades físicas, proporcionando un dispositivo wearable que no solo registre el rendimiento, sino que también motive y guíe a los usuarios de manera personalizada e inteligente. Este dispositivo está diseñado para superar las barreras comunes que enfrentan las personas activas, tales como el monitoreo preciso del rendimiento, la falta de motivación y la dificultad para personalizar sus entrenamientos según sus necesidades individuales a través de una app.',
                  style: TextStyle(
                    fontSize: 18, // Tamaño de la fuente
                    height: 1.6, // Altura de la línea
                    color: Colors.black87, // Color del texto
                  ),
                  textAlign: TextAlign.justify, // Alineación del texto
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
