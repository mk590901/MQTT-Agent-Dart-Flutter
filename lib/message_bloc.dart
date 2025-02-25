import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'pair.dart';

// Events for MessageBloc
abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class MessageReceived extends MessageEvent {
  final bool rc;
  final String message;

  const MessageReceived(this.rc, this.message);

  @override
  List<Object> get props => [rc, message];
}

class ClearMessages extends MessageEvent {}

// States for MessageBloc
abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}
class MessageListUpdated extends MessageState {
  final List<Pair<bool, String>> messages;

  const MessageListUpdated(this.messages);

  @override
  List<Object> get props => [messages];
}

// MessageBloc
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageInitial()) {
    on<MessageReceived>(_onMessageReceived);
    on<ClearMessages>(_onClearMessages);
  }

  List<Pair<bool, String>> messages = [];

  void _onMessageReceived(MessageReceived event, Emitter<MessageState> emit) {
    messages.add(Pair(event.rc, event.message));
    emit(MessageListUpdated(List.from(messages))); // New list for state update was created
  }

  void _onClearMessages(ClearMessages event, Emitter<MessageState> emit) {
    messages.clear();
    emit(MessageListUpdated(List.from(messages))); // New empty list for state update was created
  }
}



// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
//
// // Events for MessageBloc
// abstract class MessageEvent extends Equatable {
//   const MessageEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class MessageReceived extends MessageEvent {
//   final String message;
//   final bool indic;
//
//   const MessageReceived(this.indic, this.message);
//
//   @override
//   List<Object> get props => [message];
// }
//
// // States for MessageBloc
// abstract class MessageState extends Equatable {
//   const MessageState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class MessageInitial extends MessageState {}
//
// class MessageListUpdated extends MessageState {
//   final List<String> messages;
//
//   const MessageListUpdated(this.messages);
//
//   @override
//   List<Object> get props => [messages];
// }
//
// // MessageBloc
// class MessageBloc extends Bloc<MessageEvent, MessageState> {
//   MessageBloc() : super(MessageInitial()) {
//     on<MessageReceived>(_onMessageReceived);
//   }
//
//   List<String> messages = [];
//
//   void _onMessageReceived(MessageReceived event, Emitter<MessageState> emit) {
//     messages.add(event.message);
//     emit(MessageListUpdated(List.from(messages))); // new list has been created for  new state
//   }
// }
//
//
