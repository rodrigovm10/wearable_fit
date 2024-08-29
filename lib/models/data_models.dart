// Clase para representar los datos de temperatura
class TemperatureData {
  // Constructor de la clase que inicializa el tiempo y la temperatura
  TemperatureData(this.time, this.temperature);

  // Variable que almacena el momento en que se registró la temperatura
  final DateTime time;

  // Variable que almacena el valor de la temperatura
  final double temperature;
}

// Clase para representar los datos de pasos
class StepsData {
  // Constructor de la clase que inicializa el tiempo y el conteo de pasos
  StepsData(this.time, this.steps);

  // Variable que almacena el momento en que se registró el conteo de pasos
  final DateTime time;

  // Variable que almacena el número de pasos registrados
  final double steps;
}

// Clase para representar los datos de frecuencia cardíaca
class HeartRateData {
  // Constructor de la clase que inicializa el tiempo y la frecuencia cardíaca
  HeartRateData(this.time, this.heartRate);

  // Variable que almacena el momento en que se registró la frecuencia cardíaca
  final DateTime time;

  // Variable que almacena el valor de la frecuencia cardíaca
  final double heartRate;
}
