import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sense_and_send_app/src/bussiness%20logic/controller/mqtt_app_state_controller.dart';
import 'package:sense_and_send_app/src/presentation/pages/mqtt_view.dart';

 void main() => runApp(const InitAppController());

class InitAppController extends StatelessWidget {
  const InitAppController({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mqtt',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ChangeNotifierProvider<MQTTAppStateController>(
        create: (_) => MQTTAppStateController(),
        child: const MQTTView(),

      ),
      debugShowCheckedModeBanner: false,
    );
  }
}