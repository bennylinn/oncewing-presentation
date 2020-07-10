import 'dart:collection';
void main() {
  List l = ['0', '1', '2', '3', '4', '5', '6', '7'];
  
  int rounds = 7; // # of times we cycle through courts
  int courts = 2; // # of courts (max # = Players/4 floor function)
  
  var numGames = rounds*courts;
  
  List deOrder = [0, 1, 2, 3, 4, 5, 6, 7, 7, 6, 5, 4, 3, 2, 1, 0,
    0, 1, 2, 3, 7, 6, 5, 4, 3, 2, 1, 0, 4, 5, 6, 7, 4, 5, 6, 7,
    0, 1, 2, 3, 7, 6, 5, 4, 0, 1, 2, 3, 4, 5, 6, 7, 3, 2, 1, 0,
  ];
  
  print(deOrder.length);
  
  List getGames(int numGames, List l, List gameOrder) {
    List games = [];
    //accumulate list values
    for(var i=0; i < numGames; i++) {
      var set = i*4;
      var nlist = [l[gameOrder[set]], l[gameOrder[set+1]], l[gameOrder[set+2]], 
        l[gameOrder[set+3]] ];
      games.add(nlist);
    }
    
    return games;
  }

  var games = getGames(10, l, deOrder);
  print(games);

  Queue q = Queue.of(l);

  var onCourt = [q.removeFirst(), q.removeFirst()];
  
  print(onCourt);
}