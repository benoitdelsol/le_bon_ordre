import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:le_bon_ordre/questionClass.dart';

/// More examples see https://github.com/cfug/dio/blob/main/example
Future<List<Question>> getQuestions() async{
  final dio = Dio();
  try{
    final response = await dio.get('http://localhost:8080/questions');
    print('aaaaaaaaa');
    print(response.data);}catch(e){print(e);
  }
  final response = await dio.get('http://10.0.2.2:8080/questions');
  print('bbbbbbbbh');

  List<String> titres = [];
  List<String> type = [];
  List<List<List<String>>> reponses = [];

  int k = 0;

  List<dynamic> questionList = jsonDecode(response.data);
  //List<List<List<String>>> questionList = jsonDecode(response.data);
  for (int i = 0; i < questionList.length; i++) {
    reponses.add([]);
    k=0;
    for (int l=0;l<questionList[i].length;l++) {
      for (int j = 0; j < questionList[i][l].length; j++) {
        if (questionList[i][l][j].runtimeType == String) {
          if (l == 0) {
            titres.add(jsonDecode(questionList[i][l][j]));
          } else if (l == 1) {
            type.add(jsonDecode(questionList[i][l][j]));
          }
        } else if (questionList[i][l][j].runtimeType == List<dynamic>) {
          reponses[i].add([]);
          for (String element in questionList[i][l][j]) {
            reponses[i][k].add(jsonDecode(element));
          }
          k++;
        }
      }
    }
  }

List<Question> questions = [];
  for(int i =0; i<titres.length; i++){
    questions.add(Question(titres[i], type[i], reponses[i]));
  }


  return questions;
}
