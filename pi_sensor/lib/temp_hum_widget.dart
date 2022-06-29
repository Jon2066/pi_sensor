import 'dart:async';

import 'package:flutter/material.dart';
import 'package:temp_hum_sensor/temp_hum_sensor.dart';

class TempSensorWidget extends StatefulWidget {
  const TempSensorWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TempSensorWidget();
  }
}

class _TempSensorWidget extends State<TempSensorWidget> {
  String temp = "";
  Timer? detectTimer;
  bool running = false;
  TempHumSensor sensor = TempHumSensor();

  @override
  void initState() {
    super.initState();
    sensor.setupSensor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              top: 50.0,
              left: 0.0,
              right: 0.0,
              child: Text(
                "温湿度传感器",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'NotoSerif',
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Text(
                "温度湿度: $temp",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontFamily: 'NotoSerif',
                ),
              ),
            ),
            Positioned(
              top: 120,
              width: 100,
              height: 44,
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.orange,
                  child: Text(
                    running ? "stop" : "start",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontFamily: 'NotoSerif',
                    ),
                  ),
                ),
                onTap: () {
                  detectAction();
                },
              ),
            ),
          ],
        ));
  }

  void detectAction() {
    if (running) {
      running = false;
      detectTimer?.cancel();
      detectTimer = null;
    } else {
      running = true;
      detectTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        sensor.read().then((value) {
          debugPrint(value);
          int v = int.parse(value ?? "0");
          int hum = (v >> 24) & 0xff;  //只看整数部分， (v >> 16) & 0xff小数部分忽略 
          int tmp = (v >> 8) & 0xff;
          temp = "${tmp.toStringAsFixed(2)}, ${hum.toStringAsFixed(2)}";
        });
      });
    }
    setState(() {});
  }
}
