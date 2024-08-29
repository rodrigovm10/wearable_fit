// import 'package:flutter/material.dart';
// import 'package:mqtt_line_chart/models/data_models.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../services/mqtt_service.dart';

// class StepsChartScreen extends StatefulWidget {
//   final List<StepsData> data;

//   StepsChartScreen({required this.data});

//   @override
//   _StepsChartScreenState createState() => _StepsChartScreenState();
// }

// class _StepsChartScreenState extends State<StepsChartScreen> {
//   late MqttService _mqttService;
//   late ChartSeriesController _chartSeriesController;

//   @override
//   void initState() {
//     super.initState();
//     // Asegúrate de que el servidor MQTT esté correcto y sin prefijo
//     _mqttService =
//         MqttService('test.mosquitto.org', 'clientId'); // Usa un clientId válido
//     _mqttService.getSensorStream('sensor/steps/out').listen((steps) {
//       print('Steps received: $steps');
//       setState(() {
//         widget.data.add(StepsData(DateTime.now(), steps));
//         if (widget.data.length > 20) {
//           widget.data.removeAt(0);
//         }
//         _chartSeriesController.updateDataSource(
//             addedDataIndex: widget.data.length - 1);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Gráfica de Pasos'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Container(
//         color: Colors.white,
//         padding: const EdgeInsets.all(16.0),
//         child: SfCartesianChart(
//           primaryXAxis: DateTimeAxis(
//             title: AxisTitle(text: 'Fecha y Hora'),
//             edgeLabelPlacement: EdgeLabelPlacement.shift,
//             interval: 1,
//             intervalType: DateTimeIntervalType.hours,
//             majorGridLines: MajorGridLines(width: 0),
//             minorGridLines: MinorGridLines(width: 0),
//             labelStyle: TextStyle(fontSize: 12, color: Colors.black54),
//             axisLine: AxisLine(width: 1, color: Colors.black54),
//           ),
//           primaryYAxis: NumericAxis(
//             title: AxisTitle(text: 'Número de Pasos'),
//             labelStyle: TextStyle(fontSize: 12, color: Colors.black54),
//             axisLine: AxisLine(width: 1, color: Colors.black54),
//             majorGridLines: MajorGridLines(width: 0.5, color: Colors.grey),
//             minorGridLines: MinorGridLines(width: 0.5, color: Colors.grey[300]),
//           ),
//           series: <LineSeries<StepsData, DateTime>>[
//             LineSeries<StepsData, DateTime>(
//               onRendererCreated: (ChartSeriesController controller) {
//                 _chartSeriesController = controller;
//               },
//               dataSource: widget.data,
//               xValueMapper: (StepsData data, _) => data.time,
//               yValueMapper: (StepsData data, _) => data.steps,
//               color: Colors.blue,
//               width: 2,
//               markerSettings: MarkerSettings(
//                 isVisible: true,
//                 color: Colors.blueAccent,
//                 borderColor: Colors.white,
//                 borderWidth: 2,
//                 shape: DataMarkerType.circle,
//               ),
//               dataLabelSettings: DataLabelSettings(
//                 isVisible: true,
//                 textStyle: TextStyle(color: Colors.black, fontSize: 10),
//               ),
//             ),
//           ],
//           tooltipBehavior: TooltipBehavior(
//             enable: true,
//             format: 'point.x: point.y',
//             color: Colors.blueAccent,
//             textStyle: TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }
