import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:langverse/models/Question.dart';

Future<void> populateDatabase() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<String> categories = ['vocabulary', 'grammar', 'conjugation'];
  List<String> levels = ['beginner', 'intermediate', 'advanced'];

  Map<String, List<Question>> vocabularyQuestions = {
    'beginner': [
      Question(
        id: '',
        title: "Quel est le synonyme de 'heureux' ?",
        answers: ["Triste", "Joyeux", "En colère", "Fatigué"],
        correctAnswerIndex: 1,
      ),
      Question(
        id: '',
        title: "Que signifie le mot 'voiture' ?",
        answers: ["Un fruit", "Un moyen de transport", "Un animal", "Un lieu"],
        correctAnswerIndex: 1,
      ),
      Question(
        id: '',
        title: "Quel est l'opposé de 'grand' ?",
        answers: ["Large", "Immense", "Petit", "Haut"],
        correctAnswerIndex: 2,
      ),
      Question(
        id: '',
        title: "Que signifie le mot 'chat' ?",
        answers: ["Un reptile", "Un oiseau", "Un mammifère", "Un insecte"],
        correctAnswerIndex: 2,
      ),
      Question(
        id: '',
        title: "Quel est le synonyme de 'rapide' ?",
        answers: ["Lent", "Rapide", "Lourd", "Léger"],
        correctAnswerIndex: 1,
      ),
    ],
    'intermediate': [
      Question(
        id: '',
        title: "Que signifie le mot 'ambigu' ?",
        answers: ["Clair", "Vague", "Simple", "Certain"],
        correctAnswerIndex: 1,
      ),
      Question(
        id: '',
        title: "Quel est l'opposé de 'ancien' ?",
        answers: ["Vieux", "Moderne", "Historique", "Primitif"],
        correctAnswerIndex: 1,
      ),
      Question(
        id: '',
        title: "Quel est le synonyme de 'bienveillant' ?",
        answers: ["Gentil", "Cruel", "Fâché", "Méchant"],
        correctAnswerIndex: 0,
      ),
      Question(
        id: '',
        title: "Que signifie le mot 'économe' ?",
        answers: ["Gaspilleur", "Généreux", "Économe", "Somptueux"],
        correctAnswerIndex: 2,
      ),
      Question(
        id: '',
        title: "Quel est le synonyme de 'paresseux' ?",
        answers: ["Actif", "Énergique", "Indolent", "Vigoureux"],
        correctAnswerIndex: 2,
      ),
    ],
    'advanced': [
      Question(
        id: '',
        title: "Que signifie le mot 'obfusquer' ?",
        answers: ["Clarifier", "Simplifier", "Confondre", "Expliquer"],
        correctAnswerIndex: 2,
      ),
      Question(
        id: '',
        title: "Quel est le synonyme de 'éphémère' ?",
        answers: ["Éternel", "Durable", "Éphémère", "Permanent"],
        correctAnswerIndex: 2,
      ),
      Question(
        id: '',
        title: "Quel est l'opposé de 'pernicieux' ?",
        answers: ["Nuisible", "Bénin", "Dangereux", "Fatal"],
        correctAnswerIndex: 1,
      ),
      Question(
        id: '',
        title: "Que signifie le mot 'laconique' ?",
        answers: ["Verbeux", "Bavard", "Concis", "Court"],
        correctAnswerIndex: 3,
      ),
      Question(
        id: '',
        title: "Quel est le synonyme de 'superflu' ?",
        answers: ["Nécessaire", "Supplémentaire", "Vital", "Requis"],
        correctAnswerIndex: 1,
      ),
    ],
  };

  Map<String, List<Question>> grammarQuestions = {
    'beginner': [
      Question(
        id: '',
        title: "Quel mot est un nom ?",
        answers: ["Courir", "Bleu", "Bonheur", "Rapidement"],
        correctAnswerIndex: 2,
      ),
      Question(
        id: '',
        title: "Choisissez la forme verbale correcte : Il _____ à l'école.",
        answers: ["Va", "Vas", "Aller", "Est allé"],
        correctAnswerIndex: 0,
      ),
      Question(
        id: '',
        title: "Quel est un adjectif ?",
        answers: ["Rapidement", "Beau", "Courir", "Bonheur"],
        correctAnswerIndex: 1,
      ),
      Question(
        id: '',
        title: "Sélectionnez l'article correct : J'ai vu _____ éléphant.",
        answers: ["Un", "Une", "Le", "Aucun"],
        correctAnswerIndex: 0,
      ),
      Question(
        id: '',
        title: "Quelle phrase est correcte ?",
        answers: [
          "Elle aimer des pommes.",
          "Elle aime des pommes.",
          "Elle aimant des pommes.",
          "Elle aimé des pommes."
        ],
        correctAnswerIndex: 1,
      ),
    ],
    'intermediate': [
      Question(
        id: '',
        title: "Choisissez le pronom correct : _____ est mon livre.",
        answers: ["Ces", "Ce", "Ceux", "Eux"],
        correctAnswerIndex: 1,
      ),
      Question(
        id: '',
        title:
            "Sélectionnez la préposition correcte : Le chat est _____ la table.",
        answers: ["Dans", "Sur", "À", "Avec"],
        correctAnswerIndex: 1,
      ),
      Question(
        id: '',
        title: "Identifiez le participe passé : Il a _____ la balle.",
        answers: ["Jeté", "Jette", "Jetant", "Jeté"],
        correctAnswerIndex: 3,
      ),
      Question(
        id: '',
        title: "Quelle phrase est à la voix passive ?",
        answers: [
          "Elle lit un livre.",
          "Un livre est lu par elle.",
          "Elle lit un livre.",
          "Elle lira un livre."
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        id: '',
        title:
            "Sélectionnez la conjonction correcte : Je voulais partir, _____ je suis resté à la maison.",
        answers: ["Et", "Mais", "Donc", "Ou"],
        correctAnswerIndex: 1,
      ),
    ],
    'advanced': [
      Question(
        id: '',
        title:
            "Identifiez la proposition subordonnée : Je vous appellerai quand j'arriverai.",
        answers: [
          "Je vous appellerai",
          "Quand j'arriverai",
          "Je vous appellerai",
          "Vous quand j'arriverai"
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        id: '',
        title:
            "Choisissez la forme conditionnelle correcte : Si j'_____ riche, je voyagerais dans le monde.",
        answers: ["Suis", "Étais", "Étais", "Avais été"],
        correctAnswerIndex: 2,
      ),
      Question(
        id: '',
        title: "Quelle phrase utilise le mode subjonctif ?",
        answers: [
          "Je souhaite que je sois plus grand.",
          "Elle est aussi grande que moi.",
          "Si j'étais grand, je serais heureux.",
          "Il souhaite qu'il soit plus grand."
        ],
        correctAnswerIndex: 0,
      ),
      Question(
        id: '',
        title:
            "Sélectionnez la forme correcte du verbe : Le livre, ainsi que le stylo, _____ sur la table.",
        answers: ["Est", "Sont", "Étaient", "Étant"],
        correctAnswerIndex: 0,
      ),
      Question(
        id: '',
        title: "Identifiez le gérondif : Elle aime _____.",
        answers: ["Nager", "Nage", "Nageant", "Nagé"],
        correctAnswerIndex: 2,
      ),
    ],
  };

  Map<String, List<Question>> conjugationQuestions = {
    'beginner': [
      Question(
        id: '',
        title: "Conjuguez le verbe 'être' au présent : Je _____ un étudiant.",
        answers: ["Suis", "Es", "Est", "Être"],
        correctAnswerIndex: 0,
      ),
      Question(
        id: '',
        title: "Conjuguez le verbe 'aller' au passé : Elle _____ au magasin.",
        answers: ["Vais", "Va", "Allé", "Été"],
        correctAnswerIndex: 2,
      ),
      Question(
        id: '',
        title: "Conjuguez le verbe 'avoir' au futur : Ils _____ une fête.",
        answers: ["Ont", "Avoir", "Avoir", "Auront"],
        correctAnswerIndex: 3,
      ),
      Question(
        id: '',
        title:
            "Conjuguez le verbe 'manger' au présent continu : Il _____ le dîner.",
        answers: ["Est manger", "Mange", "Mangeant", "Manger"],
        correctAnswerIndex: 2,
      ),
      Question(
        id: '',
        title: "Conjuguez le verbe 'lire' au passé parfait : J'_____ le livre.",
        answers: ["Ai lu", "A lu", "Lu", "Été lu"],
        correctAnswerIndex: 0,
      ),
    ],
    'intermediate': [
      Question(
        id: '',
        title:
            "Conjuguez le verbe 'voir' au présent parfait : Ils _____ le film.",
        answers: ["Voir", "Voit", "Vu", "Ont vu"],
        correctAnswerIndex: 3,
      ),
      Question(
        id: '',
        title:
            "Conjuguez le verbe 'écrire' au passé continu : Elle _____ une lettre.",
        answers: ["Écrit", "Écrivant", "Était en train d'écrire", "Écrit"],
        correctAnswerIndex: 2,
      ),
      Question(
        id: '',
        title:
            "Conjuguez le verbe 'savoir' au présent parfait continu : Il _____ la connaître depuis des années.",
        answers: ["Sait", "Savait", "A su", "A été en train de savoir"],
        correctAnswerIndex: 3,
      ),
      Question(
        id: '',
        title:
            "Conjuguez le verbe 'prendre' au futur continu : Ils _____ un test.",
        answers: [
          "Prendre",
          "Prendront",
          "Seront en train de prendre",
          "Prendre"
        ],
        correctAnswerIndex: 2,
      ),
      Question(
        id: '',
        title:
            "Conjuguez le verbe 'commencer' au passé parfait continu : J'_____ le projet.",
        answers: [
          "Commencé",
          "Avait commencé",
          "Avait commencé à être",
          "Avait commencé à être commencé"
        ],
        correctAnswerIndex: 1,
      ),
    ],
    'advanced': [
      Question(
        id: '',
        title:
            "Conjuguez le verbe 'conduire' au futur parfait : Demain, elle _____ à l'aéroport.",
        answers: ["Conduit", "Conduira", "Aura conduit", "A conduit"],
        correctAnswerIndex: 2,
      ),
      Question(
        id: '',
        title:
            "Conjuguez le verbe 'parler' au futur parfait continu : Il _____ depuis une heure quand vous arriverez.",
        answers: ["Parle", "Parlait", "Parlera", "Aura parlé"],
        correctAnswerIndex: 3,
      ),
      Question(
        id: '',
        title:
            "Conjuguez le verbe 'donner' au passé parfait : Elle _____ le livre.",
        answers: ["Donne", "A donné", "Avait donné", "A donné"],
        correctAnswerIndex: 2,
      ),
      Question(
        id: '',
        title:
            "Conjuguez le verbe 'courir' au passé parfait continu : Ils _____ depuis une heure quand il a commencé à pleuvoir.",
        answers: [
          "Courez",
          "A couru",
          "Étaient en train de courir",
          "Avaient couru"
        ],
        correctAnswerIndex: 3,
      ),
      Question(
        id: '',
        title:
            "Conjuguez le verbe 'chanter' au futur parfait continu : L'année prochaine, elle _____ dans le chœur depuis cinq ans.",
        answers: ["Chante", "A chanté", "Chantera", "Aura chanté"],
        correctAnswerIndex: 3,
      ),
    ],
  };

  DocumentReference quizDocRef = firestore.collection('Quizzes').doc('french');
  await quizDocRef.set({
    'id': 'french',
    'name': 'French',
  });

  for (String category in categories) {
    DocumentReference categoryDocRef =
        quizDocRef.collection('Categories').doc(category);
    await categoryDocRef.set({
      'id': category,
      'name': category[0].toUpperCase() + category.substring(1),
    });

    for (String level in levels) {
      DocumentReference levelDocRef =
          categoryDocRef.collection('Levels').doc(level);
      await levelDocRef.set({
        'id': level,
        'name': level[0].toUpperCase() + level.substring(1),
      });

      List<Question> questions;
      if (category == 'vocabulary') {
        questions = vocabularyQuestions[level]!;
      } else if (category == 'grammar') {
        questions = grammarQuestions[level]!;
      } else if (category == 'conjugation') {
        questions = conjugationQuestions[level]!;
      } else {
        continue;
      }

      for (Question question in questions) {
        DocumentReference questionDocRef =
            levelDocRef.collection('Questions').doc();
        question.id = questionDocRef.id;
        await questionDocRef.set(question.toMap());
      }
    }
  }

  print('French quiz populated successfully!');
}
