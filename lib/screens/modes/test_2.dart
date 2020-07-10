import 'package:OnceWing/models/profile.dart';
import 'package:OnceWing/shared/meth.dart';

main() {
  var numPlayers = 8;
  var numCourts = 2;

  Profile p1 = Profile(
      uid: '1',
      name: '1',
      clan: 'W',
      rank: 1200,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p2 = Profile(
      uid: '2',
      name: '2',
      clan: 'W',
      rank: 1300,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p3 = Profile(
      uid: '3',
      name: '3',
      clan: 'W',
      rank: 1400,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p4 = Profile(
      uid: '4',
      name: '4',
      clan: 'W',
      rank: 1500,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p5 = Profile(
      uid: '5',
      name: '5',
      clan: 'W',
      rank: 1600,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p6 = Profile(
      uid: '6',
      name: '6',
      clan: 'W',
      rank: 1700,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p7 = Profile(
      uid: '7',
      name: '7',
      clan: 'W',
      rank: 1800,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p8 = Profile(
      uid: '8',
      name: '8',
      clan: 'W',
      rank: 1900,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p9 = Profile(
      uid: '9',
      name: '1',
      clan: 'W',
      rank: 1200,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p10 = Profile(
      uid: '10',
      name: '10',
      clan: 'W',
      rank: 1300,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p11 = Profile(
      uid: '11',
      name: '11',
      clan: 'W',
      rank: 1400,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p12 = Profile(
      uid: '12',
      name: '12',
      clan: 'W',
      rank: 1500,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p13 = Profile(
      uid: '13',
      name: '13',
      clan: 'W',
      rank: 1600,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p14 = Profile(
      uid: '14',
      name: '14',
      clan: 'W',
      rank: 1700,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p15 = Profile(
      uid: '15',
      name: '15',
      clan: 'W',
      rank: 1800,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);
  Profile p16 = Profile(
      uid: '16',
      name: '16',
      clan: 'W',
      rank: 1900,
      eights: [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ],
      gamesPlayed: 0);

  List testGame0 = [
    [p1, p2, p3, p4]
  ];
  List testGame1 = [
    [p1, p2, p3, p4],
    [p5, p6, p7, p8]
  ];
  List testGame2 = [
    [p1, p2, p3, p4],
    [p5, p6, p7, p8],
    [p9, p10, p11, p12]
  ];
  List testGame3 = [
    [p1, p2, p3, p4],
    [p5, p6, p7, p8],
    [p9, p10, p11, p12],
    [p13, p14, p15, p16]
  ];

  elodif(game, side1wins) {
    var edif = elo(
          average([game[0].rank, game[1].rank]),
          average([game[2].rank, game[3].rank]),
          40,
          40,
          side1wins,
        )[0] -
        average([game[0].rank, game[1].rank]);
    print(average([game[0].rank, game[1].rank]));

    return edif;
  }

  eloDifList(List games, List side1winsList) {
    // takes in a ListOfGame and returns an even ListOfDoubles of differences in ELO
    var listOfEloDif = [];

    for (var i = 0; i < games.length; i++) {
      var game = games[i];

      var edif = elodif(game, side1winsList[i]);

      listOfEloDif.add(edif);
    }

    return listOfEloDif;
  }

  print(eloDifList(testGame3, [false, true, true, false]));
}
