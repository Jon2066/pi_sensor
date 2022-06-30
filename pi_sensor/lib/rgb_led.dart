import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:component/component.dart';
import 'package:flutter/material.dart';
import 'package:pi_sensor/hex_utils.dart';

class RGBLEDWidget extends StatefulWidget {
  const RGBLEDWidget({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _RGBLEDWidget();
  }
}

class _RGBLEDWidget extends State<RGBLEDWidget> {

  static const String hexRegex = "^[A-Fa-f0-9]{6}";

  String rgbStr = "FFFFFF";
  Component component = Component();
  bool running = false;
  Timer? runningTimer;

  @override
  void initState() {
    super.initState();
    component.setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(top: 50),
        child: Stack(
          children: [
            Positioned(
                top: 80,
                left: 100,
                child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                        border: Border.all(color: Colors.blue, width: 2)),
                    width: 200,
                    height: 50,
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: "rgb like FFFFFF",
                          border: InputBorder.none),
                      onChanged: (text) {
                        rgbStr = text;
                      },
                    ))),
            Positioned(
              top: 160,
              left: 100,
              child: InkWell(
                child: Container(
                  width: 120,
                  height: 44,
                  color: Colors.orange,
                  alignment: Alignment.center,
                  child: const Text(
                    "set",
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  if(RegExp(hexRegex).hasMatch(rgbStr)){
                    Uint8List dataList = HexUtils.toUnitList(rgbStr);
                    setRGBHex(dataList);
                  }
                },
              ),
            ),
            Positioned(
              top: 160,
              left: 300,
              child: InkWell(
                child: Container(
                  width: 120,
                  height: 44,
                  color: Colors.orange,
                  alignment: Alignment.center,
                  child: const Text(
                    "reset",
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  reset();
                },
              ),
            ),
            Positioned(
              top: 240,
              left: 100,
              child: InkWell(
                child: Container(
                  width: 120,
                  height: 44,
                  color: Colors.orange,
                  alignment: Alignment.center,
                  child: Text(
                    running ? "random stop" : "random start",
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  randomAction();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setRGBHex(Uint8List dataList) {
    int value = 0;
    for (int v in dataList) {
      value += v;
      value = value << 8;
    }
    value = (value >> 8) & 0xffffff;
    component.setRGBLED(value);
  }

  void randomAction() {
    if (running) {
      running = false;
      runningTimer?.cancel();
    } else {
      running = true;
      runningTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        Random random = Random();
        int r = random.nextInt(256);
        int g = random.nextInt(256);
        int b = random.nextInt(256);
        setRGBHex(Uint8List.fromList([r, g, b]));
      });
    }
    setState(() {});
  }

  void reset(){
    component.reset();
  }

  @override
  void dispose() {
    reset();
  }
}
