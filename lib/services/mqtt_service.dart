import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final MqttServerClient client;

  MqttService(String server, String clientId)
      : client = MqttServerClient(server, '') {
    final sanitizedClientId =
        clientId.isNotEmpty ? clientId : 'myUniqueClientId';

    client.logging(on: true);
    client.setProtocolV31();
    client.keepAlivePeriod = 30;

    // Si es necesario, habilitar conexiones seguras (SSL/TLS)
    // client.secure = true;
    // client.port = 8883;
    // client.onBadCertificate = (dynamic cert) => true;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(sanitizedClientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;
    client.connectTimeoutPeriod = 10000; // 10 segundos
  }

  // Método que retorna un stream de datos de temperatura
  Stream<double> getSensorStream(String topic) async* {
    try {
      await client.connect();
    } catch (e) {
      client.disconnect();
      print('Error connecting to MQTT broker: $e');
      return;
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe(topic, MqttQos.atLeastOnce);
      print('topic $topic');

      await for (final c in client.updates!) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final String pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        yield double.tryParse(pt) ?? 0.0;
      }
    } else {
      client.disconnect();
      print('Failed to connect to MQTT broker');
    }
  }

  // Métodos adicionales
  Stream<int> getStepsStream() async* {
    // Similar a getTemperatureStream, ajustado para el tópico de pasos
    // Agrega implementación aquí
  }

  Stream<int> getHeartRateStream() async* {
    // Similar a getTemperatureStream, ajustado para el tópico de frecuencia cardíaca
    // Agrega implementación aquí
  }

  void toggleVibration(bool status) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addByte(status ? 1 : 0);
    client.publishMessage(
        "control/vibration", MqttQos.exactlyOnce, builder.payload!);
  }

  void toggleBuzzer(bool status) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addByte(status ? 1 : 0);
    client.publishMessage(
        "control/buzzer", MqttQos.exactlyOnce, builder.payload!);
  }
}
