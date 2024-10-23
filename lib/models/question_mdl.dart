class QuestionMdl {
  final String id;
  final String moduleName;
  final String partName;
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String imageUrl;

  QuestionMdl({
    this.id = '',
    this.moduleName = '',
    this.partName = '',
    this.questionText = '',
    this.options = const [],
    this.correctAnswer = '',
    this.imageUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'moduleName': moduleName,
      'partName': partName,
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
      'imageUrl': imageUrl,
    };
  }

  factory QuestionMdl.fromMap(Map<String, dynamic> data, String id) {
    return QuestionMdl(
      id: id,
      questionText: data['questionText'] as String,
      moduleName: data['moduleName'] as String,
      partName: data['partName'] as String,
      options: List<String>.from(data['options'] as List<dynamic>),
      correctAnswer: data['correctAnswer'] as String,
      imageUrl: data['imageUrl'] as String,
    );
  }
}
