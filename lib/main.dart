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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.blueGrey[800],
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
        backgroundColor: Colors.blueGrey[800],
        title: Text('LEN-DEN', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),),
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
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.blueGrey[500],
                height: 100,
                padding: EdgeInsets.all(10), 
                child: CircleAvatar(
                  radius: 30,            
                  child: Text( 
                    (user.name=='NULL')?'':user.name.substring(0,1).toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_box),
                title: Text(user.name, style: TextStyle(color: Colors.blueGrey[700], fontWeight: FontWeight.bold,fontSize: 18)),
              ),
              ListTile(
                leading: Icon(Icons.email_outlined),
                title: Text(user.email, style: TextStyle(color: Colors.blueGrey[700], fontWeight: FontWeight.bold,fontSize: 18)),
              ),
              ListTile(
                leading: Icon(Icons.password),
                title: Text(user.password, style: TextStyle(color: Colors.blueGrey[700], fontWeight: FontWeight.bold,fontSize: 18)),
              ),
            ],
          ),
        ),
      ),

      body: Container(
        alignment: Alignment.center,
        child: (user.isFechingData)?(CircularProgressIndicator()):(cIndex==0)?HomeScreen():PeopleScreen()
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: cIndex,
        onTap: (val){
          cIndex = val;
          setState(() {});
        },
        unselectedItemColor: Colors.blueGrey[400],
        selectedItemColor: Colors.blueGrey[800],
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
        backgroundColor: Colors.blueGrey[800],
        child: Icon(Icons.add),
        onPressed: (){
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context)=> (cIndex==0)?(AddTrx(user)):(AddPepl(user)),
          );        
        },
      ),
    );
  }
}