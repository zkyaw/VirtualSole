import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../connectivity_checker.dart';
import 'measurement_display.dart';
import '../Utils/guide_box.dart';
import '../Utils/measurement_cv.dart'; 

class MeasurementPage extends StatelessWidget {
  final CameraDescription camera;

  const MeasurementPage({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Measurement',
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: TakePictureScreen(camera: camera),
      ),
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({super.key, required this.camera});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize().then((_) {
      _controller.setZoomLevel(2.0);
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takeAndProcessPicture(BuildContext context) async {
    try {
      
      await _initializeControllerFuture;

      final image = await _controller.takePicture();

      if (!mounted) return;
      final result = await processImageViaGCP(image.path);

      if (result['success'] == true) {
        final cmMeasure = result['paperFootRatio'] *
            29.7;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeasurementDisplayPage(cm: cmMeasure),
          ),
        );
      } else {
        throw Exception(
            'Processing failed. Details: ${result['errors']?.join(", ")}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              CameraPreview(_controller),
              Positioned.fill(
                child: IgnorePointer(
                  child: StaticOverlayCamera(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: FloatingActionButton(
                    onPressed: () => _takeAndProcessPicture(context),
                    child: Icon(Icons.camera_alt, size: 24.sp),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
