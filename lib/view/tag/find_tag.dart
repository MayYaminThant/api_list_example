import '../../lib_export.dart';

class FindTag extends StatelessWidget {
  const FindTag({Key? key, required this.futureAlbum}) : super(key: key);

  final AsyncSnapshot<Album> futureAlbum;

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumBottomNavProvider>(
        builder: (context, controller, widget) {
      return Text(this.futureAlbum.data!.title);
    });
  }
}
