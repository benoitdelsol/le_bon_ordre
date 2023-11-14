import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:le_bon_ordre/questionClass.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// More examples see https://github.com/cfug/dio/blob/main/example
Future<List<Question>> getQuestions() async{
  final dio = Dio();

  try{
    final response = await dio.get('http://192.168.0.101:8080/questions');
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

  }catch(e){print(e);
    return [];
  }
}

Future<String> createGame(code) async{

  final dio = Dio();

  try {
    final response = await dio.get('http://192.168.0.101:8080/createGame/$code');
    return jsonDecode(response.data);
  }catch(e){
    print(e);
    return(e.toString());
  }
}

Future<String> joinGame(code) async{

  final dio = Dio();

  try {
    final response = await dio.get('http://192.168.0.101:8080/joinGame/$code');
    return jsonDecode(response.data);
  }catch(e){
    print(e);
    return(e.toString());
  }
}

Future<void> deleteGame(code) async{

  final dio = Dio();

  try {
    final response = await dio.get('http://192.168.0.101:8080/deleteGame/$code');
  }catch(e){
    print(e);
  }

}

Future<List<int>> sendPoints(code,points, teamNumber) async{

  final dio = Dio();
  print('aaahhh');

  try {
    final response = await dio.get('http://192.168.0.101:8080/sendPoints?code=$code&points=$points&teamNumber=$teamNumber');

    points=[0,0];
    print(jsonDecode(response.data).runtimeType);
    print(response.data);
    List<dynamic> responseDecode=jsonDecode(response.data);
    for ( int i =0; i<responseDecode.length;i++){
      print (jsonDecode(responseDecode[i]).runtimeType);
      points[i]=jsonDecode(responseDecode[i]);
    }
    return points;
  }catch(e){
    print(e);
    return [];
  }

}

Future<List<int>> askPoints(code) async{

  final dio = Dio();

  try {
    final response = await dio.get('http://192.168.0.101:8080/sendPoints/$code');
    return jsonDecode(response.data);
  }catch(e){
    print(e);
    return [];
  }

}

List<bool> ready() {
  IO.Socket socket = IO.io('http://192.168.0.101:8080');
  socket.onConnect((_) {
    print('connect');
    socket.emit('msg', 'test');
  });
  socket.on('event', (data) => print(data));
  socket.onDisconnect((_) => print('disconnect'));
  socket.on('fromServer', (_) => print(_));

  return [false, false];

}