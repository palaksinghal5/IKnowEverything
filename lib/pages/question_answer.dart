import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iknoweverything/models/answer.dart';

class QuestionAnswerPage extends StatefulWidget {
  @override
  State<QuestionAnswerPage> createState() => _QuestionAnswerPageState();
}

class _QuestionAnswerPageState extends State<QuestionAnswerPage> {

  /// Text Editing Controller for question text field
  TextEditingController _questionFieldController = TextEditingController();

  /// To Store the cureent answer object
  Answer? _currentAnswer; 

  ///Scaffold key
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Handle the process of getting a Yes/No answer
  _handleGetAnswer() async {
    String questionText = _questionFieldController.text.trim();
    if(
      questionText == null ||
      questionText.length == 0 || 
      questionText[questionText.length-1] != '?'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please ask a valid question.'),
          duration: Duration(seconds: 2),));
        return;
    }
    try {
      http.Response response = await http.get(Uri.parse("https://yesno.wtf/api"));
        if(response.statusCode == 200 && response.body != null){
          Map<String, dynamic> responseBody = json.decode(response.body);
          Answer answer = Answer.fromMap(responseBody);
          setState(() {
            _currentAnswer = answer;
          });
        }
    }
    catch(err, stacktrace) {
      print(err);
      print(stacktrace);
    }
  }

  /// handle reset operation
  _handleResetOperation() {
    _questionFieldController.text = "";
    setState(() {
      _currentAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('I Know Everything'),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 0.5 * MediaQuery.of(context).size.width,
              child: TextField(
                controller: _questionFieldController,
                decoration: InputDecoration(
                  labelText: 'Ask a Question',
                  border: OutlineInputBorder()
                ),
              )),
          SizedBox(
            height: 20
          ),
          if (_currentAnswer != null)
            Stack(
              children: [
                Container(
                  height: 250,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_currentAnswer?.image ??'no answer'),
                    )
                  ),
                ),
                Positioned.fill(
                  bottom: 20,
                  right: 20,
                  child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    _currentAnswer?.answer.toUpperCase() ??'no answer',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                ),)
              ],
            ),
          if (_currentAnswer != null)
            SizedBox(
              height: 20
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _handleGetAnswer, 
                child: Text('Get Answer'),
                style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )
                )
              )),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _handleResetOperation, 
                child: Text('Reset'),
                style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                   )
                )
              ))
            ],
          )
        ],
      ),
    );
  }
}
