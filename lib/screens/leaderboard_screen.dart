import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final StorageService _storage = StorageService();
  List<UserStats> _leaderboard = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }
  
  Future<void> _loadLeaderboard() async {
    setState(() => _isLoading = true);
    final leaderboard = await _storage.getLeaderboard();
    setState(() {
      _leaderboard = leaderboard;
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLeaderboard,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _leaderboard.isEmpty
              ? _buildEmptyState()
              : _buildLeaderboard(),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No scores yet!',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Play some games to see rankings here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLeaderboard() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Row(
            children: [
              const SizedBox(width: 40),
              const Expanded(
                flex: 2,
                child: Text(
                  'Player',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Expanded(
                child: Text(
                  'Wins',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Expanded(
                child: Text(
                  'Losses',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Expanded(
                child: Text(
                  'Draws',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        
        // Leaderboard List
        Expanded(
          child: ListView.builder(
            itemCount: _leaderboard.length,
            itemBuilder: (context, index) {
              return _buildLeaderboardTile(_leaderboard[index], index + 1);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildLeaderboardTile(UserStats stats, int rank) {
    Color rankColor = Colors.grey;
    IconData? medalIcon;
    
    // Medal colors for top 3
    if (rank == 1) {
      rankColor = Colors.amber;
      medalIcon = Icons.emoji_events;
    } else if (rank == 2) {
      rankColor = Colors.grey.shade400;
      medalIcon = Icons.emoji_events;
    } else if (rank == 3) {
      rankColor = Colors.brown.shade300;
      medalIcon = Icons.emoji_events;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: SizedBox(
          width: 40,
          child: Row(
            children: [
              if (medalIcon != null)
                Icon(medalIcon, color: rankColor, size: 24)
              else
                Text(
                  '$rank',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                stats.username,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                '${stats.wins}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                '${stats.losses}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                '${stats.draws}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'Win Rate: ${stats.winRate.toStringAsFixed(1)}% • Games: ${stats.totalGames}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}