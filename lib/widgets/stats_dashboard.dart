import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/stats_provider.dart';

class StatsDashboard extends ConsumerWidget {
  const StatsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(readingStatsProvider);

    return statsAsync.when(
      data: (stats) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Reading Insights',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _buildSummaryCards(stats),
          const SizedBox(height: 24),
          const Text(
            'Books Finished (2026)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildBooksPerMonthChart(stats),
          const SizedBox(height: 32),
          const Text(
            'Genre Breakdown',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildGenreChart(stats),
          const SizedBox(height: 24),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error loading statistics: $e'),
    );
  }

  Widget _buildSummaryCards(ReadingStats stats) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total Books',
            value: stats.totalBooksFinished.toString(),
            icon: Icons.book,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: 'Total Pages',
            value: stats.totalPagesRead.toString(),
            icon: Icons.auto_stories,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildBooksPerMonthChart(ReadingStats stats) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (stats.booksPerMonth.values.isEmpty 
              ? 5 
              : stats.booksPerMonth.values.reduce((a, b) => a > b ? a : b) + 1).toDouble(),
          barGroups: stats.booksPerMonth.entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.toDouble(),
                  color: Colors.blueAccent,
                  width: 16,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
                  if (value < 1 || value > 12) return const SizedBox.shrink();
                  return Text(months[value.toInt() - 1], style: const TextStyle(fontSize: 10));
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildGenreChart(ReadingStats stats) {
    if (stats.genreBreakdown.isEmpty) {
      return const Center(child: Text('No genre data available'));
    }

    final List<Color> colors = [
      Colors.blue, Colors.red, Colors.green, Colors.yellow, Colors.purple, Colors.orange
    ];

    return Row(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: PieChart(
            PieChartData(
              sections: stats.genreBreakdown.entries.toList().asMap().entries.map((e) {
                final index = e.key;
                final entry = e.value;
                return PieChartSectionData(
                  value: entry.value.toDouble(),
                  color: colors[index % colors.length],
                  radius: 50,
                  showTitle: false,
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 0,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: stats.genreBreakdown.entries.toList().asMap().entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    Container(width: 12, height: 12, color: colors[e.key % colors.length]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${e.value.key} (${e.value.value})',
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
