import 'package:flutter/material.dart';
import 'package:len_den/model/user_data.dart';

class AddTrx extends StatefulWidget {
  final int selectedP;
  final UserData user;
  const AddTrx(this.user, {this.selectedP = 0});

  @override
  _AddTrxState createState() => _AddTrxState();
}

class _AddTrxState extends State<AddTrx> {

  int _amount = 0;
  bool _isCredit = true;
  late DateTime _dateTime;
  String _note = 'Shopping';
  int _selectedP = 0;
  late String _selectedMethod;
  List<String> methodList = [
    'Cash',
    'UPI',
    'Bank',
    'Card',
  ];

  @override
  void initState() { 
    super.initState();
    _dateTime = DateTime.now();
    _selectedMethod = methodList[0];
    _selectedP = widget.selectedP;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
            SizedBox(height: 12),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Debit'),
              Switch(
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.red[200],
                value: _isCredit, 
                onChanged: (val){
                  setState(() {
                    _isCredit = val;
                  });
                },
              ),
              Text('Credit'),
            ],
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Amount',
                hintText: '00',
              ),
            onChanged: (val) => _amount = int.parse(val),
          ),
          TextField(
            decoration: InputDecoration(
                labelText: 'Note',
                hintText: 'Shopping',
              ),
            onChanged: (val) => _note = val,
          ),
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.user.people[_selectedP].name),
                PopupMenuButton(
                  icon: Icon(Icons.arrow_drop_down),
                  itemBuilder: (BuildContext bc) {
                    return List.generate(
                      widget.user.people.length, 
                      (index) => PopupMenuItem(
                        child: Text(widget.user.people[index].name),
                        value: index,
                      )
                    ); 
                  },
                  onSelected: (int value) {
                    setState(() {
                      _selectedP = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedMethod),
                PopupMenuButton(
                  icon: Icon(Icons.arrow_drop_down),
                  itemBuilder: (BuildContext bc) {
                    return List.generate(
                      methodList.length, 
                      (index) => PopupMenuItem(
                        child: Text(methodList[index]),
                        value: methodList[index],
                      )
                    ); 
                  },
                  onSelected: (String value) {
                    setState(() {
                      _selectedMethod = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: (){
              showDatePicker(
                context: context, 
                initialDate: DateTime.now(), 
                firstDate: DateTime.now().subtract(Duration(days: 100)), 
                lastDate: DateTime.now(),
              ).then(
                (value) => setState((){
                  _dateTime = value??DateTime.now();
                  }
                )
              );
            }, 
            child: Text(_dateTime.toString().substring(0, 10))
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: (){
              widget.user.addTransaction(_amount, widget.user.people[_selectedP].name, widget.user.people[_selectedP].id, _isCredit, _dateTime, _note, _selectedMethod);
              Navigator.pop(context);
            }, 
            child: Text('ADD'),
          ),
        ],
      ),
    );
  }
}