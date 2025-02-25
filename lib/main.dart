import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_screen.dart';
import 'message_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MessageBloc>(
          create: (context) => MessageBloc(),
        ),
      ],
      child: MaterialApp(
        home: MyScreen(),
      ),
    );
  }
}
