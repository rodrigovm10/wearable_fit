import 'package:flutter/material.dart';
import 'package:mqtt_line_chart/models/data_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/mqtt_service.dart';

class HeartRateChartScreen extends StatefulWidget {
  final List<HeartRateData> data;

  HeartRateChartScreen({required this.data});

  @override
  _HeartRateChartScreenState createState() => _HeartRateChartScreenState();
}

class _HeartRateChartScreenState extends State<HeartRateChartScreen> {
  late MqttService _mqttService;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    super.initState();
    _mqttService =
        MqttService('test.mosquitto.org', 'clientId'); // Usa un clientId válido
    _mqttService.getSensorStream('sensor/termometro/out').listen((heartRate) {
      print('Termometro: $heartRate');
      setState(() {
        widget.data.add(HeartRateData(DateTime.now(), heartRate));
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
      appBar: AppBar(title: const Text('Gráfica del Termometro')),
      body: Container(
        color: Colors.white24,
        child: Center(
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(),
            series: <LineSeries<HeartRateData, DateTime>>[
              LineSeries<HeartRateData, DateTime>(
                  onRendererCreated: (ChartSeriesController controller) {
                    _chartSeriesController = controller;
                  },
                  dataSource: widget.data,
                  xValueMapper: (HeartRateData data, _) => data.time,
                  yValueMapper: (HeartRateData data, _) => data.heartRate,
                  color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
