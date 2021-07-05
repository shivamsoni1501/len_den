import 'package:flutter/material.dart';
import 'package:len_den/model/user_data.dart';
import 'package:len_den/widget/transaction_tile.dart';
import 'package:provider/provider.dart';

import 'add_transaction.dart';

class PeopleTScreen extends StatefulWidget {
  final String id;
  final int index;
  const PeopleTScreen(this.id, this.index);

  @override
  _PeopleTScreenState createState() => _PeopleTScreenState();
}

class _PeopleTScreenState extends State<PeopleTScreen> {
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    List tList = user.transactions.where((element) => element.toOrFromId==widget.id).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Len Den'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tList.length,
        itemBuilder: (context, index){
          return TTile(tList[index]);
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              builder: (context)=> AddTrx(user, selectedP: widget.index,),
            );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}