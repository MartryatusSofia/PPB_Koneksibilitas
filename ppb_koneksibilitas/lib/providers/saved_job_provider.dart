import 'package:flutter/material.dart';
import '../models/saved_job.dart';


class SavedJobProvider with ChangeNotifier {
  final List<SavedJob> _savedJobs = [];

  List<SavedJob> get savedJobs => _savedJobs;

  bool isSaved(int id) {
    return _savedJobs.any((job) => job.id == id);
  }

  void toggleSave(SavedJob job) {
    if (isSaved(job.id)) {
      _savedJobs.removeWhere((j) => j.id == job.id);
    } else {
      _savedJobs.add(job);
    }
    notifyListeners();
  }
}
