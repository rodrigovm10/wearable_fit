import 'package:flutter/material.dart'; // Importa el paquete de Flutter para la UI
import 'package:mqtt_line_chart/models/data_models.dart'; // Importa modelos de datos (aunque no se usan en este archivo)
import 'package:syncfusion_flutter_gauges/gauges.dart'; // Importa el paquete de Syncfusion para usar gauges (medidores)
import '../services/mqtt_service.dart'; // Importa el servicio MQTT

// Pantalla para mostrar el gauge del oxímetro
class OximetroGaugeScreen extends StatefulWidget {
  @override
  _OximetroGaugeScreenState createState() => _OximetroGaugeScreenState();
}

class _OximetroGaugeScreenState extends State<OximetroGaugeScreen> {
  late MqttService _mqttService; // Variable para el servicio MQTT
  double _humidity = 0.0; // Variable para almacenar el valor de humedad recibido

  @override
  void initState() {
    super.initState();
    // Inicializa el servicio MQTT con el servidor y el clientId
    _mqttService =
        MqttService('test.mosquitto.org', 'clientId'); // Usa un clientId válido
    // Escucha los datos del sensor de oxímetro desde el tópico especificado
    _mqttService.getSensorStream('sensor/max/pox/out').listen((humidity) {
      print('Temperature received: $humidity'); // Línea de depuración
      setState(() {
        _humidity = humidity; // Actualiza el valor de la humedad y redibuja el widget
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gauge de Oximetro'), // Título de la barra de aplicación
        backgroundColor: Colors.blueAccent, // Color de fondo de la barra de aplicación
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0), // Espaciado alrededor del contenedor
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0, // Valor mínimo del gauge
                maximum: 100, // Valor máximo del gauge
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0, // Valor inicial del rango
                    endValue: 100, // Valor final del rango
                    color: Colors.blueAccent, // Color del rango
                    startWidth: 10, // Ancho inicial del rango
                    endWidth: 10, // Ancho final del rango
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: _humidity, // Valor actual del needle
                    needleColor: Colors.red, // Color de la aguja
                    knobStyle: KnobStyle(
                      knobRadius: 0.05, // Radio del knob
                      color: Colors.red, // Color del knob
                    ),
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Container(
                      child: Text(
                        '${_humidity.toStringAsFixed(1)}', // Muestra el valor de humedad con un decimal
                        style: TextStyle(
                          fontSize: 20, // Tamaño del texto
                          fontWeight: FontWeight.bold, // Peso del texto
                        ),
                      ),
                    ),
                    angle: 90, // Ángulo de la anotación
                    positionFactor: 0.5, // Factor de posición
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
                  length: 5, // Longitud de las marcas secundarias
                  thickness: 1, // Grosor de las marcas secundarias
                ),
                showLabels: true, // Muestra etiquetas
                showTicks: true, // Muestra marcas
                labelOffset: 15, // Desplazamiento de las etiquetas
                axisLabelStyle: GaugeTextStyle(
                  color: Colors.black, // Color de las etiquetas del eje
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
