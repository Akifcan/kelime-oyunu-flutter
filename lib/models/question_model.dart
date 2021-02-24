import 'package:flutter/material.dart';

class QuestionModel {
  bool unlock;
  int id;
  String imageUrl;
  String question;

  QuestionModel(
      {@required this.unlock,
      @required this.id,
      @required this.imageUrl,
      @required this.question});
}
