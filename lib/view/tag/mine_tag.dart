import '../../lib_export.dart';

class MineTag extends StatelessWidget {
  const MineTag({Key? key, required this.futureAlbum}) : super(key: key);

  final AsyncSnapshot<Album> futureAlbum;

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumBottomNavProvider>(
        builder: (context, controller, widget) {
      return Text(this.futureAlbum.data!.title);
    });
  }
}
