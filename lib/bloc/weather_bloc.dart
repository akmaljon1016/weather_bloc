import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:weather_bloc/model/weather.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  Dio dio = Dio();

  WeatherBloc() : super(WeatherInitial()) {
    on<GetWeatherEvent>(getWeather);
  }

  Future<void> getWeather(
      GetWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      var response = await dio.get(
          "http://api.weatherapi.com/v1/forecast.json?key=acb4a4de25aa41b784651422200510&q=${event.city}&days=3");
      if (response.statusCode == 200) {
        emit(WeatherSuccess(Weather.fromJson(response.data)));
      } else {
        emit(WeatherError("Unknown Error"));
      }
    } on DioException catch(e) {
      if(e.response?.statusCode==400){
        emit(WeatherError("ERROR"));
      }
      else{
        emit(WeatherError("$e"));
      }
    }
  }
}
