import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = MethodChannel('com.tahatesser.anqa/cpuInfo');

  String _cpu = 'Unknown';

  Future<void> getCPUInfo() async {
    String cpu;
    try {
      final result = await platform.invokeMethod('getCPUBrand');
      cpu = result;
    } on PlatformException catch (e) {
      cpu = "Failed to get CPU type: '${e.message}'.";
    }

    setState(() {
      _cpu = cpu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: getCPUInfo(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              return Text(
                  _cpu,
                  style: Theme.of(context).textTheme.headlineLarge,
                );
            },
          ),
        ),
      ),
    );
  }
}
