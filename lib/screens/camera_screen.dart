// // // import 'package:flutter/material.dart';
// // // import 'package:camera/camera.dart';

// // // class CameraScreen extends StatefulWidget {
// // //   @override
// // //   _CameraScreenState createState() => _CameraScreenState();
// // // }

// // // class _CameraScreenState extends State<CameraScreen> {
// // //   late CameraController _controller;
// // //   late Future<void> _initializeControllerFuture;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _initializeControllerFuture = _initializeCamera();
// // //   }

// // //   Future<void> _initializeCamera() async {
// // //     try {
// // //       final cameras = await availableCameras();
// // //       _controller = CameraController(
// // //         cameras[0],
// // //         ResolutionPreset.medium,
// // //       );
// // //       await _controller.initialize();
// // //     } catch (e) {
// // //       print('Error initializing camera: $e');
// // //     }
// // //   }

// // //   @override
// // //   void dispose() {
// // //     // Dispose of the camera controller when the widget is disposed
// // //     _controller.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Bolt Detection'),
// // //       ),
// // //       body: FutureBuilder<void>(
// // //         future: _initializeControllerFuture,
// // //         builder: (context, snapshot) {
// // //           if (snapshot.connectionState == ConnectionState.done) {
// // //             // If the Future is complete, display the preview
// // //             return CameraPreview(_controller);
// // //           } else {
// // //             // Otherwise, display a loading indicator
// // //             return Center(child: CircularProgressIndicator());
// // //           }
// // //         },
// // //       ),
// // //       floatingActionButton: FloatingActionButton(
// // //         child: Icon(Icons.camera),
// // //         onPressed: () async {
// // //           try {
// // //             // Take a picture and log its file path
// // //             final image = await _controller.takePicture();
// // //             print('Image saved to ${image.path}');
// // //           } catch (e) {
// // //             print('Error: $e');
// // //           }
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:camera/camera.dart';
// // import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
// // import 'dart:typed_data';
// // import 'package:image/image.dart' as img;

// // class CameraScreen extends StatefulWidget {
// //   @override
// //   _CameraScreenState createState() => _CameraScreenState();
// // }

// // class _CameraScreenState extends State<CameraScreen> {
// //   late CameraController _controller;
// //   late Future<void> _initializeControllerFuture;
// //   late tfl.Interpreter _interpreter;
// //   bool _isDetecting = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeControllerFuture = _initializeCamera();
// //     _loadModel();
// //   }

// //   Future<void> _initializeCamera() async {
// //     final cameras = await availableCameras();
// //     _controller = CameraController(
// //       cameras[0],
// //       ResolutionPreset.medium,
// //     );
// //     await _controller.initialize();
// //     setState(() {});
// //   }

// //   Future<void> _loadModel() async {
// //     try {
// //       final interpreterOptions = tfl.InterpreterOptions();
// //       _interpreter = await tfl.Interpreter.fromAsset(
// //         'assets/bolt_best_float32.tflite',
// //         options: interpreterOptions,
// //       );
// //       print('Model loaded successfully');
// //     } catch (e) {
// //       print('Error loading model: $e');
// //       // Handle error appropriately (e.g., display error message)
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   void _startDetecting() {
// //     if (!_isDetecting) {
// //       _isDetecting = true;
// //       _detectObjects();
// //     }
// //   }

// //   Future<void> _detectObjects() async {
// //     while (_isDetecting) {
// //       try {
// //         // Capture a frame
// //         XFile? file = await _controller.takePicture();

// //         // Load the captured image
// //         Uint8List bytes = await file!.readAsBytes();
// //         img.Image image = img.decodeImage(bytes)!;

// //         // Preprocess the image if needed (resize, normalize, etc.)

// //         // Run inference
// //         Uint8List input = imageToByteListUint8(image);
// //         List<dynamic>? output = await _interpreter.run(input);

// //         if (output == null || output.isEmpty) {
// //           throw Exception("Model returned empty output.");
// //         }

// //         // Post-process the output to extract bounding boxes and labels
// //         // Display the predictions on the camera preview
// //         // (You can overlay bounding boxes and labels using CustomPaint)
// //       } catch (e) {
// //         print("Error during inference: $e");
// //         // Handle error appropriately (e.g., stop inference loop, display error message)
// //       }

// //       // Continue detection loop
// //       await Future.delayed(Duration(milliseconds: 100)); // Adjust delay as needed for desired FPS
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Object Detection'),
// //       ),
// //       body: _controller.value.isInitialized
// //           ? Stack(
// //               children: [
// //                 CameraPreview(_controller),
// //                 // Add overlay widget to display bounding boxes and labels here
// //               ],
// //             )
// //           : Center(child: CircularProgressIndicator()),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: _startDetecting,
// //         child: Icon(Icons.camera),
// //       ),
// //     );
// //   }

// //   // Helper method to convert Image to byte list
// //   Uint8List imageToByteListUint8(img.Image image) {
// //     var convertedBytes = Uint8List(1 * image.width * image.height * 3);
// //     var buffer = ByteData.view(convertedBytes.buffer);
// //     int pixelIndex = 0;
// //     for (var i = 0; i < image.height; i++) {
// //       for (var j = 0; j < image.width; j++) {
// //         var pixel = image.getPixel(j, i);
// //         buffer.setUint8(pixelIndex++, (pixel >> 16) & 0xFF);
// //         buffer.setUint8(pixelIndex++, (pixel >> 8) & 0xFF);
// //         buffer.setUint8(pixelIndex++, pixel & 0xFF);
// //       }
// //     }
// //     return convertedBytes;
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
// import 'dart:typed_data';

// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   late tfl.Interpreter _interpreter;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _loadModel();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     _controller = CameraController(
//       cameras[0],
//       ResolutionPreset.medium,
//     );
//     _initializeControllerFuture = _controller.initialize();
//     setState(() {});
//   }

//   Future<void> _loadModel() async {
//     try {
//       final interpreterOptions = tfl.InterpreterOptions();
//       _interpreter = await tfl.Interpreter.fromAsset(
//         'assets/bolt_best_float32',
//         options: interpreterOptions,
//       );
//       print('Model loaded successfully');
//     } catch (e) {
//       print('Error loading model: $e');
//       // Handle error appropriately (e.g., display error message)
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _runModel(CameraImage image) async {
//     // Preprocess the image if needed (resize, normalize, etc.)

//     // Convert the image to a byte list
//     Uint8List input = convertCameraImage(image);

//     // Run inference
//     var output = await _interpreter.run(input);

//     // Process the output (e.g., get predictions)

//     // Visualize predictions on the screen
//     // (You can overlay bounding boxes and labels on the live video feed)
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Camera Screen'),
//       ),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return CameraPreview(_controller);
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           try {
//             await _initializeControllerFuture;
//             _controller.startImageStream((image) => _runModel(image));
//           } catch (e) {
//             print('Error starting camera stream: $e');
//           }
//         },
//         child: Icon(Icons.camera),
//       ),
//     );
//   }

//   Uint8List convertCameraImage(CameraImage image) {
//     // Implement conversion logic from CameraImage to byte list here
//     // This will depend on the format of the camera image and the requirements of your model
//     // You may need to convert formats or resize the image
//     return Uint8List(0);
//   }
// }

// import 'dart:async';
// import 'dart:developer' as developer;
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite/tflite.dart';

// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   List<dynamic>? _output;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _loadModel();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     _controller = CameraController(
//       cameras[0],
//       ResolutionPreset.medium,
//     );
//     _initializeControllerFuture = _controller.initialize();
//     setState(() {});
//   }

//   Future<void> _loadModel() async {
//     try {
//       // Load TFLite model
//       String? res = await Tflite.loadModel(model: 'assets/model.tflite');
//       developer.log('Model loaded successfully: $res');
//     } catch (e) {
//       developer.log('Error loading model: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     Tflite.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Camera Screen'),
//       ),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Stack(
//               children: [
//                 CameraPreview(_controller),
//                 if (_output != null) // Draw bounding boxes if output available
//                   _drawBoundingBoxes(),
//               ],
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _runModelOnFrame,
//         child: Icon(Icons.camera),
//       ),
//     );
//   }

//   Widget _drawBoundingBoxes() {
//     // Your code to draw bounding boxes based on the _output
//     // For demonstration, let's just draw a sample box at top left corner
//     return Positioned(
//       top: 20,
//       left: 20,
//       width: 100,
//       height: 100,
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: Colors.red,
//             width: 2.0,
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _runModelOnFrame() async {
//     try {
//       await _initializeControllerFuture;
//       _controller.startImageStream((CameraImage image) async {
//         // Run inference on frame
//         List<dynamic>? output = await Tflite.runModelOnFrame(
//           bytesList: image.planes.map((e) => e.bytes).toList(),
//           imageHeight: image.height,
//           imageWidth: image.width,
//           rotation: 90,
//         );

//         setState(() {
//           _output = output;
//         });
//       });
//     } catch (e) {
//       developer.log('Error starting camera stream: $e');
//     }
//   }
// }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite/tflite.dart';

// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   List<dynamic>? _output;
//   int frameCounter = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _loadModel();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     _controller = CameraController(
//       cameras[0],
//       ResolutionPreset.medium,
//     );
//     _initializeControllerFuture = _controller.initialize();
//     setState(() {});
//   }

//   Future<void> _loadModel() async {
//     try {
//       // Load YOLO model
//       String? res = await Tflite.loadModel(
//         model: 'assets/model.tflite',
//       );
//       print('Model loaded successfully: $res');
//     } catch (e) {
//       print('Error loading model: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     Tflite.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Camera Screen'),
//       ),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Stack(
//               children: [
//                 CameraPreview(_controller),
//                 if (_output != null) // Draw bounding boxes if output available
//                   _drawBoundingBoxes(),
//               ],
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _runModelOnFrame,
//         child: Icon(Icons.camera),
//       ),
//     );
//   }

//   Widget _drawBoundingBoxes() {
//     // Draw bounding boxes based on the _output
//     List<Widget> boxes = [];
//     for (var i = 0; i < _output!.length; i++) {
//       Map<String, dynamic> box = _output![i];
//       double left = box['rect']['x'] * _controller.value.previewSize!.width;
//       double top = box['rect']['y'] * _controller.value.previewSize!.height;
//       double width = box['rect']['w'] * _controller.value.previewSize!.width;
//       double height = box['rect']['h'] * _controller.value.previewSize!.height;

//       boxes.add(Positioned(
//         left: left,
//         top: top,
//         width: width,
//         height: height,
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.red, width: 2.0),
//           ),
//         ),
//       ));
//     }
//     return Stack(children: boxes);
//   }

//   Future<void> _runModelOnFrame() async {
//     try {
//       await _initializeControllerFuture;
//       _controller.startImageStream((CameraImage image) async {
//         frameCounter++;
//         if (frameCounter == 100) {
//           frameCounter = 0;
//           // Run inference on frame
//           List<dynamic>? output = await Tflite.detectObjectOnFrame(
//             bytesList: image.planes.map((e) => e.bytes).toList(),
//             model: "YOLO", // Change to your model name if different
//             imageHeight: image.height,
//             imageWidth: image.width,
//             imageMean: 0, // Optional
//             imageStd: 255.0, // Optional
//             numResultsPerClass: 1, // Optional
//             threshold: 0.4, // Optional
//           );

//           setState(() {
//             _output = output;
//           });
//         }
//       });
//     } catch (e) {
//       print('Error starting camera stream: $e');
//     }
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<dynamic>? _output;
  int frameCounter = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  Future<void> _loadModel() async {
    try {
      // Load YOLO model
      String? res = await Tflite.loadModel(
        model: 'assets/model.tflite',
      );
      print('Model loaded successfully: $res');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  @override
  void dispose() {
    _controller.stopImageStream(); // Dispose of the image stream
    _controller.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Screen'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                if (_output != null) // Draw bounding boxes if output available
                  _drawBoundingBoxes(),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _runModelOnFrame,
        child: Icon(Icons.camera),
      ),
    );
  }

  Widget _drawBoundingBoxes() {
    // Draw bounding boxes based on the _output
    List<Widget> boxes = [];
    for (var i = 0; i < _output!.length; i++) {
      Map<String, dynamic> box = _output![i];
      double left = box['rect']['x'] * _controller.value.previewSize!.width;
      double top = box['rect']['y'] * _controller.value.previewSize!.height;
      double width = box['rect']['w'] * _controller.value.previewSize!.width;
      double height = box['rect']['h'] * _controller.value.previewSize!.height;

      boxes.add(Positioned(
        left: left,
        top: top,
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 2.0),
          ),
        ),
      ));
    }
    return Stack(children: boxes);
  }

  Future<void> _runModelOnFrame() async {
    try {
      await _initializeControllerFuture;
      _controller.startImageStream((CameraImage image) async {
        frameCounter++;
        if (frameCounter >= 100) {
          frameCounter -= 100; // Reset frame counter
          _controller
              .stopImageStream(); // Stop the image stream to process only one frame
          // Run inference on frame
          List<dynamic>? output = await Tflite.detectObjectOnFrame(
            bytesList: image.planes.map((e) => e.bytes).toList(),
            model: "YOLOv8", // Change to your model name if different
            imageHeight: image.height,
            imageWidth: image.width,
            // imageMean: 0, // Optional
            // imageStd: 255.0, // Optional
            // numResultsPerClass: 1, // Optional
            threshold: 0.1, // Optional
          );

          setState(() {
            _output = output;
          });
        }
      });
    } catch (e) {
      print('Error starting camera stream: $e');
    }
  }
}
