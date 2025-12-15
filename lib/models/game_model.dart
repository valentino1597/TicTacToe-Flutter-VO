class GameModel {
  List<String> board; // for the 9 cells
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
    // Check move validity 
    if (gameOver || board[index].isNotEmpty) {
      return false;
    }
    
    // Place X 
    board[index] = currentPlayer;
    
    
    if (checkWinner()) {
      gameOver = true;
      winner = currentPlayer;
    } else if (board.every((cell) => cell.isNotEmpty)) {
      // Board is full, then that means its a draw logically 
      gameOver = true;
      winner = 'Draw';
    } else {
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    }
    
    return true;
  }
  
  // for checking if player won
  bool checkWinner() {
    // the winning combinations bellow
    const winPatterns = [
      [0, 1, 2], 
      [3, 4, 5], 
      [6, 7, 8], 
      [0, 3, 6], 
      [1, 4, 7], 
      [2, 5, 8], 
      [0, 4, 8], 
      [2, 4, 6], 
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
  
  // for reseting the game
  void reset() {
    board = List.filled(9, '');
    currentPlayer = 'X';
    gameOver = false;
    winner = '';
  }
  
  // result of the game message
  String getResultMessage() {
    if (!gameOver) return '';
    if (winner == 'Draw') return "It's a Draw!";
    return '$winner Wins!';
  }
}
