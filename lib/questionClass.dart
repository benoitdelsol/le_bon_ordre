class Question {
  late String type;
  late String titre;
  late List<List<String>> reponses;

  Question(String type, String titre, List<List<String>> reponses) {
    this.type = type;
    this.titre = titre;
    this.reponses = reponses;
  }
}