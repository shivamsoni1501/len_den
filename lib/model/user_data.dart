import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserData with ChangeNotifier{
  String email = 'NULL';
  String password = 'NULL';
  String name = 'NULL';
  String id = 'NULL';
  int expiresInSec = 0;
  bool _isLogedIn = false;
  bool isLoading = true;
  
  UserData(){
    fetchPrefs();
  }

  fetchPrefs() async{
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userData = json.decode(prefs.getString('userData')??'{"error": "Error"}');
    print(userData);
    if(!userData.containsKey('error')){
      await this.signIn(userData['email'], userData['password'], true, nameO: userData['name']);
    }
    else{
      isLoading = false;
    }
    notifyListeners();
  }

  get isLoggedIn{
    return _isLogedIn;
  }

  logIn(){
    _isLogedIn = true;
    isLoading = false;
    notifyListeners();
  }

  logout() async{
    this._isLogedIn = false;
    this.email = 'NULL';
    this.password = 'NULL';
    this.name = 'NULL';
    this.id = 'NULL';
    this.expiresInSec = 0;
    this.transactions = [];
    this.people = [];
    this.isLoading = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  List<Transaction> transactions = [];
  List<People> people = [];
  
  toJSON(){
    return json.encode({
      'email': email,
      'password': password,
      'name': name,
      'id': id,
      'expiresIn': expiresInSec,
    });
  }

  signIn(_email, _password, isSignIn, {String nameO = 'NULL'}) async{
    if(isSignIn){
      print('SignIn');
    }
    else{
      print('SignUp');
    }
    Uri url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyB1v1hcCQftQf0qjK5RR3iQrD2zJLcrkgM'); 
    if(!isSignIn){
      url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyB1v1hcCQftQf0qjK5RR3iQrD2zJLcrkgM');
    }
    try{
      dynamic result = await http.post(
        url, 
        body: json.encode(
          {
            "email" : _email,
            "password" : _password,
            "returnSecureToken": true,
          }
        )
      );
      var data = json.decode(result.body);
      print(data);
      this.id = data['localId'];
      this.expiresInSec = int.parse(data['expiresIn']);
      Uri uri = Uri.parse('https://len-den-app-default-rtdb.asia-southeast1.firebasedatabase.app/$id/userData.json');
      if(!isSignIn){
        var jsonData = json.encode({
        'name': nameO,
        'email': _email,
        'password': _password,
        });
        await http.put(uri, body: jsonData);
        this.name = nameO;
      }
      else{
        dynamic data = await http.get(uri);
        var userData = json.decode(data.body);
        this.name = userData['name'];
      }
      this.email = _email;
      this.password = _password;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getString('userData')==null){
        prefs.setString('userData', this.toJSON());
      }

      if(isSignIn){
        await this.fetchData();
      }
      else{
        this.addPeople('Shop', 'Gwalior', '0000000000');
      }

      this.logIn();
      return true;
    }
    catch(e){
      print('Eroor');
      return false;
    }
  }

  fetchData() async{
    try{
      Uri uri = Uri.parse('https://len-den-app-default-rtdb.asia-southeast1.firebasedatabase.app/$id.json');
      dynamic data = await http.get(uri);
      Map<String, dynamic> dData = json.decode(data.body);
      var fTransactions = dData['transactions'] as Map<String, dynamic>;
      print(fTransactions);
      this.transactions.clear();
      fTransactions.forEach((key, value) {
        this.transactions.add(Transaction(key, value['amount'], value['isCredit'], value['toOrFromName'], value['toOrFromId'], DateTime.parse(value['dateTime']), value['method'], value['note']));
      });
      print(dData);
      var fPeople = dData['people'] as Map<String, dynamic>;
      print(fPeople);
      this.people.clear();
      fPeople.forEach((key, value) 
      {
        this.people.add(People(key, value['name'], value['address'], value['number'] ));
      });

      return true;
    }
    catch(e){
      return false;
    }
  }

  addPeople(String nameA, String addressA, String numberA) async{
    print('adding people');
    print(nameA);
    Uri uri = Uri.parse('https://len-den-app-default-rtdb.asia-southeast1.firebasedatabase.app/$id/people.json');
    dynamic data = await http.post(
      uri,
      body: json.encode(
        {
          'name': nameA,
          'address': addressA,
          'number': numberA,
        }
      )
    );
    print(json.decode(data.body));
    people.add(
      People(
        json.decode(data.body)['name'],
        nameA,
        addressA,
        numberA
      )
    );
    notifyListeners();
  }


  addTransaction(amount, toOrFromName, toOrFromId, isCredit, dateTime, note, method) async{
    print('adding transaction');
    Uri uri = Uri.parse('https://len-den-app-default-rtdb.asia-southeast1.firebasedatabase.app/$id/transactions.json');
    dynamic data = await http.post(
      uri,
      body: json.encode(
        {
          'amount': amount,
          'isCredit': isCredit,
          'toOrFromName': toOrFromName,
          'toOrFromId': toOrFromId,
          'dateTime': dateTime.toString(),
          'method': method,
          'note': note,
        }
      )
    );
    transactions.add(Transaction(
      json.decode(data.body)['name'],
      amount,
      isCredit,
      toOrFromName,
      toOrFromId,
      dateTime,
      method,
      note
    ));
    notifyListeners();
  }
}

class People {
  String id;
  String name;
  String contact;
  String address;
  People( this.id, this.name, this.address, this.contact);
}

class Transaction{
  String id;
  String toOrFromName;
  String toOrFromId;
  int amount;
  bool isCredit;
  DateTime dateTime;
  String note;
  String method;
  Transaction(this.id, this.amount, this.isCredit, this.toOrFromName, this.toOrFromId, this.dateTime, this.method, this.note);
}