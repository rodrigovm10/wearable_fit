import 'package:flutter/material.dart';
import 'BuzzerChartScreen.dart';
import 'VibrationChartScreen.dart';
import 'package:mqtt_line_chart/screens/heart_rate_chart_screen.dart';
import 'package:mqtt_line_chart/screens/steps_chart_screen.dart';
import 'package:mqtt_line_chart/screens/temperature_chart_screen.dart';

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
                  builder: (context) => TemperatureChartScreen(data: []),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_run),
            title: const Text('Gráfica de Pasos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StepsChartScreen(data: []),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.face),
            title: const Text('Gráfica de Termometro'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HeartRateChartScreen(data: []),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.vibration),
            title: const Text('Control de Vibrador'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VibrationChartScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.audiotrack),
            title: const Text('Control de Buzzer'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BuzzerChartScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
