import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedKrishnaBackground extends StatefulWidget {
  final Widget child;

  const AnimatedKrishnaBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedKrishnaBackground> createState() => _AnimatedKrishnaBackgroundState();
}

class _AnimatedKrishnaBackgroundState extends State<AnimatedKrishnaBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _particleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.5,
              colors: [
                Color(0xFF1E3A8A),
                Color(0xFF0E1446),
                Color(0xFF06091F),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0 + (_glowController.value * 0.3),
                  colors: [
                    Color(0xFFF5C542).withOpacity(0.05 * _glowController.value),
                    Colors.transparent,
                  ],
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlePainter(
                animation: _particleController,
              ),
              size: MediaQuery.of(context).size,
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class ParticlePainter extends CustomPainter {
  final Animation<double> animation;
  final List<Particle> particles = [];

  ParticlePainter({required this.animation}) : super(repaint: animation) {
    for (int i = 0; i < 30; i++) {
      particles.add(Particle());
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    for (var particle in particles) {
      final progress = (animation.value + particle.phase) % 1.0;
      final x = particle.x * size.width;
      final y = size.height * (1 - progress);
      final opacity = (1 - progress) * 0.3;

      paint.color = Color(0xFFF5C542).withOpacity(opacity);
      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  final double x;
  final double phase;
  final double size;

  Particle()
      : x = math.Random().nextDouble(),
        phase = math.Random().nextDouble(),
        size = 1 + math.Random().nextDouble() * 2;
}
