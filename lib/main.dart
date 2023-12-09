import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:weather/class/model.dart';
import 'package:weather/class/theme.dart';
import 'package:weather/class/weekmodel.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: weather(),
  ));
}

// ignore: camel_case_types
class weather extends StatefulWidget {
  const weather({Key? key}) : super(key: key);

  @override
  _weatherState createState() => _weatherState();
}

// ignore: camel_case_types
class _weatherState extends State<weather> {
  var getTxt = TextEditingController();
  late Future<models> modelFuture;
  late StreamController<List<weekModel>> strimWModel;

  var cityname = 'nowshahr';
  var lat;
  var lon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 35, 58),
        // elevation: 15,

        title: Text(
          '@m0h3nfrji',
          style: TxtTheme.darkTextTheme.bodyText1,
        ),
      ),
      body: FutureBuilder<models>(
          future: modelFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              models? cityDataModel = snapshot.data;
              SendReqWeek(lat, lon);

              final formatter = DateFormat.jm();
              var sunrise = formatter.format(
                  DateTime.fromMillisecondsSinceEpoch(
                      cityDataModel!.sunrise * 1000,
                      isUtc: true));
              var sunset = formatter.format(DateTime.fromMillisecondsSinceEpoch(
                  cityDataModel.sunset * 1000,
                  isUtc: true));

              return SafeArea(
                child: Container(
                  // height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/1.webp'),
                          fit: BoxFit.cover)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              modelFuture =
                                                  senrequestcurrentWeather(
                                                      getTxt.text);
                                              getTxt.text = "";
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            });
                                          },
                                          child: Text("ثبت",
                                              style: TxtTheme
                                                  .darkTextTheme.headline2))),
                                  Expanded(
                                      child: TextField(
                                    style: TxtTheme.darkTextTheme.headline3,
                                    textAlign: TextAlign.right,
                                    controller: getTxt,
                                    decoration: const InputDecoration(
                                      //hintStyle: Color:Colors.white,
                                      hintText: 'نام شهر را وارد کنید',
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                      // labelStyle: Colors.white,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 10),
                              child: Text(cityDataModel.cityname,
                                  style: TxtTheme.darkTextTheme.headline1),
                            ),
                            Text(cityDataModel.description,
                                style: TxtTheme.darkTextTheme.headline3),
                            Image.asset(
                              // icoon='images/'+ cityDataModel.icon +'.png',
                              'images/' + cityDataModel.icon + '.png',
                              // 'images/50n.png',
                              width: 100.0,
                              fit: BoxFit.cover,
                            ),
                            Text(cityDataModel.temp.toString() + "\u00B0",
                                style: TxtTheme.darkTextTheme.headline1),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "حداکثر دما",
                                          style:
                                              TxtTheme.darkTextTheme.headline3,
                                        ),
                                      ),
                                      Text(
                                          cityDataModel.temp_max.toString() +
                                              ' \u00B0',
                                          style:
                                              TxtTheme.darkTextTheme.headline3)
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Container(
                                      color: Colors.white,
                                      height: 40,
                                      width: 1,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text("حداقل دما",
                                            style: TxtTheme
                                                .darkTextTheme.headline3),
                                      ),
                                      Text(
                                          cityDataModel.temp_min.toString() +
                                              "\u00B0",
                                          style:
                                              TxtTheme.darkTextTheme.headline3),
                                    ],
                                  )
                                ]),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                //width: 300,
                                child: StreamBuilder<List<weekModel>>(
                                    stream: strimWModel.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<weekModel>? wModel = snapshot.data;
                                        return Center(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 7,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int pos) {
                                                return ListViewItems(
                                                    wModel![pos + 1]);
                                              }),
                                        );
                                      } else {
                                        return SafeArea(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'images/1.webp'),
                                                    fit: BoxFit.cover)),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 4, sigmaY: 4),
                                              child: Center(
                                                child: JumpingText(
                                                  'Loading...',
                                                  style: TxtTheme
                                                      .lightTextTheme.headline2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    })),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text("سرعت باد",
                                        style:
                                            TxtTheme.darkTextTheme.bodyText1),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          cityDataModel.windSpeed.toString() +
                                              " m/s",
                                          style:
                                              TxtTheme.darkTextTheme.bodyText1),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Container(
                                    color: Colors.white,
                                    height: 35,
                                    width: 1,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text('طلوع خورشید',
                                        style:
                                            TxtTheme.darkTextTheme.bodyText1),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(sunrise,
                                          style:
                                              TxtTheme.darkTextTheme.bodyText1),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    color: Colors.white,
                                    height: 35,
                                    width: 1,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text('غروب خورشید',
                                        style:
                                            TxtTheme.darkTextTheme.bodyText1),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(sunset,
                                          style:
                                              TxtTheme.darkTextTheme.bodyText1),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Container(
                                    color: Colors.white,
                                    height: 35,
                                    width: 1,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text('رطوبت',
                                        style:
                                            TxtTheme.darkTextTheme.bodyText1),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          cityDataModel.humidity.toString() +
                                              ' %',
                                          style:
                                              TxtTheme.darkTextTheme.bodyText1),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return SafeArea(
                child: Container(
                  // decoration: const BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage('images/1.webp'),
                  //         fit: BoxFit.cover)),
                  // child: BackdropFilter(
                  //   filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Center(
                    child: JumpingText(
                      'Loading...',
                      style: TxtTheme.lightTextTheme.headline2,
                    ),
                  ),
                  // ),
                ),
              );
            }
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    modelFuture = senrequestcurrentWeather(cityname);
    strimWModel = StreamController<List<weekModel>>();
  }

  Container ListViewItems(weekModel wModel) {
    return Container(
        //height: 80,
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              wModel.dateTime,
              style: TxtTheme.darkTextTheme.bodyText1,
            ),
            Image.asset(
              'images/' + wModel.icoon + '.png',
              height: 45,
              fit: BoxFit.cover,
            ),
            Text(wModel.temp.round().toString() + "\u00B0",
                style: TxtTheme.darkTextTheme.bodyText1),
          ],
        ));
  }

  void SendReqWeek(lat, lon) async {
    List<weekModel> list = [];
    var apikey = '82f1302dc5a414189e6dd99f1d31f2a9';

    var response = await Dio().get(
        'https://api.openweathermap.org/data/2.5/onecall',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'exclude': 'minutely,hourly',
          'appid': apikey,
          'units': 'metric'
        });

    final formater = DateFormat.MMMd();
    for (int i = 0; i < 8; i++) {
      var moodel = response.data['daily'][i];
      var dt = formater.format(DateTime.fromMillisecondsSinceEpoch(
          moodel['dt'] * 1000,
          isUtc: true));

      weekModel swmodel = weekModel(
          dt,
          moodel['temp']['day'],
          moodel['weather'][0]['main'],
          moodel['weather'][0]['description'],
          moodel['weather'][0]['icon']);

      list.add(swmodel);
    }
    strimWModel.add(list);
  }

  Future<models> senrequestcurrentWeather(String cityname) async {
    //var apikey = 'd66a4f94f8a3406b9d392338221201';
    var apikey2 = '82f1302dc5a414189e6dd99f1d31f2a9';

    //var response = await Dio().get('http://api.weatherapi.com/v1/current.json',queryParameters: {'q': cityname, 'key': apikey});
    var response2 = await Dio().get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': cityname,
          'appid': apikey2,
          'lang': 'fa',
          'units': 'metric'
        });

    lat = response2.data["coord"]["lat"];
    lon = response2.data["coord"]["lon"];

    var datamodel = models(
      response2.data['name'],
      response2.data["coord"]["lon"],
      response2.data["coord"]["lat"],
      response2.data["weather"][0]["main"],
      response2.data["weather"][0]["description"],
      response2.data["main"]['temp'],
      response2.data["main"]['temp_min'],
      response2.data["main"]['temp_max'],
      response2.data["main"]['pressure'],
      response2.data["main"]['humidity'],
      response2.data["wind"]['speed'],
      response2.data["dt"],
      response2.data["sys"]['country'],
      response2.data["sys"]['sunrise'],
      response2.data["sys"]['sunset'],
      response2.data["weather"][0]['icon'],
    );

    return datamodel;
  }
}
