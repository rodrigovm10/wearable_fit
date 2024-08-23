import 'package:flutter/material.dart';
import '../services/mqtt_service.dart';

class BuzzerChartScreen extends StatefulWidget {
  const BuzzerChartScreen({Key? key}) : super(key: key);

  @override
  _BuzzerChartScreenState createState() => _BuzzerChartScreenState();
}

class _BuzzerChartScreenState extends State<BuzzerChartScreen> {
  late MqttService _mqttService;
  bool isBuzzing = false;

  @override
  void initState() {
    super.initState();
    _mqttService = MqttService('broker.hivemq.com', 'clientId'); // Usa un clientId válido
  }

  void _toggleBuzzer() {
    setState(() {
      isBuzzing = !isBuzzing;
    });
    _mqttService.toggleBuzzer(isBuzzing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control de Buzzer')),
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
                  isBuzzing ? "Buzzer Encendido" : "Buzzer Apagado",
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _toggleBuzzer,
                  child: Text(isBuzzing ? "Apagar Buzzer" : "Encender Buzzer"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
