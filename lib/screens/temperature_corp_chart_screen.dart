import 'package:flutter/material.dart';
import 'package:mqtt_line_chart/models/data_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; //Asegúrate de agregar esta importación si aún no lo has hecho
import '../services/mqtt_service.dart';

class TemperatureCorpChartScreen extends StatefulWidget {
  final List<TemperatureData> data;

  TemperatureCorpChartScreen({required this.data});

  @override
  _TemperatureCorpChartScreenState createState() =>
      _TemperatureCorpChartScreenState();
}

class _TemperatureCorpChartScreenState
    extends State<TemperatureCorpChartScreen> {
  late MqttService _mqttService;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    super.initState();
    _mqttService =
        MqttService('test.mosquitto.org', 'clientId'); //Usa un clientId válido
    _mqttService.getSensorStream('sensor/mlx/value/out').listen((temperature) {
      print('Temperature received: $temperature');
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
      appBar: AppBar(
        title: const Text('Gráfica de Temperatura Corporal'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat('HH:mm:ss'),
            title: AxisTitle(text: 'Hora'),
            majorGridLines: MajorGridLines(width: 0),
            minorGridLines: MinorGridLines(width: 0),
            axisLine: AxisLine(width: 0),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Temperatura (°C)'),
            labelFormat: '{value} °C',
            majorGridLines: MajorGridLines(width: 1),
            minorGridLines: MinorGridLines(width: 0),
            axisLine: AxisLine(width: 0),
          ),
          series: <LineSeries<TemperatureData, DateTime>>[
            LineSeries<TemperatureData, DateTime>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              dataSource: widget.data,
              xValueMapper: (TemperatureData data, _) => data.time,
              yValueMapper: (TemperatureData data, _) => data.temperature,
              color: Colors.red,
              width: 2,
              markerSettings: MarkerSettings(
                isVisible: true,
                color: Colors.red,
                borderColor: Colors.white,
                borderWidth: 2,
              ),
            ),
          ],
          tooltipBehavior: TooltipBehavior(enable: true),
          zoomPanBehavior: ZoomPanBehavior(
            enablePanning: true,
            enablePinching: true,
            zoomMode: ZoomMode.xy,
          ),
        ),
      ),
    );
  }
}
