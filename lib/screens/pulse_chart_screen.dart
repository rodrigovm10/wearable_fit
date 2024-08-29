import 'package:flutter/material.dart';
import 'package:mqtt_line_chart/models/data_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; // Asegúrate de agregar esta importación si aún no lo has hecho
import '../services/mqtt_service.dart';

class PulseChartScreen extends StatefulWidget {
  final List<TemperatureData> data;

  PulseChartScreen({required this.data});

  @override
  _PulseChartScreenState createState() => _PulseChartScreenState();
}

class _PulseChartScreenState extends State<PulseChartScreen> {
  late MqttService _mqttService;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    super.initState();
    _mqttService =
        MqttService('test.mosquitto.org', 'clientId'); // Usa un clientId válido
    _mqttService.getSensorStream('sensor/max/bpm/out').listen((bpm) {
      print('BPM received: $bpm');
      setState(() {
        widget.data.add(TemperatureData(DateTime.now(), bpm));
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
        title: const Text('Gráfica de Pulso'),
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
            title: AxisTitle(text: 'Frecuencia Cardíaca (BPM)'),
            labelFormat: '{value} BPM',
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
              color: Colors.blue,
              width: 2,
              markerSettings: MarkerSettings(
                isVisible: true,
                color: Colors.blue,
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
