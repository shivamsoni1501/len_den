import 'package:flutter/material.dart';
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
      height: 500,
      padding: EdgeInsets.all(12),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
      width: 50,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
            ),
            SizedBox(height: 12),
            TextField(
      decoration: InputDecoration(
          labelText: 'Name',
          hintText: 'FirstName LastName',
        ),
      onChanged: (val) {
        print(val);
        _name = val;
      },
            ),
            TextField(
      decoration: InputDecoration(
          labelText: 'Address',
          hintText: 'House No. XX, XYZ Colony, City',
        ),
      onChanged: (val) => _address = val,
            ),
            TextField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          labelText: 'Number',
          hintText: 'XXXXXXXXXX',
        ),
      onChanged: (val) => _number = val,
            ),
            SizedBox(height: 20),
            ElevatedButton(
      onPressed: () async{
        print(_name);
        await widget.user.addPeople(_name, _address, _number);
        Navigator.pop(context);
      }, 
      child: Text('ADD')),
            SizedBox(height: 20),
          ],
        ),
    );
  }
}