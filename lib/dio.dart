import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:le_bon_ordre/questionClass.dart';


/// More examples see https://github.com/cfug/dio/blob/main/example
void main() async {
  final dio = Dio();
  final response = await dio.get('http://localhost:8080/questions');
  var questionList = jsonDecode(response.data);
  List<Question> questions= [Question(jsonDecode(questionList[0][0]), jsonDecode(questionList[0][1]), [jsonDecode(questionList[0][2][0]),jsonDecode(questionList[0][2][1]),jsonDecode(questionList[0][2][2]),jsonDecode(questionList[0][2][3]),jsonDecode(questionList[0][2][4])]),Question(questionList[1][0][0], questionList[1][1][0], [questionList[1][2][0],questionList[1][2][1],questionList[1][2][2],questionList[1][2][3],questionList[1][2][4]])];
  print(questions);
}