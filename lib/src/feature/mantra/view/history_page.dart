import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/src/feature/mantra/bloc/mantra_cubit.dart';
import 'package:flutter_application_1/src/core/widgets/animated_background.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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
          'History & Stats',
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
          child: BlocBuilder<MantraCubit, MantraState>(
            builder: (context, state) {
              return ListView(
                padding: EdgeInsets.all(24),
                children: [
                  SizedBox(height: 20),
                  _StatCard(
                    title: 'Total Mantras',
                    value: '${state.count}',
                    icon: Icons.auto_awesome,
                    color: Color(0xFFF5C542),
                  ),
                  SizedBox(height: 16),
                  _StatCard(
                    title: 'Malas Completed',
                    value: '${(state.count / 108).floor()}',
                    icon: Icons.beenhere,
                    color: Color(0xFF10B981),
                  ),
                  SizedBox(height: 16),
                  _StatCard(
                    title: 'Current Mantra',
                    value: state.targetMantras.first,
                    icon: Icons.book_outlined,
                    color: Color(0xFFF7B7A3),
                    isText: true,
                  ),
                  SizedBox(height: 32),
                  _ProgressSection(count: state.count),
                  SizedBox(height: 32),
                  _MilestonesList(count: state.count),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isText;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF0E1446).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFFFFFBF7).withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: isText ? 'YatraOne' : 'Inter',
                    fontSize: isText ? 20 : 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final int count;

  const _ProgressSection({required this.count});

  @override
  Widget build(BuildContext context) {
    final progress = (count % 108) / 108;
    final remaining = 108 - (count % 108);

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF0E1446).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFF5C542).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.track_changes, color: Color(0xFFF5C542), size: 24),
              SizedBox(width: 12),
              Text(
                'Current Mala Progress',
                style: TextStyle(
                  fontFamily: 'YatraOne',
                  fontSize: 18,
                  color: Color(0xFFF5C542),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Color(0xFF1E3A8A).withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF5C542)),
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${count % 108} / 108',
                style: TextStyle(
                  color: Color(0xFFFFFBF7).withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$remaining mantras remaining',
                style: TextStyle(
                  color: Color(0xFFFFFBF7).withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MilestonesList extends StatelessWidget {
  final int count;
  final List<int> milestones = [108, 216, 324, 432, 540, 1008];

  _MilestonesList({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF0E1446).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFF5C542).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: Color(0xFFF5C542), size: 24),
              SizedBox(width: 12),
              Text(
                'Milestones',
                style: TextStyle(
                  fontFamily: 'YatraOne',
                  fontSize: 18,
                  color: Color(0xFFF5C542),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...milestones.map((milestone) {
            final achieved = count >= milestone;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    achieved ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: achieved ? Color(0xFF10B981) : Color(0xFFFFFBF7).withOpacity(0.3),
                    size: 24,
                  ),
                  SizedBox(width: 16),
                  Text(
                    '$milestone Mantras',
                    style: TextStyle(
                      color: achieved
                          ? Color(0xFFFFFBF7)
                          : Color(0xFFFFFBF7).withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: achieved ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (achieved) ...[
                    Spacer(),
                    Text(
                      '🎉',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
