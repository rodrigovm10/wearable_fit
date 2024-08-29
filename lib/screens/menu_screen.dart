import 'package:flutter/material.dart';
import 'package:mqtt_line_chart/screens/humidity_gauge_screen.dart';
import 'package:mqtt_line_chart/screens/oximetro_gauge_screen.dart';
import 'package:mqtt_line_chart/screens/potentiometer_gauge_screen.dart';
import 'package:mqtt_line_chart/screens/pulse_chart_screen.dart';
import 'package:mqtt_line_chart/screens/sensor_data_screen.dart';
import 'BuzzerChartScreen.dart';
import 'package:mqtt_line_chart/screens/temperature_corp_chart_screen.dart';
import 'package:mqtt_line_chart/screens/temperature_chart_screen.dart';
import 'package:mqtt_line_chart/screens/steps_chart_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueGrey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wearable Fit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Monitoreo de Salud',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.thermostat),
            title: const Text('Gráfica de Temperatura'),
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
            leading: const Icon(Icons.thermostat),
            title: const Text('Gráfica de Temperatura Corporal'),
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
            leading: const Icon(Icons.favorite),
            title: const Text('Gráfica de Pulso'),
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
            leading: const Icon(Icons.water_drop),
            title: const Text('Gauge de Humedad'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HumidityGaugeScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.linear_scale_sharp),
            title: const Text('Gauge de Potenciometro'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PotentiometerGaugeScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('Gauge de Oximetro'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OximetroGaugeScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.monitor),
            title: const Text('Visualizar Datos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SensorDataScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
