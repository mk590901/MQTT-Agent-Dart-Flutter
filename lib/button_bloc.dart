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

  late  MQTTBridge mqttBridge;

  Future<void> connect(VoidBridgeCallback cb) async {
    print ('******* connect [${mqttBridge.state()}] *******');
    mqttBridge.postComposite('Connect', cb);
  }

  Future<void> disconnect(VoidBridgeCallback cb) async {
    print ('******* disconnect [${mqttBridge.state()}] *******');
    mqttBridge.postComposite('Disconnect', cb);
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
      functions: [disconnect, connect],
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

}
