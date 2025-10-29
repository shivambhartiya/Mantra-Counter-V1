import 'dart:math' as math;
import 'package:flutter/material.dart';

class MalaCounter extends StatefulWidget {
  final int count;
  final int totalBeads;
  final VoidCallback? onTap;

  const MalaCounter({
    super.key,
    required this.count,
    this.totalBeads = 108,
    this.onTap,
  });

  @override
  State<MalaCounter> createState() => _MalaCounterState();
}

class _MalaCounterState extends State<MalaCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _previousCount = widget.count;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didUpdateWidget(MalaCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != _previousCount) {
      _controller.forward(from: 0);
      _previousCount = widget.count;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1.0 + (0.15 * math.sin(_controller.value * math.pi));
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFFF5C542),
                    Color(0xFFD4AF37),
                    Color(0xFFB8860B),
                  ],
                  stops: [0.0, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF5C542).withOpacity(0.6),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(280, 280),
                    painter: MalaBeadsPainter(
                      currentBead: widget.count % widget.totalBeads,
                      totalBeads: widget.totalBeads,
                      glowProgress: _controller.value,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.count}',
                        style: TextStyle(
                          fontFamily: 'YatraOne',
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0E1446),
                          height: 1,
                          shadows: [
                            Shadow(
                              color: Colors.white.withOpacity(0.5),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'mantras',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0E1446).withOpacity(0.8),
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${(widget.count / widget.totalBeads).floor()} malas',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0E1446).withOpacity(0.6),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MalaBeadsPainter extends CustomPainter {
  final int currentBead;
  final int totalBeads;
  final double glowProgress;

  MalaBeadsPainter({
    required this.currentBead,
    required this.totalBeads,
    required this.glowProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final beadRadius = 3.0;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    for (int i = 0; i < totalBeads; i++) {
      final angle = (i / totalBeads) * 2 * math.pi - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i < currentBead) {
        paint.color = Color(0xFF0E1446);
        canvas.drawCircle(Offset(x, y), beadRadius, paint);
      } else if (i == currentBead) {
        final glowSize = beadRadius + (3 * glowProgress);
        paint.color = Colors.white.withOpacity(0.5 * (1 - glowProgress));
        canvas.drawCircle(Offset(x, y), glowSize, paint);

        paint.color = Color(0xFF0E1446);
        canvas.drawCircle(Offset(x, y), beadRadius, paint);
      } else {
        paint.color = Color(0xFF0E1446).withOpacity(0.3);
        canvas.drawCircle(Offset(x, y), beadRadius * 0.7, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MalaBeadsPainter oldDelegate) {
    return oldDelegate.currentBead != currentBead ||
        oldDelegate.glowProgress != glowProgress;
  }
}
