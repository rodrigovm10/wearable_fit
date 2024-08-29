// import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:mqtt_line_chart/services/mqtt_service.dart';

// class SensorDataScreen extends StatefulWidget {
//   @override
//   _SensorDataScreenState createState() => _SensorDataScreenState();
// }

// class _SensorDataScreenState extends State<SensorDataScreen> {
//   late MqttService _client;

//   double _ambientTemperature = 0.0;
//   double _humidity = 0.0;
//   double _potentiometer = 0.0;
//   double _bodyTemperature = 0.0;
//   double _steps = 0.0;
//   bool _buttonState = false;

//   @override
//   void initState() {
//     super.initState();
//     connectMqtt();
//   }

//   void connectMqtt() async {
//     _client = MqttService('test.mosquitto.org', 'texto123o');
//     await _client.connect();

//     _client
//         .getValueStreamTemperature('sensor/dht11/temperatura')
//         .listen((ambientTemperature) {
//       setState(() {
//         _ambientTemperature = ambientTemperature;
//         print('Temperatura Ambiente: $ambientTemperature');
//       });
//     });

//     _client.getValueStream('sensor/dht11/humedad').listen((humidity) {
//       setState(() {
//         _humidity = humidity;
//         print('Humedad: $humidity');
//       });
//     });

//     _client
//         .getValueStream('sensor/potentiometer/value')
//         .listen((potentiometer) {
//       setState(() {
//         _potentiometer = potentiometer;
//         print('Potenciómetro: $potentiometer');
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sensor Data'),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               _buildSensorCard(
//                 icon: Icons.thermostat,
//                 title: 'Temperatura Ambiente',
//                 value: '$_ambientTemperature°C',
//                 color: Colors.orangeAccent,
//               ),
//               _buildSensorCard(
//                 icon: Icons.water_drop,
//                 title: 'Humedad',
//                 value: '$_humidity%',
//                 color: Colors.lightBlueAccent,
//               ),
//               _buildSensorCard(
//                 icon: Icons.thermostat_auto,
//                 title: 'Temperatura Corporal',
//                 value: '$_bodyTemperature°C',
//                 color: Colors.redAccent,
//               ),
//               _buildSensorCard(
//                 icon: Icons.directions_walk,
//                 title: 'Pasos',
//                 value: '$_steps',
//                 color: Colors.greenAccent,
//               ),
//               _buildSensorCard(
//                 icon: Icons.linear_scale,
//                 title: 'Potenciómetro',
//                 value: '$_potentiometer',
//                 color: Colors.purpleAccent,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSensorCard(
//       {required IconData icon,
//       required String title,
//       required String value,
//       required Color color}) {
//     return Card(
//       elevation: 4,
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: color,
//           child: Icon(icon, color: Colors.white),
//         ),
//         title: Text(title,
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//         subtitle: Text(value, style: TextStyle(fontSize: 24)),
//       ),
//     );
//   }
// }
