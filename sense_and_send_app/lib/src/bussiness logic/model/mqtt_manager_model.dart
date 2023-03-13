import 'dart:convert';
import 'dart:core';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../controller/mqtt_app_state_controller.dart';

class MQTTManagerModel {
  // Private instance of client
  MqttServerClient? _client;
   final String _broker = 'broker.hivemq.com'; //broker.hivemq.com
  final String _topic = 'mqttlecturas_de_metrocontadores';
   final String _clientIdentifier = 'flutter_client_app';
  final MQTTAppStateController _currentState;
  String username  = 'pupi.encinosa';
  String password    = 'elbertyaami999';
  String _notification = '';

  // Constructor
  // ignore: sort_constructors_first
  MQTTManagerModel(
      {
        required MQTTAppStateController state})
      :
        _currentState = state;

  void initializeMQTTClient() {
    _client = MqttServerClient(_broker, _clientIdentifier);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnected;
    _client!.logging(on: true);

    /// Add the successful connection callback
    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_clientIdentifier)
        .withWillTopic(
        'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Flutter client connecting....');
    _client!.connectionMessage = connMess;
  }

  // Connect to the host
  // ignore: avoid_void_async
  void connect() async {
    initializeMQTTClient();

    assert(_client != null);
    try {
      print('EXAMPLE::HiveMQ start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client!.connect(username, password);
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client!.disconnect();
  }

  void publish(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload!, retain: true);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client!.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  /// The successful connect callback
  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    print('EXAMPLE::Mosquitto client connected....');
    _client!.subscribe(_topic, MqttQos.atLeastOnce);
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      // ignore: avoid_as
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;

      // final MqttPublishMessage recMess = c![0].payload;
      final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      _notification = pt;

      _currentState.setReceivedText(pt);

      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
    });
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

  String getNotification (){
    print("ddddddddddddddd$_notification");
    return _notification;
  }

}



