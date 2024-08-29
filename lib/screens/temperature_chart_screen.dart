import 'package:flutter/material.dart'; // Importa el paquete de Flutter para la UI
import 'package:mqtt_line_chart/models/data_models.dart'; // Importa los modelos de datos
import 'package:syncfusion_flutter_charts/charts.dart'; // Importa el paquete de gráficos Syncfusion
import '../services/mqtt_service.dart'; // Importa el servicio MQTT
import 'package:intl/intl.dart'; // Importa el paquete para formateo de fechas

// Pantalla para mostrar la gráfica de temperatura
class TemperatureChartScreen extends StatefulWidget {
  final List<TemperatureData> data; // Lista de datos de temperatura

  TemperatureChartScreen({required this.data}); // Constructor que recibe los datos

  @override
  _TemperatureChartScreenState createState() => _TemperatureChartScreenState();
}

class _TemperatureChartScreenState extends State<TemperatureChartScreen> {
  late MqttService _mqttService; // Variable para el servicio MQTT
  late ChartSeriesController _chartSeriesController; // Controlador de la serie de gráficos

  @override
  void initState() {
    super.initState();
    // Asegúrate de que el servidor MQTT esté correcto y sin prefijo
    _mqttService =
        MqttService('test.mosquitto.org', 'clientId'); // Inicializa el servicio MQTT con un clientId válido

    // Escucha los datos del sensor de temperatura y actualiza la gráfica
    _mqttService
        .getSensorStream('sensor/dht11/temperatura/out')
        .listen((temperature) {
      print('Temperature received: $temperature'); // Línea de depuración
      setState(() {
        // Agrega el nuevo dato de temperatura a la lista
        widget.data.add(TemperatureData(DateTime.now(), temperature));
        // Mantiene solo los últimos 20 datos en la lista
        if (widget.data.length > 20) {
          widget.data.removeAt(0);
        }
        // Actualiza la fuente de datos de la serie de gráficos
        _chartSeriesController.updateDataSource(
            addedDataIndex: widget.data.length - 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfica de Temperatura'), // Título de la barra de aplicación
        backgroundColor: Colors.blueAccent, // Color de fondo de la barra de aplicación
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0), // Espaciado alrededor del contenedor
        color: Colors.white, // Color de fondo del contenedor
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat('HH:mm'), // Formato de la fecha en el eje X
            title: AxisTitle(text: 'Hora'), // Título del eje X
            majorGridLines: MajorGridLines(width: 0), // Líneas de la cuadrícula principal
            minorGridLines: MinorGridLines(width: 0), // Líneas de la cuadrícula menor
            axisLine: AxisLine(width: 0), // Línea del eje
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Temperatura (°C)'), // Título del eje Y
            labelFormat: '{value}°C', // Formato de las etiquetas del eje Y
            majorGridLines: MajorGridLines(width: 1), // Líneas de la cuadrícula principal
            minorGridLines: MinorGridLines(width: 0), // Líneas de la cuadrícula menor
            axisLine: AxisLine(width: 0), // Línea del eje
          ),
          series: <LineSeries<TemperatureData, DateTime>>[
            LineSeries<TemperatureData, DateTime>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller; // Inicializa el controlador de la serie
              },
              dataSource: widget.data, // Datos de la gráfica
              xValueMapper: (TemperatureData data, _) => data.time, // Mapea el valor del eje X
              yValueMapper: (TemperatureData data, _) => data.temperature, // Mapea el valor del eje Y
              color: Colors.red, // Color de la línea
              width: 2, // Ancho de la línea
              markerSettings: MarkerSettings(
                isVisible: true, // Hacer visible el marcador
                color: Colors.red, // Color del marcador
                borderColor: Colors.white, // Color del borde del marcador
                borderWidth: 2, // Ancho del borde del marcador
              ),
            ),
          ],
          tooltipBehavior: TooltipBehavior(enable: true), // Habilita el comportamiento del tooltip
          zoomPanBehavior: ZoomPanBehavior(
            enablePanning: true, // Habilita el desplazamiento
            enablePinching: true, // Habilita el zoom
            zoomMode: ZoomMode.xy, // Modo de zoom
          ),
        ),
      ),
    );
  }
}
