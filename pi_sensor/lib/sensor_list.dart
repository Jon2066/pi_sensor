import 'package:flutter/material.dart';
import 'package:pi_sensor/rgb_led.dart';
import 'package:pi_sensor/temp_hum_widget.dart';

class SensorListWidget extends StatefulWidget {
  const SensorListWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SensorListWidget();
  }
}

class _SensorListWidget extends State<SensorListWidget> {
  List<String> sensors = ["温湿度传感器", "RGB LED"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            padding: const EdgeInsets.only(top: 30),
            color: Colors.white,
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                itemExtent: 60,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.orange,
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Text(
                        sensors[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 17),
                      ),
                      onTap: () {
                        handleSelect(index);
                      },
                    ),
                  );
                },
                itemCount: sensors.length,
              ),
            )));
  }

  void handleSelect(int index) {
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TempSensorWidget()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RGBLEDWidget()));
        break;
    }
  }
}
