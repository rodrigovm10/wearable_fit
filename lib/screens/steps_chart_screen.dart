import 'package:flutter/material.dart';
import 'package:mqtt_line_chart/models/data_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/mqtt_service.dart';

class StepsChartScreen extends StatefulWidget {
  final List<StepsData> data;

  StepsChartScreen({required this.data});

  @override
  _StepsChartScreenState createState() => _StepsChartScreenState();
}

class _StepsChartScreenState extends State<StepsChartScreen> {
  late MqttService _mqttService;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    super.initState();
    // Asegúrate de que el servidor MQTT esté correcto y sin prefijo
    _mqttService =
        MqttService('broker.hivemq.com', 'clientId'); // Usa un clientId válido
    _mqttService.getSensorStream('sensor/steps/out').listen((steps) {
      print('Temperature received: $steps');
      setState(() {
        widget.data.add(StepsData(DateTime.now(), steps));
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
      appBar: AppBar(title: const Text('Gráfica de Pasos')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/paisajecorrer.jpg', // Cambia la ruta a la imagen que deseas usar
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              series: <LineSeries<StepsData, DateTime>>[
                LineSeries<StepsData, DateTime>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: widget.data,
                    xValueMapper: (StepsData data, _) => data.time,
                    yValueMapper: (StepsData data, _) => data.steps,
                    color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
