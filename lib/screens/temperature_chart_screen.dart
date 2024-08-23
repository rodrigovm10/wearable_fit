import 'package:flutter/material.dart';
import 'package:mqtt_line_chart/models/data_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/mqtt_service.dart';

class TemperatureChartScreen extends StatefulWidget {
  final List<TemperatureData> data;

  TemperatureChartScreen({required this.data});

  @override
  _TemperatureChartScreenState createState() => _TemperatureChartScreenState();
}

class _TemperatureChartScreenState extends State<TemperatureChartScreen> {
  late MqttService _mqttService;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    super.initState();
    // Asegúrate de que el servidor MQTT esté correcto y sin prefijo
    _mqttService =
        MqttService('broker.hivemq.com', 'clientId'); // Usa un clientId válido
    _mqttService
        .getSensorStream('sensor/temperature/out')
        .listen((temperature) {
      print('Temperature received: $temperature'); // Línea de depuración
      setState(() {
        widget.data.add(TemperatureData(DateTime.now(), temperature));
        if (widget.data.length > 20) {
          widget.data.removeAt(0);
        }
        _chartSeriesController.updateDataSource(
            addedDataIndex: widget.data.length - 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gráfica de Temperatura')),
      body: Container(
        color: Colors.white24,
        child: Center(
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(),
            series: <LineSeries<TemperatureData, DateTime>>[
              LineSeries<TemperatureData, DateTime>(
                  onRendererCreated: (ChartSeriesController controller) {
                    _chartSeriesController = controller;
                  },
                  dataSource: widget.data,
                  xValueMapper: (TemperatureData data, _) => data.time,
                  yValueMapper: (TemperatureData data, _) => data.temperature,
                  color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
