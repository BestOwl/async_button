library async_button;

import 'package:flutter/widgets.dart';

/// A button widget that manages asynchronous operations.
///
/// `AsyncButton` allows you to execute a `Future<void>` callback when the button
/// is pressed. It handles the loading state by disabling the button during the
/// asynchronous operation.
///
/// The button appearance and behavior are customized through the `buttonBuilder`
/// function, which provides access to the button's enabled state and loading status.
///
/// The button remains disabled while the asynchronous task is running and
/// automatically re-enables once the task is complete.
///
/// Example usage:
///
/// ```dart
/// AsyncButton(
///   onPressedAsync: () async {
///     // Perform an asynchronous task
///   },
///   buttonBuilder: (context, onPressed, working) {
///     return ElevatedButton(
///       onPressed: onPressed,
///       child: working ? CircularProgressIndicator() : Text('Submit'),
///     );
///   },
/// )
/// ```
///
/// Parameters:
/// - `onPressedAsync`: A `Future<void>` callback executed when the button is pressed.
/// - `buttonBuilder`: A function to build the button widget, with access to the
///   `onPressed` callback and `working` state (true if the button is currently running the async task).
class AsyncButton extends StatefulWidget {
  const AsyncButton({
    required this.buttonBuilder,
    super.key,
    this.onPressedAsync,
  });

  final Future<void> Function()? onPressedAsync;
  final Widget Function(
          BuildContext context, void Function()? onPressed, bool working)
      buttonBuilder;

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool working = false;

  void handlePressed() async {
    try {
      if (widget.onPressedAsync != null) {
        setState(() {
          working = true;
        });
        await widget.onPressedAsync!.call();
      }
    } finally {
      setState(() {
        working = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.buttonBuilder(
        context,
        widget.onPressedAsync != null && !working
            ? () => handlePressed()
            : null,
        working);
  }
}
