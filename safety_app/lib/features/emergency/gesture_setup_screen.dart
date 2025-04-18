import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class GestureSetupScreen extends StatefulWidget {
  const GestureSetupScreen({super.key});

  @override
  State<GestureSetupScreen> createState() => _GestureSetupScreenState();
}

class _GestureSetupScreenState extends State<GestureSetupScreen> {
  final List<Offset> _points = [];
  bool _isGestureSaved = false;
  bool _isDrawing = false;

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _points.clear();
      _points.add(details.localPosition);
      _isDrawing = true;
      _isGestureSaved = false;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDrawing) return;
    setState(() {
      _points.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDrawing = false;
    });
  }

  void _clearGesture() {
    setState(() {
      _points.clear();
      _isGestureSaved = false;
    });
  }

  Future<void> _saveGesture() async {
    if (_points.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gesture is too short. Please draw a longer pattern.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Save gesture points to local storage
    setState(() {
      _isGestureSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Gesture saved successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Emergency Gesture'),
        centerTitle: true,
        actions: [
          if (_points.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _clearGesture,
              tooltip: 'Clear Gesture',
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.gesture,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Draw Your Emergency Gesture',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Draw a pattern that you can easily remember and reproduce in emergency situations.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: CustomPaint(
                  painter: GesturePainter(
                    points: _points,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Container(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_points.isNotEmpty && !_isGestureSaved)
                  ElevatedButton.icon(
                    onPressed: _saveGesture,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save Gesture'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                if (_isGestureSaved) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Gesture saved successfully! You can now use this gesture for emergency alerts.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: _clearGesture,
                    icon: const Icon(Icons.edit),
                    label: const Text('Draw New Gesture'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GesturePainter extends CustomPainter {
  final List<Offset> points;
  final Color color;

  GesturePainter({
    required this.points,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // Draw the gesture path
    canvas.drawPath(path, paint);

    // Draw start point
    canvas.drawCircle(
      points.first,
      8,
      Paint()
        ..color = color.withOpacity(0.5)
        ..style = PaintingStyle.fill,
    );

    // Draw end point
    canvas.drawCircle(
      points.last,
      8,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(GesturePainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}
