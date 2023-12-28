import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:le_bon_ordre_v2/question.dart';

const String address= 'http://bun.bun.ovh:8081';

Future<List<String>> createGameBack()async{
  final dio = Dio();
  try {
    final response= await dio.get('$address/createGame');
    String code = jsonDecode(response.data);
    return(["0",code]);
  }catch(e){
    return(["1","Impossible de se connecter au serveur."]);
  }

}

Future<String> joinGameBack(String code1)async{
  final dio = Dio();
  try {
    final response= await dio.get('$address/joinGame/$code1');
    String responseDecode = jsonDecode(response.data);
    if(responseDecode=="Vous avez rejoint la partie !"){
      return("0");
    }
    else{
      return(responseDecode);
    }
  }catch(e){
    return("Impossible de se connecter au serveur.");
  }

}

Future<List<Question>> getQuestions(String code) async{
  final dio = Dio();
  try{
    final response = await dio.get('$address/getQuestions?code=$code');
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
    print(questions.length);

    return questions;

  }catch(e){print(e);
  return [];
  }
}

Future<List<dynamic>> sendPoints(code,points, teamNumber, disposition) async{
  String dispositionString = "";
  for (int i =0; i<5;i++){
    dispositionString = dispositionString + disposition[i].toString();
  }
  print(dispositionString);

  final dio = Dio();

  try {
    final response = await dio.get('$address/sendPoints?code=$code&points=$points&teamNumber=$teamNumber&disposition=$dispositionString');

    points=[0,0];
    List<int>disposition3= [];
    List<dynamic> responseDecode=jsonDecode(response.data);
    for ( int i =0; i<responseDecode.length;i++){
      if(i<2){
        points[i] = jsonDecode(responseDecode[i]);
      }else{
        dispositionString = jsonDecode(responseDecode[i]);
      }
    }
    print(dispositionString);
    for (int i =0; i<5;i++){
      disposition3.add(int.parse(dispositionString[i]));
    }
    print([points,disposition3]);
    return [points,disposition3];
  }catch(e){
    print(e);
    return [];
  }

}