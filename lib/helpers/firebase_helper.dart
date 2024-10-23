import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:math_quiz/helpers/index.dart';
import 'package:math_quiz/models/index.dart';

class FirebaseHelper {
  FirebaseHelper._();

  //? Menambah Pertanyaan Kuis Ke Firebase
  static Future<void> addQuestion(QuestionMdl question) async {
    await FirebaseFirestore.instance
        .collection('questions')
        .add(question.toMap());
  }

  //? Menambah Hasil Kuis Ke Firebase
  static Future<void> addResult(ResultMdl result) async {
    final resultsRef = FirebaseFirestore.instance.collection('results');

    final querySnapshot =
        await resultsRef.where('name', isEqualTo: result.name).get();

    if (querySnapshot.docs.isNotEmpty) {
      final existingDocId = querySnapshot.docs.first.id;

      await resultsRef.doc(existingDocId).update(result.toMap());
    } else {
      await resultsRef.add(result.toMap());
    }
  }

  //? Menambah Modul Kuis Ke Firebase
  static Future<void> addModule(ModuleMdl module) async {
    await FirebaseFirestore.instance.collection('modules').add(module.toMap());
  }

  //? Menambah Materi Kuis Ke Firebase
  static Future<void> addPart(PartMdl part) async {
    await FirebaseFirestore.instance.collection('parts').add(part.toMap());
  }

  //? Mengambil Data-Data Kuis Dari Firebase Lalu Dilakukan Knuth Shuffle
  static Future<List<QuestionMdl>> fetchAndShuffleQuestions(
    String partName,
  ) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('questions')
        .where('partName', isEqualTo: partName)
        .get();

    List<QuestionMdl> questions = snapshot.docs
        .map((doc) =>
            QuestionMdl.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    CommonHelper.knuthShuffle(questions);

    return questions;
  }

  //? Mengambil Data-Data Modul Dari Firebase
  static Future<List<ModuleMdl>> fetchModules() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('modules').get();

    List<ModuleMdl> modules = snapshot.docs
        .map((doc) =>
            ModuleMdl.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    return modules;
  }

  //? Mengambil Data-Data Materi Dari Firebase
  static Future<List<PartMdl>> fetchParts(String moduleName) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('parts')
        .where('moduleName', isEqualTo: moduleName)
        .get();

    List<PartMdl> parts = snapshot.docs
        .map((doc) =>
            PartMdl.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    return parts;
  }

  //? Menghapus Satu Pertanyaan
  static Future<void> deleteQuestion(String documentId) async {
    await FirebaseFirestore.instance
        .collection('questions')
        .doc(documentId)
        .delete();
  }

  //? Menghapus Satu Modul
  static Future<void> deleteModule(String documentId) async {
    await FirebaseFirestore.instance
        .collection('modules')
        .doc(documentId)
        .delete();
  }

  //? Menghapus Satu Materi
  static Future<void> deletePart(String documentId) async {
    await FirebaseFirestore.instance
        .collection('parts')
        .doc(documentId)
        .delete();
  }

  static Future<String?> uploadImage(File file) async {
    String fileName = file.path.split('/').last;

    Reference storageRef =
        FirebaseStorage.instance.ref().child('question_images/$fileName');

    UploadTask uploadTask = storageRef.putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
