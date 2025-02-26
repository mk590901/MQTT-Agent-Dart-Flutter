import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'button_bloc.dart';
import 'message_bloc.dart';

class ActionsScreen extends StatelessWidget {
  const ActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        debugPrint('******* onPopInvoked($didPop) *******');
        if (didPop) {
          return;
        }
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Exit from app',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text('Are you sure?',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontStyle: FontStyle.italic)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('MQTT Sink App',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.cloud_upload_outlined, color: Colors.white)),
        ),
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
                            backgroundColor: state is ButtonFailure
                                ? Colors.red
                                : Colors.blueAccent,
                            foregroundColor: Colors.white),
                        child: Text(
                          state is ButtonLoading
                              ? 'Task in progress'
                              : (state is ButtonFailure ? 'Retry' : 'GO'),
                        ),
                      ),
                      if (state is ButtonLoading)
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
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
                        return ListTile(
                          title: Text(state.messages[index].second,
                              style: TextStyle(
                                  color: state.messages[index].first
                                      ? Colors.blueAccent
                                      : Colors.red,
                                  fontSize: 14)),
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
      ),
    );
  }
}
