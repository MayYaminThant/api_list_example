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
          return AlbumBottomNavProvider(0);
        },
      ),
    ],
    child: MyApp(),
  ));
}

Future<Album> fetchAlbumData(index) async {
  int position = index + 1;
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/$position'));
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
  int position = 0;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbumData(position);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
            child: buildCustomBody(),
          ),
          bottomNavigationBar: buildCustomBotNavBar(),
        ),
      ),
    );
  }

  Consumer<AlbumBottomNavProvider> buildCustomBotNavBar() {
    return Consumer<AlbumBottomNavProvider>(
        builder: (context, controller, widget) {
      return BottomNavigationBar(
        onTap: (int index) => {controller.index = index, position = index},
        currentIndex: controller.index,
        items: [
          buildBottomNavigationBarItem(
            Icon(Icons.movie_creation),
            'Movie',
          ),
          buildBottomNavigationBarItem(
            Icon(Icons.rate_review_sharp),
            'Ranking',
          ),
          buildBottomNavigationBarItem(
            Icon(Icons.find_in_page),
            'Find',
          ),
          buildBottomNavigationBarItem(
            Icon(Icons.person),
            'Mine',
          ),
        ],
      );
    });
  }

  Consumer<AlbumBottomNavProvider> buildCustomBody() {
    return Consumer<AlbumBottomNavProvider>(
      builder: (context, controller, widget) {
        position = controller.index;
        futureAlbum = fetchAlbumData(position);
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

  BottomNavigationBarItem buildBottomNavigationBarItem(
      Icon icon, String label) {
    return BottomNavigationBarItem(
      icon: icon,
      label: label,
      backgroundColor: Colors.blue,
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
