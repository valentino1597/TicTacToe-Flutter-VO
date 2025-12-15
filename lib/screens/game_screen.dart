import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../models/game_model.dart';
import '../models/user_model.dart';
import 'leaderboard_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameModel game;
  late StorageService storage;
  UserStats? userStats;
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    game = GameModel();
    storage = StorageService();
    _loadUserStats();
  }
  
  Future<void> _loadUserStats() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final stats = await storage.getUserStats(
      authService.userId,
      authService.username,
    );
    setState(() {
      userStats = stats;
      isLoading = false;
    });
  }
  
  Future<void> _updateStats(String result) async {
    if (userStats == null) return;
    
    if (result == 'X') {
      userStats = userStats!.copyWith(wins: userStats!.wins + 1);
    } else if (result == 'O') {
      userStats = userStats!.copyWith(losses: userStats!.losses + 1);
    } else if (result == 'Draw') {
      userStats = userStats!.copyWith(draws: userStats!.draws + 1);
    }
    
    await storage.saveUserStats(userStats!);
    setState(() {});
  }
  
  void _handleCellTap(int index) {
    if (game.makeMove(index)) {
      setState(() {});
      
      if (game.gameOver) {
        _updateStats(game.winner);
        Future.delayed(const Duration(milliseconds: 500), () {
          _showGameOverDialog();
        });
      }
    }
  }
  
  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(game.getResultMessage()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (userStats != null) ...[
              Text('Wins: ${userStats!.wins}'),
              Text('Losses: ${userStats!.losses}'),
              Text('Draws: ${userStats!.draws}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                game.reset();
              });
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaderboardScreen(),
                ),
              );
            },
            child: const Text('Leaderboard'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${authService.username}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaderboardScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Wins', userStats?.wins ?? 0, Colors.green),
                      _buildStatItem('Losses', userStats?.losses ?? 0, Colors.red),
                      _buildStatItem('Draws', userStats?.draws ?? 0, Colors.orange),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  game.gameOver 
                      ? game.getResultMessage()
                      : "Player ${game.currentPlayer}'s Turn",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            return _buildCell(index);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        game.reset();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('New Game'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
  
  Widget _buildCell(int index) {
    return InkWell(
      onTap: () => _handleCellTap(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Center(
          child: Text(
            game.board[index],
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: game.board[index] == 'X' ? Colors.blue : Colors.red,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}