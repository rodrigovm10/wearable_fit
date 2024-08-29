import 'package:mqtt_client/mqtt_client.dart'; // Importa el cliente MQTT
import 'package:mqtt_client/mqtt_server_client.dart'; // Importa el cliente MQTT para servidor

// Clase que maneja la conexión y comunicación con el servidor MQTT
class MqttService {
  final MqttServerClient client; // Cliente MQTT del servidor

  // Constructor de la clase que inicializa el cliente MQTT
  MqttService(String server, String clientId)
      : client = MqttServerClient(server, '') {
    final sanitizedClientId =
        clientId.isNotEmpty ? clientId : 'myUniqueClientId'; // Asigna un clientId único

    client.logging(on: true); // Habilita el logging para depuración
    client.setProtocolV31(); // Establece el protocolo MQTT versión 3.1
    client.keepAlivePeriod = 30; // Configura el período de keep-alive en segundos

    // Configuración opcional para conexiones seguras (SSL/TLS)
    // client.secure = true;
    // client.port = 8883;
    // client.onBadCertificate = (dynamic cert) => true;

    // Crea el mensaje de conexión
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(sanitizedClientId) // Identificador del cliente
        .startClean() // Conexión limpia
        .withWillQos(MqttQos.atLeastOnce); // Configura el nivel de QoS del mensaje de voluntad

    client.connectionMessage = connMessage; // Establece el mensaje de conexión
    client.connectTimeoutPeriod = 10000; // Timeout de conexión en milisegundos (10 segundos)
  }

  // Método que retorna un stream de datos de temperatura del tópico especificado
  Stream<double> getSensorStream(String topic) async* {
    try {
      await client.connect(); // Intenta conectar al servidor MQTT
    } catch (e) {
      client.disconnect(); // Desconecta en caso de error
      print('Error connecting to MQTT broker: $e'); // Imprime el error de conexión
      return;
    }

    // Verifica si la conexión fue exitosa
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe(topic, MqttQos.atLeastOnce); // Suscribe al tópico con QoS 1
      print('topic $topic'); // Imprime el tópico al que se suscribe

      // Escucha los mensajes del cliente y procesa los datos
      await for (final c in client.updates!) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage; // Obtiene el mensaje publicado
        final String pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message); // Convierte el payload a string
        yield double.tryParse(pt) ?? 0.0; // Intenta convertir el string a double, default 0.0
      }
    } else {
      client.disconnect(); // Desconecta si no está conectado
      print('Failed to connect to MQTT broker'); // Imprime el fallo de conexión
    }
  }

  // Verifica si el cliente MQTT está conectado
  bool isConnected() {
    return client.connectionStatus!.state == MqttConnectionState.connected;
  }

  // Método para controlar el buzzer
  void toggleBuzzer(bool isBuzzing) {
    if (isConnected()) {
      const topic = 'buzzer/control'; // Tópico para el control del buzzer
      final payload = isBuzzing ? 'ON' : 'OFF'; // Crea el payload basado en el estado
      final builder = MqttClientPayloadBuilder(); // Constructor del payload
      builder.addString(payload); // Agrega el payload al builder

      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!); // Publica el mensaje
    } else {
      print('No se puede publicar, MQTT no está conectado.'); // Mensaje si no está conectado
    }
  }
}
