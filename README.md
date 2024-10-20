# async_button

A button builder widget that handles asynchronous button operations, providing a convenient way to display a loading
state while the async task is being performed.

## Features

- **Asynchronous Handling**: Run async functions when the button is pressed.
- **Loading State**: Automatically disables the button and displays a loading indicator while the task is running.
- **Customizable**: Fully customizable button appearance and behavior through a builder function.

## Installation

Add the following line to your `pubspec.yaml` under `dependencies`:

```yaml
dependencies:
  async_button: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

AsyncButton allows you to easily handle button press events that involve asynchronous operations (such as network
requests). You can customize the button's appearance using the buttonBuilder function.
```dart
AsyncButton(
  onPressedAsync: () async {
    await Future.delayed(const Duration(seconds: 2)); // Async operation
  },
  buttonBuilder: (context, onPressed, working) {
    return ElevatedButton(
      onPressed: onPressed,
      child: working 
        ? CircularProgressIndicator() 
        : Text('Submit'),
    );
  },
)
```