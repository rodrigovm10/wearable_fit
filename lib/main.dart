import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Importa la biblioteca para gráficos
import 'mqtt_service.dart'; // Importa el servicio MQTT

void main() {
  runApp(const MyApp()); // Llama a runApp para iniciar la aplicación
}

// MyApp es un widget Stateless que define la estructura general de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Line Chart App', // Título de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tema principal de la aplicación
      ),
      home:
          const LineChartScreen(), // Define LineChartScreen como la pantalla principal
    );
  }
}

// LineChartScreen es un StatefulWidget que mostrará el gráfico de líneas de temperatura
class LineChartScreen extends StatefulWidget {
  const LineChartScreen({super.key});

  @override
  _LineChartScreenState createState() =>
      _LineChartScreenState(); // Crea el estado asociado a este widget
}

// _LineChartScreenState contiene el estado del widget LineChartScreen
class _LineChartScreenState extends State<LineChartScreen> {
  late MqttService _mqttService; // Declaración del servicio MQTT
  final List<TemperatureData> _data = []; // Lista para almacenar los datos de temperatura
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    super.initState();
    // Inicializa el servicio MQTT con el broker y el clientId
    _mqttService = MqttService('broker.emqx.io', '');
    // Escucha el stream de temperatura y actualiza el estado cuando llegue un nuevo valor
    _mqttService.getTemperatureStream().listen((temperature) {
      setState(() {
        _data.add(TemperatureData(
            DateTime.now(), temperature)); // Añade los nuevos datos a la lista
        // Limita el número de puntos en el gráfico a 20
        if (_data.length > 20) {
          _data.removeAt(0);
        }
        _chartSeriesController.updateDataSource(
            addedDataIndex: _data.length - 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Temperature Line Chart'), // Título de la barra de la aplicación
      ),
      body: Center(
        // Contenedor principal de la pantalla
        child: SfCartesianChart(
          // Widget para mostrar el gráfico de líneas
          primaryXAxis: DateTimeAxis(), // Configura el eje X como eje de tiempo
          series: <LineSeries<TemperatureData, DateTime>>[
            LineSeries<TemperatureData, DateTime>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              dataSource: _data, // Define la fuente de datos para el gráfico
              xValueMapper: (TemperatureData data, _) =>
                  data.time, // Mapea los valores de X
              yValueMapper: (TemperatureData data, _) =>
                  data.temperature, // Mapea los valores de Y
            )
          ],
        ),
      ),
    );
  }
}

// Clase para representar los datos de temperatura
class TemperatureData {
  TemperatureData(this.time, this.temperature);
  final DateTime time; // Tiempo en el que se recibió la temperatura
  final double temperature; // Valor de la temperatura
}
