import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserData with ChangeNotifier{
  String email = 'NULL';
  String password = 'NULL';
  String name = 'NULL';
  String id = 'NULL';
  DateTime expiredate = DateTime.now();
  bool _isLogedIn = false;

  get isLoggedIn{
    return _isLogedIn;
  }
  
  List<Transaction> transactions = [];
  List<People> people = [];
  List<String> methods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'UPI'
  ];

  bool isLoading = true;
  bool isFechingData = true;

  UserData(){
    _fetchPrefs();
  }

  _fetchPrefs() async{
    List<dynamic> result = await _fromJson();
    print(result);
    if(result[0]){
      this._isLogedIn = true;
      this.isLoading = false;
      notifyListeners();
      print('data found in shared preferences');
      if(result[5].isAfter(DateTime.now())){
        _isLogedIn = true;
        notifyListeners();
        print('Expiry data is not crossed yet');
        bool res = await _fetchData(result[5], result[4]);
        if(res){
          print('successfully fetched the data');
        }
        else{
          print('error in fetching data');
        }
      }
      else{
        print('Expiry data is crossed');
        loginToSystem(result[2], result[3]);
      }
    }
    else{
      print('No data in shared preferences');
      this.isLoading = false;
      notifyListeners();
    }
  }

  loginToSystem(_email, _password, {isLoginT = true, nameT = 'NULL'}) async{
    try{
    print(_email);
    print(isLoginT);
    List<dynamic> expAid = await this._logInData(_email, _password, isLoginT);
    print(expAid);
    if(expAid[0]){
      _isLogedIn = true;
      notifyListeners();
      print('login successful');

      Uri uri = Uri.parse('https://len-den-app-default-rtdb.asia-southeast1.firebasedatabase.app/${expAid[2]}/userData.json');
      if(!isLoginT){
        var jsonData = json.encode({
        'name': nameT,
        'email': _email,
        'password': _password,
        });
        await http.put(uri, body: jsonData);
      }

      bool res = await _fetchData(expAid[1], expAid[2]);
      if(res){
        print('successfully fetched the data');
      }
      else{
        print('error in fetching data');
      }
      if(!isLoginT){
        await this.addPeople('Shop', 'Gwalior', '0000000000');
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      prefs.setString('userData', this._toJSON());
      }
      else{
        print('failed to login');
        return false;
      }
    return true;
    }
    catch(e){
    return false;
    }
  }

  Future<List<dynamic>> _logInData(_email, _password, _isLogin) async{
    if(_isLogin){
      print('SignIn');
    }
    else{
      print('SignUp');
    }
    Uri url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyB1v1hcCQftQf0qjK5RR3iQrD2zJLcrkgM'); 
    if(!_isLogin){
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
      dynamic data = json.decode(result.body);
      print(data['expiresIn']);
      print(data['localId']);
      return [true, DateTime.now().add(Duration(seconds: int.parse(data['expiresIn']))), data['localId']];
    }catch(e){
      return [false];
    }
  }

  logout() async{
    this._isLogedIn = false;
    this.email = 'NULL';
    this.password = 'NULL';
    this.name = 'NULL';
    this.id = 'NULL';
    this.expiredate = DateTime.now();
    this.transactions = [];
    this.people = [];
    this.isLoading = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }
  
  _toJSON(){
    return json.encode({
      'email': email,
      'password': password,
      'name': name,
      'id': id,
      'expiredate': expiredate.toString(),
    });
  }

  _fromJson() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = json.decode(prefs.getString('userData')??'{"error": "Error"}');
    print(data);
    if(!data.containsKey('error')){
      return [true, data['name'], data['email'], data['password'], data['id'], DateTime.parse(data['expiredate'])];
    }
    else{
      return [false];
    }
  }

  _saveData(nameT, emailT, passwordT, idT, expiredateT){
    this.name = nameT;
    this.email = emailT;
    this.password = passwordT;
    this.id = idT;
    this.expiredate = expiredateT;
  }

  _fetchData(_expireDate, _id) async{
    try{
      this.isFechingData = true;
      notifyListeners();
      print(_expireDate);
      print(_id);
      Uri uri = Uri.parse('https://len-den-app-default-rtdb.asia-southeast1.firebasedatabase.app/$_id.json');
      dynamic data = await http.get(uri);
      Map<String, dynamic> dData = json.decode(data.body);
      print(dData['userData']);

      var fUserData = dData['userData'];
      print(fUserData);
      _saveData(fUserData['name']??'NULL', fUserData['email']??'NULL', fUserData['password']??'NULL', _id, _expireDate);

      if(dData.containsKey('transactions')){
        var fTransactions = dData['transactions'] as Map<String, dynamic>;
        print(fTransactions);
        this.transactions.clear();
        fTransactions.forEach((key, value) {
          this.transactions.add(Transaction(key, value['amount'], value['isCredit'], value['toOrFromName'], value['toOrFromId'], DateTime.parse(value['dateTime']), value['method'], value['note'], value['isForInterest']));
        });
      }

      var fPeople = dData['people'];
      print(fPeople);
      this.people.clear();
      fPeople.forEach((key, value)
      {
        this.people.add(People(key, value['name'], value['address'], value['number'] ));
      });
      isFechingData = false;
      notifyListeners();
      return true;
    }
    catch(e){
      isFechingData = false;
      notifyListeners();
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

  addTransaction(amount, toOrFromName, toOrFromId, isCredit, dateTime, note, method, {isInterest = false}) async{
    print('adding transaction');
    Uri uri = Uri.parse('https://len-den-app-default-rtdb.asia-southeast1.firebasedatabase.app/${this.id}/transactions.json');
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
          'isForInterest': isInterest,
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
      note,
      isInterest
    ));
    notifyListeners();
  }

deleteTranaction(String _id) async{
  print('deleting transaction');
    Uri uri = Uri.parse('https://len-den-app-default-rtdb.asia-southeast1.firebasedatabase.app/${this.id}/transactions/$_id.json');
    dynamic data = await http.delete(
      uri,
    );
    print(data);
    print('deleted');
    this.transactions.removeWhere((element) => element.id==_id);
  }

  deletePeople(String _id) async{
    print('deleting People');
    this.transactions.where((element) =>
      element.toOrFromId == _id
    ).forEach((element) async{ 
      await this.deleteTranaction(element.id);
    });
    Uri uri = Uri.parse('https://len-den-app-default-rtdb.asia-southeast1.firebasedatabase.app/${this.id}/people/$_id.json');
    dynamic data = await http.delete(
      uri,
    );
    print(data);
    print('deleted');
    this.people.removeWhere((element) => element.id==_id);
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
  bool isForInterest;
  DateTime dateTime;
  String note;
  String method;
  Transaction(this.id, this.amount, this.isCredit, this.toOrFromName, this.toOrFromId, this.dateTime, this.method, this.note, this.isForInterest);
}