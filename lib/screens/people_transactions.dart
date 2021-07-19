import 'package:flutter/material.dart';
import 'package:len_den/model/user_data.dart';
import 'package:len_den/widget/transaction_tile.dart';
import 'package:provider/provider.dart';

import 'add_transaction.dart';

class PeopleTScreen extends StatefulWidget {
  final String id;
  final String name;
  final int index;
  const PeopleTScreen(this.id, this.index, this.name);

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
    
    Map<int, List> totalmap = {};
    int countC = 0;
    int countD = 0;
    String lastM = '';
    int lastI = 0;
    if(tList.length>0){
      lastM = tList[0].dateTime.toString().substring(0,7);
    }
    
    List.generate(tList.length, (index) {
      String temp = tList[index].dateTime.toString().substring(0,7);
      if(temp != lastM){
        totalmap[lastI] = [ countD, lastM.substring(0,4), countC ];
        countC = 0;
        countD = 0;
        lastM = temp;
        lastI = index;
      }
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
          countC += tList[index].amount;
        }
        else{
          tDebit += tList[index].amount;
          countD += tList[index].amount;
        }
      }
    });
    if(tList.length>0){
      totalmap[lastI] = [ countD, lastM.substring(0,4), countC ];
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Hero( tag: ValueKey(widget.id), child: Container(child: FittedBox(child: Text( widget.name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white, decoration: TextDecoration.none),)))),
        centerTitle: true,
        bottom: (tCredit==0 && tDebit ==0 && leftInterest==0)?null:
        AppBar(
          elevation: 0,
          shadowColor: Colors.blueGrey[800],
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
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index){
          return Dismissible(
          direction: DismissDirection.startToEnd,
          key: ValueKey(tList[index].id),
          background: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.blueGrey[700],
            child: Icon(Icons.delete_forever, color: Colors.white, size: 40,),
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
          onDismissed: (dir) async{
            await user.deleteTranaction(tList[index].id);
            setState(() {
            });
          },
          child: TTile(tList[index], isFirst: totalmap.containsKey(index), data: totalmap[index]??[])
          ); 
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