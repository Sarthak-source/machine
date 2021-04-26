import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:machineweb/admin.dart';
import 'package:machineweb/model/models.dart';

import 'package:machineweb/screens/admin/productpage.dart';
import 'package:machineweb/wrapper.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:machineweb/screens/admin/userside/beforesign%20in/auth.dart';

import 'package:machineweb/service/authservice.dart';

import 'model/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    return StreamProvider<AppUser?>.value(
      value: _auth.user(),
      initialData: null,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            elevation: 0,
            color: Colors.white,
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 10,
              primary: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              side: BorderSide(color: Colors.black, width: 2.5),
            ),
          ),
          textTheme: TextTheme(
            button: TextStyle(color: Colors.white),
          ),
          dialogTheme: DialogTheme(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
            contentTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
            ),
          ),
        ),
        routes: {
          Authenticate.route: (context) => Authenticate(),
          Admin.route: (context) => Admin(),
          Wrapper.route: (context) => Wrapper(),
          ShowProduct.route: (context) => ShowProduct(),
        },
        debugShowCheckedModeBanner: false,
        title: 'bean to cup',
        home: MyHomePage(title: 'home'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    card(String i, String content) {
      return InkWell(
        onTap: () {
          print('ok');
          Navigator.pushNamed(
            context,
            ShowProduct.route,
            arguments: ProductArgs(crop: content),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 2.1,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Image.network(
                i,
                alignment: Alignment.center,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
                child: Text(
                  content,
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, Wrapper.route);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: [
                'National packing',
                'lowest price',
                'superior quality',
              ].map(
                (i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(color: Colors.amber),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            i,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            ),
            SizedBox(
              height: 50,
            ),
            card(
                'http://static1.squarespace.com/static/54e730d4e4b0bc2e9a8f31d0/55815e45e4b040cf35c0fa39/5a05791ee4966b4a0839df52/1611671574453/steaming+cup+of+coffee+with+spilt+coffee+beans.jpg?format=1500w',
                'coffee'),
            card(
                'https://media.istockphoto.com/photos/close-up-shot-of-black-pepper-picture-id1033213862?k=6&m=1033213862&s=612x612&w=0&h=yoKQtuNGsOaxKNgnBW1cJU4UDOwsIR0AwzO0NE7CyaI=',
                'pepper'),
            card(
                'http://static1.squarespace.com/static/54e730d4e4b0bc2e9a8f31d0/55815e45e4b040cf35c0fa39/5a05791ee4966b4a0839df52/1611671574453/steaming+cup+of+coffee+with+spilt+coffee+beans.jpg?format=1500w',
                'areca'),
          ],
        ),
      ),
    );
  }
}
