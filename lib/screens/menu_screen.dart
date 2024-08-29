import 'package:flutter/material.dart'; // Importa el paquete de Flutter para la UI
import 'package:mqtt_line_chart/screens/humidity_gauge_screen.dart'; // Importa la pantalla del medidor de humedad
import 'package:mqtt_line_chart/screens/oximetro_gauge_screen.dart'; // Importa la pantalla del medidor de oximetro
import 'package:mqtt_line_chart/screens/potentiometer_gauge_screen.dart'; // Importa la pantalla del medidor de potenciometro
import 'package:mqtt_line_chart/screens/pulse_chart_screen.dart'; // Importa la pantalla de la gráfica de pulso
import 'package:mqtt_line_chart/screens/sensor_data_screen.dart'; // Importa la pantalla para visualizar datos del sensor
import 'BuzzerChartScreen.dart'; // Importa la pantalla de la gráfica del buzzer
import 'package:mqtt_line_chart/screens/temperature_corp_chart_screen.dart'; // Importa la pantalla de la gráfica de temperatura corporal
import 'package:mqtt_line_chart/screens/temperature_chart_screen.dart'; // Importa la pantalla de la gráfica de temperatura
import 'package:mqtt_line_chart/screens/steps_chart_screen.dart'; // Importa la pantalla de la gráfica de pasos

// Pantalla del menú de navegación lateral
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key}); // Constructor de la clase

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Elimina el padding por defecto
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey, // Color de fondo del encabezado
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueGrey], // Gradiente de colores
                begin: Alignment.topLeft, // Dirección del gradiente
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Alinea los elementos al inicio de la columna
              children: [
                const Text(
                  'Wearable Fit',
                  style: TextStyle(
                    color: Colors.white, // Color del texto
                    fontSize: 28, // Tamaño del texto
                    fontWeight: FontWeight.bold, // Peso del texto
                  ),
                ),
                const SizedBox(height: 10), // Espacio vertical
                Text(
                  'Monitoreo de Salud',
                  style: TextStyle(
                    color: Colors.white70, // Color del texto
                    fontSize: 18, // Tamaño del texto
                  ),
                ),
              ],
            ),
          ),
          // Cada ListTile representa un elemento del menú
          ListTile(
            leading: const Icon(Icons.thermostat), // Icono del elemento
            title: const Text('Gráfica de Temperatura'), // Título del elemento
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TemperatureChartScreen(
                    data: [], // Considera inicializar con datos de ejemplo si es necesario
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.thermostat), // Icono del elemento
            title: const Text('Gráfica de Temperatura Corporal'), // Título del elemento
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TemperatureCorpChartScreen(
                    data: [], // Considera inicializar con datos de ejemplo si es necesario
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite), // Icono del elemento
            title: const Text('Gráfica de Pulso'), // Título del elemento
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PulseChartScreen(
                    data: [], // Considera inicializar con datos de ejemplo si es necesario
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.water_drop), // Icono del elemento
            title: const Text('Gauge de Humedad'), // Título del elemento
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HumidityGaugeScreen(), // Navega a la pantalla del medidor de humedad
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.linear_scale_sharp), // Icono del elemento
            title: const Text('Gauge de Potenciometro'), // Título del elemento
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PotentiometerGaugeScreen(), // Navega a la pantalla del medidor de potenciometro
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border), // Icono del elemento
            title: const Text('Gauge de Oximetro'), // Título del elemento
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OximetroGaugeScreen(), // Navega a la pantalla del medidor de oximetro
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.monitor), // Icono del elemento
            title: const Text('Visualizar Datos'), // Título del elemento
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SensorDataScreen(), // Navega a la pantalla para visualizar datos del sensor
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
