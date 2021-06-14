import 'package:api_list_example/view/tag/mine_tag.dart';
import 'package:api_list_example/view/tag/movie_tag.dart';
import 'package:api_list_example/view/tag/ranking_tag.dart';
import 'package:http/http.dart' as http;
import 'lib_export.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (BuildContext context) {
          AlbumBottomNavProvider(0);
        },
      )
    ],
    child: MyApp(),
  ));
}

Future<Album> fetchAlbumData(index) async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/$index'));
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Fetch Album Failed!');
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;
  int indexVar = 0;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbumData(1);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Center(
            child: BuildBodyMain(futureAlbum: futureAlbum),
          ),
          bottomNavigationBar: BottomNav(),
        ),
      ),
    );
  }
}

class BuildBodyMain extends StatelessWidget {
  BuildBodyMain({
    Key? key,
    required this.futureAlbum,
  }) : super(key: key);

  final Future<Album> futureAlbum;

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumBottomNavProvider>(
      builder: (context, controller, widget) {
        return FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return getTag(controller.index, snapshot);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        );
      },
    );
  }

  Widget getTag(int index, AsyncSnapshot<Album> album) {
    switch (index) {
      case 1:
        {
          return RankingTag(
            futureAlbum: album,
          );
        }
      case 2:
        {
          return FindTag(
            futureAlbum: album,
          );
        }
      case 3:
        {
          return MineTag(
            futureAlbum: album,
          );
        }
      default:
        {
          return MovieTag(
            futureAlbum: album,
          );
        }
    }
  }
}

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumBottomNavProvider>(
        builder: (context, controller, widget) {
      return BottomNavigationBar(
        onTap: (int index) => controller.index = index,
        currentIndex: controller.index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation),
            label: 'Movie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review_sharp),
            label: 'Ranking',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.find_in_page),
            label: 'Find',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mine',
          ),
        ],
      );
    });
  }
}
