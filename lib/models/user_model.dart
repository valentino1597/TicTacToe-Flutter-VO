class UserStats {
  final String userId;
  final String username;
  int wins;
  int losses;
  int draws;
  
  UserStats({
    required this.userId,
    required this.username,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
  });
  
  // Total games 
  int get totalGames => wins + losses + draws;
  
  // Win rate percentage using simple maths
  double get winRate {
    if (totalGames == 0) return 0.0;
    return (wins / totalGames) * 100;
  }
  
  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'wins': wins,
      'losses': losses,
      'draws': draws,
    };
  }
  
  // Create from JSON
  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      userId: json['userId'] ?? '',
      username: json['username'] ?? 'Player',
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      draws: json['draws'] ?? 0,
    );
  }
  
  // Create a copy with updated values
  UserStats copyWith({
    String? userId,
    String? username,
    int? wins,
    int? losses,
    int? draws,
  }) {
    return UserStats(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
    );
  }
}