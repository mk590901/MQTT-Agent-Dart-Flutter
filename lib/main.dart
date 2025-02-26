import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'client_helper.dart';
import 'main_screen.dart';
import 'message_bloc.dart';

void main() {
  ClientHelper.initInstance();
  runApp(MQTTSinkApp());
}

class MQTTSinkApp extends StatelessWidget {
  const MQTTSinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MessageBloc>(
          create: (context) => MessageBloc(),
        ),
      ],
      child: MaterialApp(
        home: ActionsScreen(),
      ),
    );
  }
}
