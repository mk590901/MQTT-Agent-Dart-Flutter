import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'message_bloc.dart';
import 'mqtt_bridge.dart';
import 'task_wrapper.dart';
import 'typedef.dart';

// Events for ButtonBloc
abstract class ButtonEvent extends Equatable {
  const ButtonEvent();

  @override
  List<Object> get props => [];
}

class ButtonPressed extends ButtonEvent {}
class ButtonProcessStarted extends ButtonEvent {}
class ButtonProcessCompleted extends ButtonEvent {
  final bool result;

  const ButtonProcessCompleted(this.result);

  @override
  List<Object> get props => [result];
}

// States for ButtonBloc
abstract class ButtonState extends Equatable {
  const ButtonState();

  @override
  List<Object> get props => [];
}

class ButtonInitial extends ButtonState {}
class ButtonLoading extends ButtonState {}
class ButtonSuccess extends ButtonState {}
class ButtonFailure extends ButtonState {}

// ButtonBloc
class ButtonBloc extends Bloc<ButtonEvent, ButtonState> {
  final BuildContext context;
  final Random random = Random();

  late MQTTBridge mqttBridge;

  Future<void> connect(VoidBridgeCallback cb) async {
    print ('******* connect [${mqttBridge.state()}] *******');
    mqttBridge.post2('Connect', cb);
  }

  Future<void> subscribe(VoidBridgeCallback cb) async {
    print ('******* subscribe [${mqttBridge.state()}] *******');
    mqttBridge.post2('Subscribe', cb);
  }

  Future<void> publish(VoidBridgeCallback cb) async {
    //await Future.delayed(Duration(milliseconds: 120));
    //bool rc = oracle();
    //cb(rc, rc ? 'publish done' : 'publish failed');
    print ('******* publish [${mqttBridge.state()}] *******');
    mqttBridge.post2('Publish', cb);
  }

  Future<void> unsubscribe(VoidBridgeCallback cb) async {
    // await Future.delayed(Duration(milliseconds: 150));
    // bool rc = oracle();
    // cb(rc, rc ? 'unsubscribe done' : 'unsubscribe failed');
    print ('******* unsubscribe [${mqttBridge.state()}] *******');
    mqttBridge.post2('Unsubscribe', cb);
  }

  Future<void> disconnect(VoidBridgeCallback cb) async {
    //await Future.delayed(Duration(milliseconds: 50));
    //await Future.delayed(Duration.zero);
    // bool rc = oracle();
    // cb(rc, rc ? 'disconnect done' : 'disconnect failed');
    print ('******* disconnect [${mqttBridge.state()}] *******');
    mqttBridge.post2('Disconnect', cb);
  }

  void response(bool rc, String text, bool next) {
    print ('response $rc, $text, $next');
  }

  ButtonBloc(this.context) : super(ButtonInitial()) {

    mqttBridge = MQTTBridge(response);

    on<ButtonPressed>(_onButtonPressed);
    on<ButtonProcessStarted>(_onButtonProcessStarted);
    on<ButtonProcessCompleted>(_onButtonProcessCompleted);
  }

  Future<void> _onButtonPressed(ButtonPressed event, Emitter<ButtonState> emit) async {
    emit(ButtonLoading());
    context.read<MessageBloc>().add(ClearMessages()); // Clear messages list
    TaskWrapper task = TaskWrapper(
      //functions: [disconnect, connect, subscribe, publish, unsubscribe, disconnect],
      functions: [connect/*, subscribe*/],
      onMessageReceived: (rc, message) {
        context.read<MessageBloc>().add(MessageReceived(rc,message));
      },
      onProcessStarted: () {
        add(ButtonProcessStarted());
      },
      onProcessCompleted: (result) {
        add(ButtonProcessCompleted(result));
      },
    );
    await task.execute();
  }

  void _onButtonProcessStarted(ButtonProcessStarted event, Emitter<ButtonState> emit) {
    emit(ButtonLoading());
  }

  void _onButtonProcessCompleted(ButtonProcessCompleted event, Emitter<ButtonState> emit) {
    emit(event.result ? ButtonSuccess() : ButtonFailure());
  }

  bool oracle() {
    int value = getRandomInRange(1,100);
    return (value > 48 ? true : false);
  }

  int getRandomInRange(int min, int max) {
    if (min > max) {
      throw ArgumentError('min should be less than or equal to max');
    }
    return min + random.nextInt(max - min + 1);
  }

}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
//
// import 'message_bloc.dart';
// import 'task_wrapper.dart';
//
// // Events for ButtonBloc
// abstract class ButtonEvent extends Equatable {
//   const ButtonEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class ButtonPressed extends ButtonEvent {}
// class ButtonProcessStarted extends ButtonEvent {}
// class ButtonProcessCompleted extends ButtonEvent {
//   final bool result;
//
//   const ButtonProcessCompleted(this.result);
//
//   @override
//   List<Object> get props => [result];
// }
//
// // States for ButtonBloc
// abstract class ButtonState extends Equatable {
//   const ButtonState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class ButtonInitial extends ButtonState {}
// class ButtonLoading extends ButtonState {}
// class ButtonSuccess extends ButtonState {}
// class ButtonFailure extends ButtonState {}
//
// // ButtonBloc
// class ButtonBloc extends Bloc<ButtonEvent, ButtonState> {
//   final BuildContext context;
//
//   ButtonBloc(this.context) : super(ButtonInitial()) {
//     on<ButtonPressed>(_onButtonPressed);
//     on<ButtonProcessStarted>(_onButtonProcessStarted);
//     on<ButtonProcessCompleted>(_onButtonProcessCompleted);
//   }
//
//   Future<void> _onButtonPressed(ButtonPressed event, Emitter<ButtonState> emit) async {
//     emit(ButtonLoading());
//     TaskWrapper task = TaskWrapper(
//       onMessageReceived: (message) {
//         print('_onButtonPressed.onMessageReceived << $message');
//         context.read<MessageBloc>().add(MessageReceived(message));
//       },
//       onProcessStarted: () {
//         add(ButtonProcessStarted());
//       },
//       onProcessCompleted: (result) {
//         add(ButtonProcessCompleted(result));
//       },
//     );
//     await task.execute();
//   }
//
//   void _onButtonProcessStarted(ButtonProcessStarted event, Emitter<ButtonState> emit) {
//     emit(ButtonLoading());
//   }
//
//   void _onButtonProcessCompleted(ButtonProcessCompleted event, Emitter<ButtonState> emit) {
//     emit(event.result ? ButtonSuccess() : ButtonFailure());
//   }
// }
