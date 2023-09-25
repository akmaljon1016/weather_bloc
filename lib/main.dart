import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/weather_bloc.dart';

void main() {
  runApp(MaterialApp(
    home: BlocProvider(
      create: (context) => WeatherBloc(),
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WeatherBloc>(context).add(GetWeatherEvent("Tashkent"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("User download"),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Write city name..."),
                  onChanged: (value) {
                    BlocProvider.of<WeatherBloc>(context)
                        .add(GetWeatherEvent(value));
                  },
                ),
              ),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return CircularProgressIndicator();
                  } else if (state is WeatherSuccess) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                          ),
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green[200],
                            ),
                            child: Column(
                              children: [
                                Image.network(
                                  "https:" +
                                      (state.weather?.current?.condition
                                              ?.icon ??
                                          ""),
                                  width: 100,
                                  height: 100,
                                ),
                                Text(
                                  state.weather?.current?.tempC.toString() ??
                                      "empty",
                                  style: TextStyle(fontSize: 30),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            child: ListView.builder(
                                itemCount: state
                                    .weather?.forecast?.forecastday?.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.green[200],
                                    ),
                                    child: Column(
                                      children: [
                                        Image.network(
                                          "https:" +
                                              (state
                                                      .weather
                                                      ?.forecast
                                                      ?.forecastday?[index]
                                                      .day
                                                      ?.condition
                                                      ?.icon ??
                                                  ""),
                                          width: 100,
                                          height: 100,
                                        ),
                                        Text(
                                          state
                                                  .weather
                                                  ?.forecast
                                                  ?.forecastday?[index]
                                                  .day
                                                  ?.avgtempC
                                                  .toString() ??
                                              "empty",
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        Text(state.weather?.forecast
                                                ?.forecastday?[index].date ??
                                            "empty")
                                      ],
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    );
                  } else if (state is WeatherError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error),
                        SizedBox(
                          height: 20,
                        ),
                        Text(state.message.toString())
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ));
  }
}
