import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class SensorDataScreen extends StatefulWidget {
  @override
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  late MqttServerClient _client;

  double ambientTemperature = 0.0;
  double humidity = 0.0;
  double bodyTemperature = 0.0;
  int potentiometer = 0;
  int steps = 0;
  double pulse = 0; // Nueva variable para pulsos
  double oximeter = 0.0; // Nueva variable para oxímetro

  @override
  void initState() {
    super.initState();
    _setupMqttClient();
  }

  void _setupMqttClient() async {
    _client = MqttServerClient('test.mosquitto.org', 'flutter_client');
    _client.logging(on: true);
    _client.keepAlivePeriod = 20;
    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;
    _client.onSubscribed = _onSubscribed;

    try {
      await _client.connect();
    } catch (e) {
      print('Exception: $e');
    }
  }

  void _onConnected() {
    print('Connected');
    _subscribeToTopics();
  }

  void _onDisconnected() {
    print('Disconnected');
  }

  void _onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  void _subscribeToTopics() {
    _client.subscribe('sensor/dht11/temperatura/out', MqttQos.atMostOnce);
    _client.subscribe('sensor/dht11/humedad/out', MqttQos.atMostOnce);
    _client.subscribe('sensor/potentiometer/value/out', MqttQos.atMostOnce);
    _client.subscribe('sensor/mlx/value/out', MqttQos.atMostOnce);
    _client.subscribe('sensor/steps/out', MqttQos.atMostOnce);
    _client.subscribe('sensor/max/bpm/out',
        MqttQos.atMostOnce); // Nueva suscripción para pulsos
    _client.subscribe('sensor/max/pox/out',
        MqttQos.atMostOnce); // Nueva suscripción para oxímetro

    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage message = c![0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      setState(() {
        switch (c[0].topic) {
          case 'sensor/dht11/temperatura/out':
            ambientTemperature = double.parse(payload);
            break;
          case 'sensor/dht11/humedad/out':
            humidity = double.parse(payload);
            break;
          case 'sensor/potentiometer/value/out':
            potentiometer = int.parse(payload);
            break;
          case 'sensor/mlx/value/out':
            bodyTemperature = double.parse(payload);
            break;
          case 'sensor/steps/out':
            steps = int.parse(payload);
            break;
          case 'sensor/max/bpm/out': // Actualiza la variable de pulsos
            pulse = double.parse(payload);
            break;
          case 'sensor/max/pox/out': // Actualiza la variable de oxímetro
            oximeter = double.parse(payload);
            break;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Data'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSensorCard(
                icon: Icons.thermostat,
                title: 'Temperatura Ambiente',
                value: '$ambientTemperature°C',
                color: Colors.orangeAccent,
              ),
              _buildSensorCard(
                icon: Icons.water_drop,
                title: 'Humedad',
                value: '$humidity%',
                color: Colors.lightBlueAccent,
              ),
              _buildSensorCard(
                icon: Icons.thermostat_auto,
                title: 'Temperatura Corporal',
                value: '$bodyTemperature°C',
                color: Colors.redAccent,
              ),
              _buildSensorCard(
                icon: Icons.directions_walk,
                title: 'Pasos',
                value: '$steps',
                color: Colors.greenAccent,
              ),
              _buildSensorCard(
                icon: Icons.linear_scale,
                title: 'Potenciómetro',
                value: '$potentiometer',
                color: Colors.purpleAccent,
              ),
              _buildSensorCard(
                icon: Icons.favorite,
                title: 'Pulsos',
                value: '$pulse bpm',
                color:
                    Colors.pinkAccent, // Puedes cambiar el color si lo deseas
              ),
              _buildSensorCard(
                icon: Icons.favorite_border,
                title: 'Oxímetro',
                value: '$oximeter%',
                color:
                    Colors.tealAccent, // Puedes cambiar el color si lo deseas
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorCard(
      {required IconData icon,
      required String title,
      required String value,
      required Color color}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  void dispose() {
    _client.disconnect();
    super.dispose();
  }
}
