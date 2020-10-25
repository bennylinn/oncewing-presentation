import 'dart:collection';
import 'dart:math';

List shuffle(List items) {
  var random = new Random();

  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}

int average(List<int> lon) {
  var result = (lon.reduce((a, b) => a + b) / lon.length).round();
  return result;
}

double kmod(int gamesPlayed) {
  var k = 8400 / (pow(gamesPlayed, 1.25) + 96);
  print(k.toString());
  return k;
}

List<int> elo(int elo1, int elo2, double k1, double k2, bool p1_won) {
  var corr_m = 2.2 / ((elo1 - elo2) * 0.001 + 2.2);

  var rp1 = pow(10, (elo1 / 400));
  var rp2 = pow(10, (elo2 / 400));

  var exp_p1 = rp1 / (rp1 + rp2);
  var exp_p2 = rp2 / (rp1 + rp2);

  int s1;
  int s2;

  if (p1_won) {
    s1 = 1;
    s2 = 0;
  } else {
    s1 = 0;
    s2 = 1;
  }

  var new_elo_1 = (elo1 + corr_m * k1 * (s1 - exp_p1)).round();
  var new_elo_2 = (elo2 + corr_m * k2 * (s2 - exp_p2)).round();

  // print('elo1 is ' + new_elo_1.toString());
  // print('elo2 is ' + new_elo_2.toString());

  return [new_elo_1, new_elo_2];
}

elodif(game, side1wins) {
  var edif = elo(
        average([game[0].rank, game[1].rank]),
        average([game[2].rank, game[3].rank]),
        50,
        50,
        side1wins,
      )[0] -
      average([game[0].rank, game[1].rank]);
  // print(average([game[0].rank, game[1].rank]));

  return edif;
}

elodifNumsOnly(listRank, side1wins) {
  var edif = elo(
        average([listRank[0], listRank[1]]),
        average([listRank[2], listRank[3]]),
        50,
        50,
        side1wins,
      )[0] -
      average([listRank[0], listRank[1]]);
  // print(average([game[0].rank, game[1].rank]));

  return edif;
}

eloDifList(List games, List side1winsList) {
  // takes in a ListOfGame and returns an even ListOfDoubles of differences in ELO
  var listOfEloDif = [];

  for (var i = 0; i < games.length; i++) {
    var game = games[i];

    var edif = elodif(game, side1winsList[i]);

    listOfEloDif.add(edif);
    listOfEloDif.add(-edif);
  }

  return listOfEloDif;
}

eloDifSingle(game, bool side1wins) {
  // takes in a single game and returns a List of ELO changes
  var listOfEloDif = [];

  var edif = elodif(game, side1wins);

  listOfEloDif.add(edif);
  listOfEloDif.add(-edif);

  return listOfEloDif;
}

eloDifSingleNumsOnly(listRank, bool side1wins) {
  // takes in a single game and returns a List of ELO changes
  var listOfEloDif = [];

  var edif = elodifNumsOnly(listRank, side1wins);

  listOfEloDif.add(edif);
  listOfEloDif.add(-edif);

  return listOfEloDif;
}

Map<dynamic, dynamic> parseScoresFromAllScores(Map allScores) {
  Map parsedScoresMap = {};
  SplayTreeMap<dynamic, dynamic>.from(
          allScores, (a, b) => int.parse(a).compareTo(int.parse(b)))
      .forEach((key, value) {
    var currentGame = allScores[key];
    var listUids = currentGame['uids'];
    var listScores = currentGame['scores'];

    for (var i = 0; i < listUids.length; i++) {
      var score;
      var uid = listUids[i];
      if (i < listUids.length / 2) {
        score = listScores[0];
      } else {
        score = listScores[1];
      }

      if (parsedScoresMap.containsKey(uid)) {
        List userTempScores = parsedScoresMap[uid];
        userTempScores.add(score);
        parsedScoresMap[uid] = userTempScores;
      } else {
        parsedScoresMap[uid] = [score];
      }
    }
  });

  return parsedScoresMap;
}
