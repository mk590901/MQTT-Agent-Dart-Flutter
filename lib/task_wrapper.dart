//typedef VoidBridgeCallback = void Function(bool retcode, String parameter);

import 'typedef.dart';

class TaskWrapper {
  final List<Function(VoidBridgeCallback)> functions;
  final Function(bool, String) onMessageReceived;
  final Function() onProcessStarted;
  final Function(bool) onProcessCompleted;
  final int nRetries;

  TaskWrapper({
    required this.functions,
    required this.onMessageReceived,
    required this.onProcessStarted,
    required this.onProcessCompleted,
    this.nRetries = 3,
  });

  Future<void> execute() async {
    onProcessStarted();
    bool result = true;
    bool shouldBreak = false;

    for (var function in functions) {
      if (shouldBreak) {
        break;
      }

      int retryCount = 0;
      bool functionSuccess = false;

      while (retryCount < nRetries && !functionSuccess) {
        await function((rc, message) {
          onMessageReceived(rc, message);
          if (!rc) {
            retryCount++;
            if (retryCount >= nRetries) {
              result = false;
              shouldBreak = true;
            }
          } else {
            functionSuccess = true;
          }
        });
      }
    }
    onProcessCompleted(result);
  }
}

