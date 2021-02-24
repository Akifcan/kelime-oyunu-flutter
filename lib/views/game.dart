import 'package:flutter/material.dart';
import 'package:kelimedemo/data/data.dart';
import 'package:kelimedemo/models/question_model.dart';
import 'package:kelimedemo/styles/styles.dart';
import 'package:kelimedemo/views/level.dart';

class Game extends StatefulWidget {
  final QuestionModel question;

  Game({@required this.question});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<String> letters;
  List<String> addedLetters;

  @override
  void initState() {
    super.initState();
    addedLetters = List<String>(widget.question.question.split('').length);
    letters = widget.question.question.split('');
    letters.shuffle();
  }

  compareWord() {
    if (addedLetters.join('') == widget.question.question) {
      QuestionModel nextLevel = questions
          .firstWhere((element) => element.id == widget.question.id + 1);
      setState(() {
        nextLevel.unlock = true;
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Tebrikler 🎉'),
                  content: Text('Yeni seviyeye geçebilirsiniz'),
                  actions: [
                    RaisedButton(
                      child: Text('Ana Menü'),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Level()));
                      },
                    )
                  ],
                ));
      });
    } else {
      print('NOT YET!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.question.imageUrl))),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                        itemCount: addedLetters.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            crossAxisCount: addedLetters.length),
                        itemBuilder: (context, index) =>
                            DragTarget(onAccept: (String data) {
                              setState(() {
                                addedLetters[index] = data;
                                compareWord();
                              });
                            }, builder: (context, _, __) {
                              return GestureDetector(
                                onLongPress: () {
                                  setState(() => addedLetters[index] = null);
                                },
                                child: Container(
                                  color: Colors.grey[400],
                                  child: Center(
                                    child: Text(
                                        addedLetters[index] != null
                                            ? addedLetters[index]
                                            : '?',
                                        style: mainTextStyle),
                                  ),
                                ),
                              );
                            })),
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: letters.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          crossAxisCount: letters.length),
                      itemBuilder: (context, index) => Draggable(
                        data: letters[index],
                        feedback: Container(
                          color: Colors.lightBlue,
                          height: 50,
                          width: 50,
                          child: Center(
                              child:
                                  Text(letters[index], style: mainTextStyle)),
                        ),
                        child: Container(
                          color: Colors.blue[900],
                          child: Center(
                            child: Text(letters[index], style: mainTextStyle),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
