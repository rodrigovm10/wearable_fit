import 'package:flutter/material.dart';
import 'package:mqtt_line_chart/models/data_models.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../services/mqtt_service.dart';

// Pantalla que muestra el medidor de humedad
class HumidityGaugeScreen extends StatefulWidget {
  @override
  _HumidityGaugeScreenState createState() => _HumidityGaugeScreenState();
}

// Estado de la pantalla del medidor de humedad
class _HumidityGaugeScreenState extends State<HumidityGaugeScreen> {
  late MqttService _mqttService; // Servicio MQTT para la comunicación
  double _humidity = 0.0; // Valor actual de la humedad

  @override
  void initState() {
    super.initState();
    // Inicializa el servicio MQTT con el servidor y el clientId
    _mqttService =
        MqttService('test.mosquitto.org', 'clientId'); // Usa un clientId válido
    // Suscríbete al flujo de datos del sensor de humedad
    _mqttService.getSensorStream('sensor/dht11/humedad/out').listen((humidity) {
      print('Humidity received: $humidity'); // Línea de depuración para verificar el valor recibido
      setState(() {
        _humidity = humidity; // Actualiza el valor de la humedad
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gauge de Humedad'), // Título de la barra superior
        backgroundColor: Colors.blueAccent, // Color de fondo de la barra superior
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0), // Espaciado interno del contenedor
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0, // Valor mínimo del medidor
                maximum: 100, // Valor máximo del medidor
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0, // Valor inicial del rango
                    endValue: 100, // Valor final del rango
                    color: Colors.blueAccent, // Color del rango
                    startWidth: 10, // Ancho del inicio del rango
                    endWidth: 10, // Ancho del final del rango
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: _humidity, // Valor actual del puntero
                    needleColor: Colors.red, // Color de la aguja del medidor
                    knobStyle: KnobStyle(
                      knobRadius: 0.05, // Radio del pomo
                      color: Colors.red, // Color del pomo
                    ),
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Container(
                      child: Text(
                        '${_humidity.toStringAsFixed(1)}%', // Valor de la humedad con un decimal
                        style: TextStyle(
                          fontSize: 20, // Tamaño de la fuente
                          fontWeight: FontWeight.bold, // Negrita
                        ),
                      ),
                    ),
                    angle: 90, // Ángulo de la anotación
                    positionFactor: 0.5, // Factor de posición de la anotación
                  ),
                ],
                axisLineStyle: AxisLineStyle(
                  color: Colors.grey, // Color de la línea del eje
                  thickness: 0.1, // Grosor de la línea del eje
                ),
                majorTickStyle: MajorTickStyle(
                  length: 10, // Longitud de las marcas principales
                  thickness: 2, // Grosor de las marcas principales
                ),
                minorTickStyle: MinorTickStyle(
                  length: 5, // Longitud de las marcas menores
                  thickness: 1, // Grosor de las marcas menores
                ),
                showLabels: true, // Muestra las etiquetas
                showTicks: true, // Muestra las marcas
                labelOffset: 15, // Offset de las etiquetas
                axisLabelStyle: GaugeTextStyle(
                  color: Colors.black, // Color del texto de las etiquetas
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
