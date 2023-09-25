part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}

class WeatherSuccess extends WeatherState {
  final Weather weather;

  WeatherSuccess(this.weather);
}
