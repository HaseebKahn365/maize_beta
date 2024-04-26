//here is a method that resets the firestore levels collection
/*

 */

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> resetLevels() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance; // Create an instance of FirebaseFirestore
  try {
    for (int i = 1; i <= 10; i++) {
      await firestore.collection('levels').doc(i.toString()).set({
        //first position holder
        '1': {
          'uuid': '',
          'time': 500,
          'life': 0,
          'score': 0,
        },
        '2': {
          'uuid': '',
          'time': 500,
          'life': 0,
          'score': 0,
        },
        '3': {
          'uuid': '',
          'time': 500,
          'life': 0,
          'score': 0,
        },
        '4': {
          'uuid': '',
          'time': 500,
          'life': 0,
          'score': 0,
        },
        '5': {
          'uuid': '',
          'time': 500,
          'life': 0,
          'score': 0,
        },
        '6': {
          'uuid': '',
          'time': 500,
          'life': 0,
          'score': 0,
        },
        '7': {
          'uuid': '',
          'time': 500,
          'life': 0,
          'score': 0,
        },
        '8': {
          'uuid': '',
          'time': 500,
          'life': 0,
          'score': 0,
        },
        '9': {
          'uuid': '',
          'time': 500,
          'life': 0,
          'score': 0,
        },
        '10': {
          'uuid': '',
          'time': 500,
          'life': 0,
          'score': 0,
        },
        //thresholds
        '100': {
          'time': 500,
          'life': 0,
          'score': 0,
          'total_participants': 0,
        },
        '200': {
          'time': 500,
          'life': 0,
          'score': 0,
          'total_participants': 0,
        },
        '300': {
          'time': 500,
          'life': 0,
          'score': 0,
          'total_participants': 0,
        },
        '400': {
          'time': 500,
          'life': 0,
          'score': 0,
          'total_participants': 0,
        },
        '500': {
          'time': 500,
          'life': 0,
          'score': 0,
          'total_participants': 0,
        },
        '600': {
          'time': 500,
          'life': 0,
          'score': 0,
          'total_participants': 0,
        },
        '700': {
          'time': 500,
          'life': 0,
          'score': 0,
          'total_participants': 0,
        },
        '800': {
          'time': 500,
          'life': 0,
          'score': 0,
          'total_participants': 0,
        },
        '900': {
          'time': 500,
          'life': 0,
          'score': 0,
          'total_participants': 0,
        },
        '1000': {
          'time': 500,
          'life': 0,
          'score': 0,
          'total_participants': 0,
        },
      });
    }
  } catch (e) {
    print(e);
  }
}

//Now resetting the leaderboard as follows:

/*

await _firestore
          .collection('leaderboard')
          .doc(
            DateTime.now().millisecondsSinceEpoch.toString(),
          )
          .set({
        '1': {
          'uuid': '',
          'levels': 0,
          'collectables': 0,
          'score': 0,
        },
        2: {
          'uuid': '',
          'levels': 0,
          'collectables': 0,
          'score': 0,
        },
        //... and so on upto 10th fiels



       
      }); */

Future<void> resetLeaderBoard() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance; // Create an instance of FirebaseFirestore

  try {
    firestore.collection('leaderboard').doc('leaders').set({
      '1': {
        'uuid': '',
        'levels': 0,
        'collectables': 0,
        'score': 0,
      },
      '2': {
        'uuid': '',
        'levels': 0,
        'collectables': 0,
        'score': 0,
      },
      '3': {
        'uuid': '',
        'levels': 0,
        'collectables': 0,
        'score': 0,
      },
      '4': {
        'uuid': '',
        'levels': 0,
        'collectables': 0,
        'score': 0,
      },
      '5': {
        'uuid': '',
        'levels': 0,
        'collectables': 0,
        'score': 0,
      },
      '6': {
        'uuid': '',
        'levels': 0,
        'collectables': 0,
        'score': 0,
      },
      '7': {
        'uuid': '',
        'levels': 0,
        'collectables': 0,
        'score': 0,
      },
      '8': {
        'uuid': '',
        'levels': 0,
        'collectables': 0,
        'score': 0,
      },
      '9': {
        'uuid': '',
        'levels': 0,
        'collectables': 0,
        'score': 0,
      },
      '10': {
        'uuid': '',
        'levels': 0,
        'collectables': 0,
        'score': 0,
      },
    });
  } catch (e) {
    print(e);
  }
}

//a representative class for a field  in the leaders document
class Leader {
  final String uuid;
  final int levels;
  final int collectables;
  final int score;

  Leader({
    required this.uuid,
    required this.levels,
    required this.collectables,
    required this.score,
  });

  @override
  String toString() {
    return 'Leader:\n{uuid: $uuid, levels: $levels, collectables: $collectables, score: $score}';
  }
}

List<Leader> downloadedLeaders = [];

void checkLeaderAndUpdate(Leader me) {
  for (int i = 0; i < 10; i++) {
    if (me.levels > downloadedLeaders[i].levels) {
      //update the field in firestore document and return
      FirebaseFirestore.instance.collection('leaderboard').doc('leaders').update({
        (i + 1).toString(): {
          'uuid': me.uuid,
          'levels': me.levels,
          'collectables': me.collectables,
          'score': me.score,
        }
      });
      downloadedLeaders[i] = me;
      print('Leader updated at index +1 : ${i + 1}');
      return;
    } else if (me.levels == downloadedLeaders[i].levels && me.collectables > downloadedLeaders[i].collectables) {
      //update the field in firestore document and return
      FirebaseFirestore.instance.collection('leaderboard').doc('leaders').update({
        (i + 1).toString(): {
          'uuid': me.uuid,
          'levels': me.levels,
          'collectables': me.collectables,
          'score': me.score,
        }
      });
      downloadedLeaders[i] = me;
      print('Leader updated at index +1 : ${i + 1}');
      return;
    } else {
      continue;
    }
  }
}

Future<void> downloadLeaders() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance; // Create an instance of FirebaseFirestore

  //fill with empty leaders
  if (downloadedLeaders.isEmpty) {
    for (int i = 0; i < 10; i++) {
      downloadedLeaders.add(Leader(uuid: '', levels: 0, collectables: 0, score: 0));
    }
  }

  //download and modify at the index
  try {
    final leaders = await firestore.collection('leaderboard').doc('leaders').get();
    final data = leaders.data() as Map<String, dynamic>;
    for (int i = 0; i < 10; i++) {
      downloadedLeaders[i] = Leader(
        uuid: data[(i + 1).toString()]['uuid'],
        levels: data[(i + 1).toString()]['levels'],
        collectables: data[(i + 1).toString()]['collectables'],
        score: data[(i + 1).toString()]['score'],
      );
    }
  } catch (e) {
    print(e);
  }
}
