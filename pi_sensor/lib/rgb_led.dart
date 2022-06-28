import 'package:component/component.dart';
import 'package:flutter/material.dart';

class RGBLEDWidget extends StatefulWidget {
  const RGBLEDWidget({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _RGBLEDWidget();
  }
}

class _RGBLEDWidget extends State<RGBLEDWidget> {
  int rgb = 0;
  Component component = Component();

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
                          hintText: "rgb FFFFFF",
                          border: InputBorder.none),
                      onChanged: (text) {
                        rgb = int.parse(text);
                      },
                    ))),
            Positioned(
              top: 160,
              left: 100,
              child: InkWell(
                child: Container(
                  width: 80,
                  height: 44,
                  color: Colors.orange,
                  alignment: Alignment.center,
                  child: const Text(
                    "set",
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  component.setRGBLED(rgb);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
