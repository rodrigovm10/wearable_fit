import 'package:flutter/material.dart'; // Importa el paquete de Flutter para la UI
import 'package:mqtt_line_chart/models/data_models.dart'; // Importa modelos de datos (TemperatureData en este caso)
import 'package:syncfusion_flutter_charts/charts.dart'; // Importa el paquete de Syncfusion para gráficos
import 'package:intl/intl.dart'; // Importa el paquete para formateo de fechas
import '../services/mqtt_service.dart'; // Importa el servicio MQTT

// Pantalla para mostrar la gráfica de pulso
class PulseChartScreen extends StatefulWidget {
  final List<TemperatureData> data; // Lista de datos para la gráfica

  PulseChartScreen({required this.data});

  @override
  _PulseChartScreenState createState() => _PulseChartScreenState();
}

class _PulseChartScreenState extends State<PulseChartScreen> {
  late MqttService _mqttService; // Variable para el servicio MQTT
  late ChartSeriesController _chartSeriesController; // Controlador de la serie del gráfico

  @override
  void initState() {
    super.initState();
    // Inicializa el servicio MQTT con el servidor y el clientId
    _mqttService =
        MqttService('test.mosquitto.org', 'clientId'); // Usa un clientId válido
    // Escucha los datos del sensor de BPM (frecuencia cardíaca) desde el tópico especificado
    _mqttService.getSensorStream('sensor/max/bpm/out').listen((bpm) {
      print('BPM received: $bpm'); // Línea de depuración
      setState(() {
        widget.data.add(TemperatureData(DateTime.now(), bpm)); // Agrega los nuevos datos
        if (widget.data.length > 20) {
          widget.data.removeAt(0); // Mantiene solo los últimos 20 datos
        }
        // Actualiza la fuente de datos del gráfico
        _chartSeriesController.updateDataSource(
            addedDataIndex: widget.data.length - 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfica de Pulso'), // Título de la barra de aplicación
        backgroundColor: Colors.blueAccent, // Color de fondo de la barra de aplicación
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0), // Espaciado alrededor del contenedor
        color: Colors.white, // Color de fondo del contenedor
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat('HH:mm:ss'), // Formato de la fecha en el eje X
            title: AxisTitle(text: 'Hora'), // Título del eje X
            majorGridLines: MajorGridLines(width: 0), // Líneas de cuadrícula principales del eje X
            minorGridLines: MinorGridLines(width: 0), // Líneas de cuadrícula secundarias del eje X
            axisLine: AxisLine(width: 0), // Línea del eje X
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Frecuencia Cardíaca (BPM)'), // Título del eje Y
            labelFormat: '{value} BPM', // Formato de las etiquetas del eje Y
            majorGridLines: MajorGridLines(width: 1), // Líneas de cuadrícula principales del eje Y
            minorGridLines: MinorGridLines(width: 0), // Líneas de cuadrícula secundarias del eje Y
            axisLine: AxisLine(width: 0), // Línea del eje Y
          ),
          series: <LineSeries<TemperatureData, DateTime>>[
            LineSeries<TemperatureData, DateTime>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller; // Asigna el controlador de la serie
              },
              dataSource: widget.data, // Fuente de datos para la serie
              xValueMapper: (TemperatureData data, _) => data.time, // Mapea los valores del eje X
              yValueMapper: (TemperatureData data, _) => data.temperature, // Mapea los valores del eje Y
              color: Colors.blue, // Color de la línea del gráfico
              width: 2, // Grosor de la línea
              markerSettings: MarkerSettings(
                isVisible: true, // Muestra los marcadores en los puntos de datos
                color: Colors.blue, // Color de los marcadores
                borderColor: Colors.white, // Color del borde de los marcadores
                borderWidth: 2, // Grosor del borde de los marcadores
              ),
            ),
          ],
          tooltipBehavior: TooltipBehavior(enable: true), // Habilita el tooltip para mostrar información al pasar el cursor
          zoomPanBehavior: ZoomPanBehavior(
            enablePanning: true, // Habilita el desplazamiento en la gráfica
            enablePinching: true, // Habilita el zoom en la gráfica
            zoomMode: ZoomMode.xy, // Modo de zoom en ambos ejes
          ),
        ),
      ),
    );
  }
}
