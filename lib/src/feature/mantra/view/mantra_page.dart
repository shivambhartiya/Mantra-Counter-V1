import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/src/feature/mantra/bloc/mantra_cubit.dart';

class MantraPage extends StatelessWidget {
  const MantraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const _AppBar(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const _Body(),
                ),
              ),
              const _Fab(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.self_improvement,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Mantra Counter',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Target word input section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.edit_note, color: Color(0xFF6366F1), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Target Word',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                BlocBuilder<MantraCubit, MantraState>(
                  buildWhen: (p, c) => p.targetWord != c.targetWord,
                  builder: (context, state) {
                    return TextFormField(
                      key: const Key('targetWordField'),
                      decoration: const InputDecoration(
                        hintText: 'Enter your mantra word...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                      initialValue: state.targetWord,
                      onFieldSubmitted: (value) => context.read<MantraCubit>().setTargetWord(value),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Counter display section
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Counter circle
                  BlocBuilder<MantraCubit, MantraState>(
                    buildWhen: (p, c) => p.count != c.count,
                    builder: (context, state) {
                      return Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${state.count}',
                                key: const Key('counterText'),
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -2,
                                ),
                              ),
                              const Text(
                                'repetitions',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF059669)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10B981).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            key: const Key('incrementButton'),
                            onPressed: () => context.read<MantraCubit>().increment(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.add, color: Colors.white, size: 24),
                            label: const Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFEF4444), width: 2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: OutlinedButton.icon(
                            key: const Key('resetButton'),
                            onPressed: () => context.read<MantraCubit>().reset(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.restart_alt, color: Color(0xFFEF4444), size: 24),
                            label: const Text(
                              'Reset',
                              style: TextStyle(
                                color: Color(0xFFEF4444),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Fab extends StatefulWidget {
  const _Fab();

  @override
  State<_Fab> createState() => _FabState();
}

class _FabState extends State<_Fab> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MantraCubit, MantraState>(
      buildWhen: (p, c) => p.listening != c.listening,
      builder: (context, state) {
        if (state.listening && !_pulseController.isAnimating) {
          _pulseController.repeat(reverse: true);
        } else if (!state.listening && _pulseController.isAnimating) {
          _pulseController.stop();
        }

        return GestureDetector(
          onTapDown: (_) => _scaleController.forward(),
          onTapUp: (_) => _scaleController.reverse(),
          onTapCancel: () => _scaleController.reverse(),
          onTap: () => context.read<MantraCubit>().toggleListening(),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: state.listening
                        ? const LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                          )
                        : const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: (state.listening ? const Color(0xFFEF4444) : const Color(0xFF6366F1))
                            .withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: state.listening ? _pulseAnimation.value : 1.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              state.listening ? Icons.mic : Icons.mic_none,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              state.listening ? 'Listening...' : 'Start Voice',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
