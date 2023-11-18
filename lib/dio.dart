import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:le_bon_ordre/questionClass.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// More examples see https://github.com/cfug/dio/blob/main/example
Future<List<Question>> getQuestions(int nombreManche, String code) async{
  final dio = Dio();
  try{
    final response = await dio.get('http://192.168.1.48:8080/questions?code=$code&nombreManche=$nombreManche');
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

Future<String> createGame(code) async{

  final dio = Dio();

  try {
    final response = await dio.get('http://192.168.1.48:8080/createGame/$code');
    return jsonDecode(response.data);
  }catch(e){
    print(e);
    return(e.toString());
  }
}

Future<List<dynamic>> joinGame(code) async{

  final dio = Dio();

  try {
    final response = await dio.get('http://192.168.1.48:8080/joinGame/$code');
    List<dynamic> responseDecode = jsonDecode(response.data);
    print([jsonDecode(responseDecode[0]),jsonDecode(responseDecode[1])]);

    return [jsonDecode(responseDecode[0]),jsonDecode(responseDecode[1])];
  }catch(e){
    print(e);
    return([e.toString(),0]);
  }
}

Future<void> deleteGame(code) async{

  final dio = Dio();

  try {
    final response = await dio.get('http://192.168.1.48:8080/deleteGame/$code');
    print(jsonDecode(response.data));
  }catch(e){
    print(e);
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
    final response = await dio.get('http://192.168.1.48:8080/sendPoints?code=$code&points=$points&teamNumber=$teamNumber&disposition=$dispositionString');

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


