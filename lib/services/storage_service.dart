import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _statsKey = 'user_stats';
  static const String _leaderboardKey = 'leaderboard';
  
  // Save user stats
  Future<void> saveUserStats(UserStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(stats.toJson());
    await prefs.setString('${_statsKey}_${stats.userId}', json);
    
    // Also update leaderboard
    await _updateLeaderboard(stats);
  }
  
  // Get user stats
  Future<UserStats?> getUserStats(String userId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('${_statsKey}_$userId');
    
    if (json == null) {
      // Return new stats if none exist
      return UserStats(userId: userId, username: username);
    }
    
    return UserStats.fromJson(jsonDecode(json));
  }
  
  // Update leaderboard
  Future<void> _updateLeaderboard(UserStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing leaderboard
    final leaderboardJson = prefs.getString(_leaderboardKey);
    List<UserStats> leaderboard = [];
    
    if (leaderboardJson != null) {
      final List<dynamic> decoded = jsonDecode(leaderboardJson);
      leaderboard = decoded.map((item) => UserStats.fromJson(item)).toList();
    }
    
    // Remove old entry for this user if exists
    leaderboard.removeWhere((s) => s.userId == stats.userId);
    
    // Add updated stats
    leaderboard.add(stats);
    
    // Sort by wins (descending)
    leaderboard.sort((a, b) => b.wins.compareTo(a.wins));
    
    // Save back
    final jsonList = leaderboard.map((s) => s.toJson()).toList();
    await prefs.setString(_leaderboardKey, jsonEncode(jsonList));
  }
  
  // Get leaderboard
  Future<List<UserStats>> getLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_leaderboardKey);
    
    if (json == null) {
      return [];
    }
    
    final List<dynamic> decoded = jsonDecode(json);
    final leaderboard = decoded.map((item) => UserStats.fromJson(item)).toList();
    
    // Sort by wins
    leaderboard.sort((a, b) => b.wins.compareTo(a.wins));
    
    return leaderboard;
  }
  
  // Clear all data (for testing)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}