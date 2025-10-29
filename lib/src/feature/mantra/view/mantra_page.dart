import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/src/feature/mantra/bloc/mantra_cubit.dart';
import 'package:flutter_application_1/src/core/widgets/animated_background.dart';
import 'package:flutter_application_1/src/core/widgets/mala_counter.dart';
import 'package:flutter_application_1/src/core/widgets/glowing_button.dart';
import 'package:flutter_application_1/src/feature/mantra/view/settings_page.dart';
import 'package:flutter_application_1/src/feature/mantra/view/history_page.dart';

class MantraPage extends StatelessWidget {
  const MantraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: Icon(Icons.history, color: Color(0xFFF5C542)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryPage()),
            );
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🦚',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(width: 8),
            Text(
              'Krishna Japa',
              style: TextStyle(
                fontFamily: 'YatraOne',
                fontSize: 24,
                color: Color(0xFFFFFBF7),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Color(0xFFF5C542)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: AnimatedKrishnaBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: const _Body(),
              ),
              const _VoiceButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}


class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          BlocBuilder<MantraCubit, MantraState>(
            buildWhen: (p, c) => p.targetMantras != c.targetMantras,
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFF0E1446).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color(0xFFF5C542).withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFF5C542).withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Current Mantra',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFBF7).withOpacity(0.6),
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      state.targetMantras.first,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'YatraOne',
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFF5C542),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Spacer(),
          BlocBuilder<MantraCubit, MantraState>(
            buildWhen: (p, c) => p.count != c.count,
            builder: (context, state) {
              return MalaCounter(
                count: state.count,
                totalBeads: 108,
                onTap: () => context.read<MantraCubit>().increment(),
              );
            },
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.read<MantraCubit>().increment(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: Color(0xFF10B981).withOpacity(0.5),
                    ),
                    icon: Icon(Icons.add),
                    label: Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showResetDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: Color(0xFFEF4444).withOpacity(0.5),
                    ),
                    icon: Icon(Icons.restart_alt),
                    label: Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Color(0xFF0E1446),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Color(0xFFF5C542).withOpacity(0.3), width: 2),
        ),
        title: Text(
          'Reset Counter?',
          style: TextStyle(
            fontFamily: 'YatraOne',
            color: Color(0xFFF5C542),
          ),
        ),
        content: Text(
          'This will reset your mantra count to zero. This action cannot be undone.',
          style: TextStyle(
            color: Color(0xFFFFFBF7).withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFFFFBF7).withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MantraCubit>().reset();
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFEF4444),
            ),
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _VoiceButton extends StatelessWidget {
  const _VoiceButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MantraCubit, MantraState>(
      buildWhen: (p, c) => p.listening != c.listening,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GlowingButton(
            onPressed: () => context.read<MantraCubit>().toggleListening(),
            label: state.listening ? 'Stop Listening' : 'Start Chanting',
            icon: state.listening ? Icons.mic_off : Icons.mic,
            isActive: state.listening,
          ),
        );
      },
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MantraCubit, MantraState>(
      buildWhen: (p, c) => p.targetMantras != c.targetMantras,
      builder: (context, state) {
        final isSelected = state.targetMantras.map((e) => e.toLowerCase()).contains(label.toLowerCase());
        return FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (value) {
            final current = List<String>.from(state.targetMantras);
            if (value && !isSelected) {
              current.add(label);
            } else if (!value && isSelected) {
              current.removeWhere((e) => e.toLowerCase() == label.toLowerCase());
            }
            context.read<MantraCubit>().setTargetMantras(current);
          },
        );
      },
    );
  }
}

class _AddMantraField extends StatefulWidget {
  @override
  State<_AddMantraField> createState() => _AddMantraFieldState();
}

class _AddMantraFieldState extends State<_AddMantraField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Add custom mantra (e.g., Om namah shivaya)'
            ),
            onSubmitted: (_) => _add(context),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => _add(context),
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _add(BuildContext context) {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    final cubit = context.read<MantraCubit>();
    final current = List<String>.from(cubit.state.targetMantras);
    if (!current.map((e) => e.toLowerCase()).contains(value.toLowerCase())) {
      current.add(value);
      cubit.setTargetMantras(current);
    }
    _controller.clear();
  }
}
