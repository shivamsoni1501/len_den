import 'package:flutter/material.dart';
import 'package:len_den/screens/add_people.dart';
import 'package:len_den/screens/add_transaction.dart';
import 'package:len_den/screens/home.dart';
import 'package:len_den/screens/loading_screen.dart';
import 'package:len_den/screens/login.dart';
import 'package:len_den/model/user_data.dart';
import 'package:len_den/screens/people.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(LenDenApp());
}

class LenDenApp extends StatelessWidget {
  const LenDenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserData(),
      child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Auth(),
      ),
    );
  }
}

class Auth extends StatelessWidget {
   Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    return user.isLoading?LodingScreen():(user.isLoggedIn?MyHomePage() : LoginScreen());
  }
}


class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int cIndex = 0;

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Len Den'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              user.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: (cIndex==0)?HomeScreen():PeopleScreen()
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: cIndex,
        onTap: (val){
          cIndex = val;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            activeIcon: Icon(Icons.people_alt),
            label: 'People',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            builder: (context)=> (cIndex==0)?(AddTrx(user)):(AddPepl(user)),
          );        
        },
      ),
    );
  }
}
