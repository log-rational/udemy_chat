// Packages
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

const String USER_COLLECTION = "Users";

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  CloudStorageService() {}

  Future<String?> saveUserImageToStorage(
      String _uid, PlatformFile _file) async {
    try {
      Reference _ref = _storage
          .ref()
          .child('/images/users/$_uid/profile.${_file.extension}');
      UploadTask _task = _ref.putFile(File(_file.path));
      return await _task.then((p0) => p0.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
  }

  Future<String?> saveChatImageToStorage(
      String _chatId, String _userId, PlatformFile _file) async {
    try {
      Reference _ref = _storage.ref().child(
          'images/chats/$_chatId/${_userId}_${Timestamp.now().millisecondsSinceEpoch}.${_file.extension}');
      UploadTask _task = _ref.putFile(File(_file.path));
      return await _task.then((p0) => p0.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
  }
}
