import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/src/feature/mantra/bloc/mantra_cubit.dart';
import 'package:flutter_application_1/src/core/widgets/animated_background.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFF5C542)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'YatraOne',
            fontSize: 24,
            color: Color(0xFFFFFBF7),
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedKrishnaBackground(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              SizedBox(height: 20),
              _SettingsCard(
                title: 'Mantra Selection',
                icon: Icons.book,
                children: [
                  _MantraPresetTile(
                    title: 'Hare Krishna Maha Mantra',
                    subtitle: 'Complete 32-syllable mantra',
                    mantra: 'hare krishna hare krishna krishna krishna hare hare hare ram hare ram ram ram hare hare',
                  ),
                  _MantraPresetTile(
                    title: 'Hare Krishna (Short)',
                    subtitle: '16 names of Krishna',
                    mantra: 'hare krishna',
                  ),
                  _MantraPresetTile(
                    title: 'Om',
                    subtitle: 'Primordial sound',
                    mantra: 'om',
                  ),
                  Divider(color: Color(0xFFF5C542).withOpacity(0.2)),
                  _CustomMantraField(),
                ],
              ),
              SizedBox(height: 20),
              _SettingsCard(
                title: 'Daily Goal',
                icon: Icons.track_changes,
                children: [
                  _GoalSelector(),
                ],
              ),
              SizedBox(height: 20),
              _SettingsCard(
                title: 'About',
                icon: Icons.info_outline,
                children: [
                  ListTile(
                    title: Text(
                      'Krishna Japa Counter',
                      style: TextStyle(
                        color: Color(0xFFFFFBF7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Color(0xFFFFFBF7).withOpacity(0.6),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Powered by Vosk Speech Recognition',
                      style: TextStyle(
                        color: Color(0xFFFFFBF7).withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0E1446).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFF5C542).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFF5C542).withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, color: Color(0xFFF5C542), size: 24),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'YatraOne',
                    fontSize: 20,
                    color: Color(0xFFF5C542),
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _MantraPresetTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String mantra;

  const _MantraPresetTile({
    required this.title,
    required this.subtitle,
    required this.mantra,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MantraCubit, MantraState>(
      builder: (context, state) {
        final isSelected = state.targetMantras.any(
          (m) => m.toLowerCase() == mantra.toLowerCase(),
        );

        return ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: Color(0xFFFFFBF7),
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: Color(0xFFFFFBF7).withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          trailing: isSelected
              ? Icon(Icons.check_circle, color: Color(0xFF10B981))
              : Icon(Icons.circle_outlined, color: Color(0xFFFFFBF7).withOpacity(0.3)),
          onTap: () {
            context.read<MantraCubit>().setTargetMantras([mantra]);
          },
        );
      },
    );
  }
}

class _CustomMantraField extends StatefulWidget {
  @override
  State<_CustomMantraField> createState() => _CustomMantraFieldState();
}

class _CustomMantraFieldState extends State<_CustomMantraField> {
  final TextEditingController _controller = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Custom Mantra',
            style: TextStyle(
              color: Color(0xFFFFFBF7),
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
            color: Color(0xFFF5C542),
          ),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        if (_isExpanded)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  style: TextStyle(color: Color(0xFFFFFBF7)),
                  decoration: InputDecoration(
                    hintText: 'Enter your mantra',
                    hintStyle: TextStyle(
                      color: Color(0xFFFFFBF7).withOpacity(0.4),
                    ),
                    filled: true,
                    fillColor: Color(0xFF1E3A8A).withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFF5C542).withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFF5C542).withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFF5C542),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    final value = _controller.text.trim();
                    if (value.isNotEmpty) {
                      context.read<MantraCubit>().setTargetMantras([value]);
                      _controller.clear();
                      setState(() {
                        _isExpanded = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF5C542),
                    foregroundColor: Color(0xFF0E1446),
                  ),
                  child: Text('Set Mantra'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _GoalSelector extends StatelessWidget {
  final List<int> goals = [108, 216, 324, 1008];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set your daily mantra goal',
            style: TextStyle(
              color: Color(0xFFFFFBF7).withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: goals.map((goal) {
              return ChoiceChip(
                label: Text(
                  '$goal',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: false,
                onSelected: (selected) {
                },
                selectedColor: Color(0xFFF5C542),
                backgroundColor: Color(0xFF1E3A8A).withOpacity(0.5),
                labelStyle: TextStyle(
                  color: Color(0xFFFFFBF7),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 8),
          Text(
            '108 = 1 Mala (Traditional)',
            style: TextStyle(
              color: Color(0xFFFFFBF7).withOpacity(0.5),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
