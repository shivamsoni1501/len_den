import 'dart:ui';

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
  bool _isCredit = false;
  bool _isForInterest = false;
  late DateTime _dateTime;
  String _note = 'Shopping';
  int _selectedP = 0;
  late String _selectedMethod;
  List<String> methodList = [
    'Cash',
    'UPI',
    'Bank',
    'Card',
    'Check',
  ];

    static const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
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
    String date = _dateTime.toString().substring(0, 10);
    return Container(
      decoration: BoxDecoration(        
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(15),
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blueGrey[700], ),
        ),
      ),
      SizedBox(height: 10),
      Container(
        alignment: Alignment.center,
        child: Text('ADD TRANACTION', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 20),)),
      Divider(color: Colors.blueGrey[700], height: 20, thickness: 2,),
      SizedBox(height: 10),

      FittedBox(
                        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is an  ', style: TextStyle(color: Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 14),),
            GestureDetector(
              onTap: (){
                setState(() {
                  _isCredit = false;
                });
              },
                                  child: Column(
                mainAxisSize: MainAxisSize.min,
               children: [
                Container( width: 5, height: 5, decoration: BoxDecoration(color: (!_isCredit)?Colors.red:Colors.blueGrey[200],borderRadius: BorderRadius.circular(5))),
                Text('EXPENSE', style: TextStyle(color: (!_isCredit)?Colors.blueGrey[700]:Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 18),),
               ]
              ),
            ),
            SizedBox(width: 5),
            Text('Or', style: TextStyle(color: Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 14),),
            SizedBox(width: 5),
            GestureDetector(
              onTap: (){
                setState(() {
                  _isCredit = true;
                });
              },
                                  child: Column(
              mainAxisSize: MainAxisSize.min,
               children: [
                Container( width: 5, height: 5, decoration: BoxDecoration(color: (_isCredit)?Colors.green:Colors.blueGrey[200],borderRadius: BorderRadius.circular(5))),
                Text('INCOME', style: TextStyle(color: (_isCredit)?Colors.blueGrey[700]:Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 18),),
               ]
              ),
            ),            
            Text('  ?', style: TextStyle(color: Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 14),),
          ],
        ),
      ),
    SizedBox(height: 15),
      FittedBox(
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Is it for Interest ?  ', style: TextStyle(color: Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 14),),
          GestureDetector(
            onTap: (){
              setState(() {
                _isForInterest = true;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
             children: [
              Text('YES', style: TextStyle(color: (_isForInterest)?Colors.blueGrey[700]:Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 18),),
             ]
            ),
          ),
          SizedBox(width: 5),
          Text('Or', style: TextStyle(color: Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 14),),
          SizedBox(width: 5),
          GestureDetector(
            onTap: (){
              setState(() {
                _isForInterest = false;
              });
            },
            child: Column(
            mainAxisSize: MainAxisSize.min,
             children: [
              Text('NO', style: TextStyle(color: (!_isForInterest)?Colors.blueGrey[700]:Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 18),),
             ]
            ),
          ),            
          Text('  ?', style: TextStyle(color: Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 14),),
        ],
      ),
    ),
    SizedBox(height: 15),
    Text('HOW much is your payment ?', style: TextStyle(color: Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 14),),
    TextField(
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontWeight: FontWeight.bold, 
        wordSpacing: 2, 
        fontSize: 18,
        color: Colors.blueGrey[700],
      ),
      selectionHeightStyle: BoxHeightStyle.includeLineSpacingBottom,
      decoration: InputDecoration(
        prefixText: '₹',
        hintText: '00',
        hintStyle: TextStyle(wordSpacing: 2, color: Colors.blueGrey[100], fontWeight: FontWeight.bold),
      ),              
      onChanged: (val) => _amount = int.parse(val),
      ),
    SizedBox(height: 15),
    Text('On what you spent for ?', style: TextStyle(color: Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 14),),  
    TextField(
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, wordSpacing: 2, color: Colors.blueGrey[700]),
      decoration: InputDecoration(
        prefixText: ' ',
          hintText: 'Give a note',
          hintStyle: TextStyle(wordSpacing: 2, color: Colors.blueGrey[100], fontWeight: FontWeight.bold),
        ),              
      onChanged: (val) => _note = val,
    ),
    SizedBox(height: 15),
    Text('WHERE you spend it ?', style: TextStyle(color: Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 14),),
    PopupMenuButton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.user.people[_selectedP].name, style: TextStyle(color: Colors.blueGrey[700], fontWeight: FontWeight.bold,fontSize: 18),),
          Text(widget.user.people[_selectedP].address, style: TextStyle(color: Colors.blueGrey[400], fontWeight: FontWeight.bold,fontSize: 14),),
          
        ]
      ),
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
    SizedBox(height: 15),
    Text('HOW do you spend it ?', style: TextStyle(color: Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 14),),
    PopupMenuButton(
      child: 
          Text(_selectedMethod, style: TextStyle(color: Colors.blueGrey[700], fontWeight: FontWeight.bold,fontSize: 18),),
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
    SizedBox(height: 15),

    Text('WHEN do you spend it ?', style: TextStyle(color: Colors.blueGrey[200], fontWeight: FontWeight.bold,fontSize: 14),),
    GestureDetector(
      onTap: (){
        showDatePicker(
          context: context, 
          initialDate: DateTime.now(), 
          firstDate: DateTime.now().subtract(Duration(days: 1000)), 
          lastDate: DateTime.now(),
        ).then(
          (value) => setState((){
            _dateTime = value??DateTime.now();
            }
          )
        );
      }, 
      child: Text('${date.substring(8,10)} ${months[int.parse(date.substring(5,7))-1]}, ${date.substring(0,4)}', style: TextStyle(color: Colors.blueGrey[700], fontWeight: FontWeight.bold,fontSize: 18),)
    ),
    SizedBox(height: 20),
    Center(
      child: GestureDetector(
        onTap: (){
          widget.user.addTransaction(_amount, widget.user.people[_selectedP].name, widget.user.people[_selectedP].id, _isCredit, _dateTime, _note, _selectedMethod, isInterest: _isForInterest);
          Navigator.pop(context);
        },
        child: Container(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blueGrey[700]), child: Text('DONE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
      ),
    ),
    SizedBox(height: 20),
        ],
           )       );
  }
}