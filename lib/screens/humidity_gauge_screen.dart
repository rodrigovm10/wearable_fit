import 'package:flutter/material.dart';
import 'package:mqtt_line_chart/models/data_models.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../services/mqtt_service.dart';

class HumidityGaugeScreen extends StatefulWidget {
  @override
  _HumidityGaugeScreenState createState() => _HumidityGaugeScreenState();
}

class _HumidityGaugeScreenState extends State<HumidityGaugeScreen> {
  late MqttService _mqttService;
  double _humidity = 0.0;

  @override
  void initState() {
    super.initState();
    //Asegúrate de que el servidor MQTT esté correcto y sin prefijo
    _mqttService =
        MqttService('test.mosquitto.org', 'clientId'); //Usa un clientId válido
    _mqttService.getSensorStream('sensor/dht11/humedad/out').listen((humidity) {
      print('Temperature received: $humidity'); //Línea de depuración
      setState(() {
        _humidity = humidity;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gauge de Humedad'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 100,
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0,
                    endValue: 100,
                    color: Colors.blueAccent,
                    startWidth: 10,
                    endWidth: 10,
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: _humidity,
                    needleColor: Colors.red,
                    knobStyle: KnobStyle(
                      knobRadius: 0.05,
                      color: Colors.red,
                    ),
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Container(
                      child: Text(
                        '${_humidity.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    angle: 90,
                    positionFactor: 0.5,
                  ),
                ],
                axisLineStyle: AxisLineStyle(
                  color: Colors.grey,
                  thickness: 0.1,
                ),
                majorTickStyle: MajorTickStyle(
                  length: 10,
                  thickness: 2,
                ),
                minorTickStyle: MinorTickStyle(
                  length: 5,
                  thickness: 1,
                ),
                showLabels: true,
                showTicks: true,
                labelOffset: 15,
                axisLabelStyle: GaugeTextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
