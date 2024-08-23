import 'package:flutter/material.dart';
import '../services/mqtt_service.dart';

class VibrationChartScreen extends StatefulWidget {
  const VibrationChartScreen({Key? key}) : super(key: key);

  @override
  _VibrationChartScreenState createState() => _VibrationChartScreenState();
}

class _VibrationChartScreenState extends State<VibrationChartScreen> {
  late MqttService _mqttService;
  bool isVibrating = false;

  @override
  void initState() {
    super.initState();
    _mqttService = MqttService('broker.hivemq.com', 'clientId'); // Usa un clientId válido
  }

  void _toggleVibration() {
    setState(() {
      isVibrating = !isVibrating;
    });
    _mqttService.toggleVibration(isVibrating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control de Vibrador')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/sonido.jpg', // Cambia la ruta a la imagen que deseas usar
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isVibrating ? "Vibrador Encendido" : "Vibrador Apagado",
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _toggleVibration,
                  child: Text(isVibrating ? "Apagar Vibrador" : "Encender Vibrador"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
