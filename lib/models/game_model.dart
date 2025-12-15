class GameModel {
  List<String> board; // 9 cells
  String currentPlayer; 
  bool gameOver;
  String winner; 
  
  GameModel({
    List<String>? board,
    this.currentPlayer = 'X',
    this.gameOver = false,
    this.winner = '',
  }) : board = board ?? List.filled(9, '');
  
  
  bool makeMove(int index) {
    // Check move validity ?
    if (gameOver || board[index].isNotEmpty) {
      return false;
    }
    
    // Place X 
    board[index] = currentPlayer;
    
    
    if (checkWinner()) {
      gameOver = true;
      winner = currentPlayer;
    } else if (board.every((cell) => cell.isNotEmpty)) {
      // Board is full - it's a draw
      gameOver = true;
      winner = 'Draw';
    } else {
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    }
    
    return true;
  }
  
  // Check if player won
  bool checkWinner() {
    // All the winning combinations bellow
    const winPatterns = [
      [0, 1, 2], // Top row
      [3, 4, 5], // Middle row
      [6, 7, 8], // Bottom row
      [0, 3, 6], // Left column
      [1, 4, 7], // Middle column
      [2, 5, 8], // Right column
      [0, 4, 8], // Diagonal top-left to bottom-right
      [2, 4, 6], // Diagonal top-right to bottom-left
    ];
    
    for (var pattern in winPatterns) {
      if (board[pattern[0]] == currentPlayer &&
          board[pattern[1]] == currentPlayer &&
          board[pattern[2]] == currentPlayer) {
        return true;
      }
    }
    
    return false;
  }
  
  // Reset game
  void reset() {
    board = List.filled(9, '');
    currentPlayer = 'X';
    gameOver = false;
    winner = '';
  }
  
  // Game result message
  String getResultMessage() {
    if (!gameOver) return '';
    if (winner == 'Draw') return "It's a Draw!";
    return '$winner Wins!';
  }
}