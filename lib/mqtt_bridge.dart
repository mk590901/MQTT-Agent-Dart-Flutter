import 'dart:io';
import 'dart:math';

import 'mqtt_cs_8_helper.dart';
//import 'mqtt_cs_9_helper.dart';
import 'typedef.dart';

class MQTTBridge {
  late MqttHelper  _hsmHelper;
  final VoidCallbackBoolString callbackFunction;

  late VoidBridgeCallback? connectCB;
  late VoidBridgeCallback? subscribeCB;
  late VoidBridgeCallback? publishCB;
  late VoidBridgeCallback? unsubscribeCB;
  late VoidBridgeCallback? disconnectCB;

  VoidBridgeCallback? getCallbackFunction(String tag) {
    VoidBridgeCallback? result;
    switch (tag) {
      case 'Connect':
        result = connectCB;
        break;
      case 'Subscribe':
        result = connectCB; //subscribeCB;
        break;
      case 'Publish':
        result = connectCB; //publishCB;
        break;
      case 'Unsubscribe':
        result = connectCB; //unsubscribeCB;
        break;
      case 'Disconnect':
        result = connectCB; // disconnectCB;
        break;
    }
    return result;
  }

  void putCallbackFunction(String tag, VoidBridgeCallback? cb) {
    switch (tag) {
      case 'Connect':
        connectCB = cb;
        break;
      case 'Subscribe':
        subscribeCB = cb;
        break;
      case 'Publish':
        publishCB = cb;
        break;
      case 'Unsubscribe':
        unsubscribeCB = cb;
        break;
      case 'Disconnect':
        disconnectCB = cb;
        break;
    }
  }


  void response(String tag, bool ok, String text, bool next) {
    print('MQTTBridge.response [$tag]->[$text]->[$ok]');
    //connectCB?.call(ok,text);

    VoidBridgeCallback? cb = getCallbackFunction(tag);
    cb?.call(ok,text);
    //cb = null;

    if (ok) {
      if (next) {
        post('Succeeded');
      }
    }
    else {
      if (next) {
        post('Failed');
      }
    }
  }

  MQTTBridge (this.callbackFunction) {
    _hsmHelper = MqttHelper(response, this);
    _hsmHelper.init();
  }

  String state() {
    return _hsmHelper.state();
  }

  void post (String eventName) {
    _hsmHelper.run(eventName);
  }

  void post2 (String eventName, [VoidBridgeCallback? cb]) {
    //connectCB = cb;
    putCallbackFunction(eventName, cb);
    _hsmHelper.run(eventName);
  }

  bool isSubscribed() {
    bool result = false;
    if (state() == 'AwaitPublishing') {
      result = true;
    }
    return result;
  }

  bool isConnected() {
    bool result = true;
    if (state() == 'Disconnected') {
      result = false;
    }
    return result;
  }

  void setUnitTest() {
    _hsmHelper.setUnitTest();
  }

}