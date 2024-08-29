import 'package:flutter/material.dart'; // Importa el paquete de Flutter para la UI
import 'package:mqtt_client/mqtt_client.dart'; // Importa el paquete MQTT para la conexión
import 'package:mqtt_client/mqtt_server_client.dart'; // Importa el cliente MQTT para servidor

// Pantalla para mostrar datos de sensores
class SensorDataScreen extends StatefulWidget {
  @override
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  late MqttServerClient _client; // Variable para el cliente MQTT

  // Variables para almacenar los datos de los sensores
  double ambientTemperature = 0.0;
  double humidity = 0.0;
  double bodyTemperature = 0.0;
  int potentiometer = 0;
  int steps = 0;
  double pulse = 0; // Variable para pulsos
  double oximeter = 0.0; // Variable para oxímetro

  @override
  void initState() {
    super.initState();
    _setupMqttClient(); // Configura el cliente MQTT
  }

  void _setupMqttClient() async {
    _client = MqttServerClient('test.mosquitto.org', 'flutter_client'); // Crea el cliente MQTT
    _client.logging(on: true); // Activa el registro de eventos
    _client.keepAlivePeriod = 20; // Configura el periodo de vida del cliente
    _client.onConnected = _onConnected; // Callback cuando se conecta
    _client.onDisconnected = _onDisconnected; // Callback cuando se desconecta
    _client.onSubscribed = _onSubscribed; // Callback cuando se suscribe a un tópico

    try {
      await _client.connect(); // Intenta conectar al servidor MQTT
    } catch (e) {
      print('Exception: $e'); // Muestra un mensaje si ocurre una excepción
    }
  }

  void _onConnected() {
    print('Connected'); // Muestra un mensaje cuando el cliente está conectado
    _subscribeToTopics(); // Se suscribe a los tópicos
  }

  void _onDisconnected() {
    print('Disconnected'); // Muestra un mensaje cuando el cliente está desconectado
  }

  void _onSubscribed(String topic) {
    print('Subscribed to $topic'); // Muestra un mensaje cuando el cliente se suscribe a un tópico
  }

  void _subscribeToTopics() {
    // Se suscribe a varios tópicos MQTT
    _client.subscribe('sensor/dht11/temperatura/out', MqttQos.atMostOnce);
    _client.subscribe('sensor/dht11/humedad/out', MqttQos.atMostOnce);
    _client.subscribe('sensor/potentiometer/value/out', MqttQos.atMostOnce);
    _client.subscribe('sensor/mlx/value/out', MqttQos.atMostOnce);
    _client.subscribe('sensor/steps/out', MqttQos.atMostOnce);
    _client.subscribe('sensor/max/bpm/out', MqttQos.atMostOnce); // Suscripción para pulsos
    _client.subscribe('sensor/max/pox/out', MqttQos.atMostOnce); // Suscripción para oxímetro

    // Escucha los mensajes recibidos de los tópicos suscritos
    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage message = c![0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      setState(() {
        // Actualiza las variables de estado según el tópico recibido
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
        title: Text('Sensor Data'), // Título de la barra de aplicación
        backgroundColor: Colors.blue, // Color de fondo de la barra de aplicación
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Espaciado alrededor del contenedor
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
                color: Colors.pinkAccent, // Color para pulsos
              ),
              _buildSensorCard(
                icon: Icons.favorite_border,
                title: 'Oxímetro',
                value: '$oximeter%',
                color: Colors.tealAccent, // Color para oxímetro
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Construye una tarjeta de sensor con un icono, título, valor y color
  Widget _buildSensorCard(
      {required IconData icon,
      required String title,
      required String value,
      required Color color}) {
    return Card(
      elevation: 4, // Sombra de la tarjeta
      margin: EdgeInsets.symmetric(vertical: 10), // Espaciado vertical de las tarjetas
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color, // Color de fondo del círculo
          child: Icon(icon, color: Colors.white), // Icono dentro del círculo
        ),
        title: Text(title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Título
        subtitle: Text(value, style: TextStyle(fontSize: 24)), // Valor
      ),
    );
  }

  @override
  void dispose() {
    _client.disconnect(); // Desconecta el cliente MQTT al cerrar la pantalla
    super.dispose();
  }
}
