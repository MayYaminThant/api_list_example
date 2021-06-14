import '../lib_export.dart';

class AlbumBottomNavProvider with ChangeNotifier {
  AlbumBottomNavProvider(this._index);

  int _index;

  int get index => _index;

  set index(int index) {
    if (this._index == index) {
      return;
    }

    _index = index;

    this.notifyListeners();
  }
}
