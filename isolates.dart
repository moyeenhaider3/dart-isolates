import 'dart:async';
import 'dart:isolate';

// Main entry point for the restaurant app
void main() {
  runApp(MyRestaurantApp());
}

// Restaurant app widget
class MyRestaurantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RestaurantHomePage(),
    );
  }
}

// Home page for the restaurant app
class RestaurantHomePage extends StatefulWidget {
  @override
  _RestaurantHomePageState createState() => _RestaurantHomePageState();
}

// State for the home page
class _RestaurantHomePageState extends State<RestaurantHomePage> {
  double _progressValue = 0.0;
  String _result = "";

  /**
   * Simulates cooking a complex feast.
   */
  void prepareFeast() {
    for (int i = 0; i < 1000000000; i++) {
      // Simulating chopping, stirring, seasoning...
    }
  }

  /**
   * Updates the progress bar value.
   */
  void updateProgress(double value) {
    setState(() {
      _progressValue = value;
    });
  }

  /**
   * Updates the result text.
   */
  void updateResult(String result) {
    setState(() {
      _result = result;
    });
  }

  /**
   * Runs the feast preparation on the main thread.
   */
  void runIntenseBusinessLogicOnMainThread() {
    // Clear previous result
    updateResult("");

    // Start progress bar
    updateProgress(0.5);

    // Prepare feast on the main thread
    prepareFeast();

    // Update progress bar to completion
    updateProgress(1.0);

    // Update result
    updateResult("Feast prepared on the main thread!");
  }

  /**
   * Runs the feast preparation using an isolate.
   */
  void runIntenseBusinessLogicWithIsolate() async {
    // Clear previous result
    updateResult("");

    // Start progress bar
    updateProgress(0.5);

    // Create a kitchen hotline to communicate with the secret kitchen
    ReceivePort kitchenHotline = ReceivePort();

    // Send the order to the secret kitchen
    Isolate.spawn(prepareFeastInSecretKitchen, kitchenHotline.sendPort);

    // Listen for updates from the secret kitchen
    kitchenHotline.listen((message) {
      if (message is double) {
        // Update progress bar
        updateProgress(message);
      } else if (message == "done") {
        // Feast is ready!
        updateProgress(1.0);
        updateResult("Feast prepared in the secret kitchen!");
      }
    });

    // Send a "Start cooking!" message to the secret kitchen
    kitchenHotline.send("start");
  }

  /**
   * Secret kitchen chef's recipe for preparing the feast.
   */
  void prepareFeastInSecretKitchen(SendPort sendPort) {
    ReceivePort kitchenHotline = ReceivePort();
    sendPort.send(kitchenHotline.sendPort);

    kitchenHotline.listen((message) {
      if (message == "start") {
        prepareFeast(); // Start cooking the feast
        sendPort.send("done"); // Signal completion
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant Isolate Magic"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: _progressValue,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: runIntenseBusinessLogicOnMainThread,
              child: Text("Run on Main Thread"),
            ),
            ElevatedButton(
              onPressed: runIntenseBusinessLogicWithIsolate,
              child: Text("Run with Secret Kitchen"),
            ),
            SizedBox(height: 20),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
