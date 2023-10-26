import 'package:flutter/material.dart';
import 'package:api_consumer/ApiService.dart';
import 'package:api_consumer/UsersModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.roboto(),
          bodyLarge: GoogleFonts.acme(fontSize: 20),
          bodyMedium: GoogleFonts.acme(fontSize: 16),
        )
      ),

    );
  }
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<UsersModel>? _userModel = [];
  int _visibleAddress = -1;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _userModel = (await ApiService().getUsers())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context){
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("REST API CONSUMER",
            style: style),
        backgroundColor: theme.primaryColor,
        centerTitle: true,
      ),
      body: _userModel == null || _userModel!.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
        : CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          enableInfiniteScroll: false,
        ),
        items: _userModel!.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(i.id.toString(), style: const TextStyle(fontSize: 50)),
                        Text("${i.name} - ${i.username}", style: theme.textTheme.bodyLarge),
                        Text(i.email, style: theme.textTheme.bodyMedium),
                        Text(i.phone, style: theme.textTheme.bodyMedium),
                        Text(i.website, style: theme.textTheme.bodyMedium),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _visibleAddress = _userModel!.indexOf(i) == _visibleAddress ? -1 : _userModel!.indexOf(i);
                                  });
                                },
                                child: Text(_userModel!.indexOf(i) == _visibleAddress ? "Hide Address" : "Show Address")
                            ),
                            Visibility(
                                visible: _userModel!.indexOf(i) == _visibleAddress,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(i.address.city),
                                      Text(i.address.street),
                                      Text(i.address.suite),
                                      Text(i.address.zipcode),
                                      Text(i.address.geo.lat),
                                      Text(i.address.geo.lng),
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),

                      ],
                    ),
                  )
              );
            },
          );
        }).toList(),
      )
    ,
    );
  }
/*  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API Example'),
      ),
      body: _userModel == null || _userModel!.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _userModel!.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(_userModel![index].id.toString()),
                    Text(_userModel![index].username),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(_userModel![index].email),
                    Text(_userModel![index].website),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }*/
}