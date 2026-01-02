import 'package:shared_preferences/shared_preferences.dart';

class SavedLowonganService {
  static const _key = 'saved_lowongan_ids';

  Future<List<int>> getSavedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key);
    return list?.map(int.parse).toList() ?? [];
  }

  Future<bool> isSaved(int lowonganId) async {
    final ids = await getSavedIds();
    return ids.contains(lowonganId);
  }

  Future<void> toggle(int lowonganId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = await getSavedIds();

    if (ids.contains(lowonganId)) {
      ids.remove(lowonganId);
    } else {
      ids.add(lowonganId);
    }

    await prefs.setStringList(
      _key,
      ids.map((e) => e.toString()).toList(),
    );
  }
}
