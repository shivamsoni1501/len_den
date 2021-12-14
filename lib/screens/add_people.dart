import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:len_den/model/user_data.dart';

class AddPepl extends StatefulWidget {
  final UserData user;
  AddPepl(this.user);

  @override
  _AddPeplState createState() => _AddPeplState();
}

class _AddPeplState extends State<AddPepl> {
  String _name = 'XYZ SHOP';

  String _address = 'XYZ COLONY, X-City';

  String _number = '0000000000';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 70,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey[700],
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
              alignment: Alignment.center,
              child: Text(
                'ADD PERSON',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 20),
              )),
          Divider(
            color: Colors.blueGrey[700],
            height: 20,
            thickness: 2,
          ),
          SizedBox(height: 15),
          FittedBox(
            child: Text(
              'NAME of Person',
              style: TextStyle(
                  color: Colors.blueGrey[500],
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          TextField(
            keyboardType: TextInputType.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              wordSpacing: 2,
              fontSize: 18,
              color: Colors.blueGrey[700],
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(0),
              hintText: 'Give a Name',
              hintStyle: TextStyle(
                  wordSpacing: 2,
                  color: Colors.blueGrey[200],
                  fontWeight: FontWeight.bold),
            ),
            onChanged: (val) => _name = val,
          ),
          SizedBox(height: 15),
          Text(
            'ADDRESS of Person',
            style: TextStyle(
                color: Colors.blueGrey[500],
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
          TextField(
            keyboardType: TextInputType.streetAddress,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              wordSpacing: 2,
              fontSize: 18,
              color: Colors.blueGrey[700],
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(0),
              hintText: 'Add an Address',
              hintStyle: TextStyle(
                  wordSpacing: 2,
                  color: Colors.blueGrey[200],
                  fontWeight: FontWeight.bold),
            ),
            onChanged: (val) => _address = val,
          ),
          SizedBox(height: 15),
          Text(
            'NUMBER of Person',
            style: TextStyle(
                color: Colors.blueGrey[500],
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
          TextField(
            keyboardType: TextInputType.phone,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              wordSpacing: 2,
              fontSize: 18,
              color: Colors.blueGrey[700],
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(0),
              hintText: 'Give a Number',
              hintStyle: TextStyle(
                  wordSpacing: 2,
                  color: Colors.blueGrey[200],
                  fontWeight: FontWeight.bold),
            ),
            onChanged: (val) => _number = val,
          ),
          SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () async {
                print(_name);
                widget.user.addPeople(_name, _address, _number);
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blueGrey[700]),
                child: Text(
                  'DONE',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 200,
          ),
        ],
      ),
    );
  }
}
