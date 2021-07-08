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
    int tCredit = 0;
    int tDebit = 0;
    int leftInterest = 0;
    List<Transaction> tList = user.transactions.where((element) => element.toOrFromId==widget.id).toList();
    tList.sort( (b, a) => a.dateTime.compareTo(b.dateTime));
    List.generate(tList.length, (index) {
      if(tList[index].isForInterest){
        if(tList[index].isCredit){
          leftInterest -= tList[index].amount;
        }
        else{
        leftInterest += tList[index].amount;
        }
      }
      else{
        if(tList[index].isCredit){
          tCredit += tList[index].amount;
        }
        else{
          tDebit += tList[index].amount;
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('LEN-DEN', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),),
        centerTitle: true,
        bottom: (tCredit==0 && tDebit ==0 && leftInterest==0)?null:
        AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(tDebit!=0)
              Expanded(
               child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Container( width: 5, height: 5, decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(5))),
                    Text('TOTAL DEBIT', style: TextStyle(fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.bold),),
                    Text(tDebit.toString()),
                  ],
                ),
              ),
              if(tDebit!= 0)
              SizedBox(width: 5),
              if(tCredit!=0)
              Expanded(
               child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Container( width: 5, height: 5, decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(5))),

                    Text('TOTAL CREDIT', style: TextStyle(fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.bold),),
                    Text(tCredit.toString()),
                  ],
                ),
              ),
              if(tCredit!=0)
              SizedBox(width: 5),
              if(leftInterest!=0)
              Expanded(
               child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container( width: 5, height: 5, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5))),

                    Text('INTEREST BALANCE', style: TextStyle(fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.bold),),
                    Text(leftInterest.toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: (tCredit==0 && tDebit ==0 && leftInterest==0)?Center(child: Text('No Transactions Yet!!\nTry Add Some.', style: TextStyle(fontSize: 16, color: Colors.blueGrey[400], fontWeight: FontWeight.bold), textAlign: TextAlign.center,),):ListView.builder(
        itemCount: tList.length,
        itemBuilder: (context, index){
          return Dismissible(
          key: ValueKey(tList[index].id),
          background: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.blueGrey[700],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.delete_forever, color: Colors.white,),
                Icon(Icons.delete_forever, color: Colors.white,),
              ],
            ),
          ),
          confirmDismiss: (dir){
            return showDialog(
              context: context, 
              builder: (context)=>AlertDialog(
                title: Text('Do you want to delete?'), 
                actions: [
                  ElevatedButton(onPressed: (){Navigator.pop(context, true);}, child: Text('Yes'),),
                  ElevatedButton(onPressed: (){Navigator.pop(context, false);}, child: Text('No'),),
                ],
              ),
            );
          },
          onDismissed: (dir){
            user.deleteTranaction(tList[index].id);
          },
          child: TTile(tList[index])); 
          }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[800],
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