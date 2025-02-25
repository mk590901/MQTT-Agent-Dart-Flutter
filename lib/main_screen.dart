import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'button_bloc.dart';
import 'message_bloc.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BLoC Example')),
      body: Column(
        children: [
          BlocProvider(
            create: (context) => ButtonBloc(context),
            child: BlocBuilder<ButtonBloc, ButtonState>(
              builder: (context, state) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: state is ButtonLoading
                          ? null
                          : () {
                        context.read<ButtonBloc>().add(ButtonPressed());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state is ButtonFailure ? Colors.red :
                            Colors.blueAccent, foregroundColor: Colors.white
                      ),
                      child: Text(
                        state is ButtonLoading
                            ? 'Task in progress'
                            : (state is ButtonFailure ? 'Retry' : 'Start task'),
                      ),
                    ),
                    if (state is ButtonLoading)
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessageListUpdated) {
                  return ListView.separated(
                    itemCount: state.messages.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      return ListTile(title: Text(
                          state.messages[index].second,
                          style: TextStyle(color: state.messages[index].first ? Colors.blueAccent : Colors.red)),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
