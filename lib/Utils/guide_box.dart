import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class StaticOverlayCamera extends StatefulWidget {
  @override
  _StaticOverlayCameraState createState() => _StaticOverlayCameraState();
}

class _StaticOverlayCameraState extends State<StaticOverlayCamera> {
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await _cameraController!.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          _buildOverlay(),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Text(
              'Align the A4 paper with the box edges to ensure the correct distance.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Center(
      child: Container(
        width: 150,
        height: 205,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
          color: Colors.transparent,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
