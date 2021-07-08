import 'package:flutter/material.dart';
import 'package:len_den/model/user_data.dart';
import 'package:len_den/screens/people_transactions.dart';
import 'package:provider/provider.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context); 
    return ListView.builder(
      itemCount: user.people.length,
      itemBuilder: (context, index){
        return Dismissible(
          key: ValueKey(user.people[index].id),
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
            user.deletePeople(user.people[index].id);
          },
          child: UTile(user.people[index], index));
      }
    );
  }
}

class UTile extends StatelessWidget {
  final People people;
  final int index;
  const UTile(this.people, this.index);
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
       onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context)=> PeopleTScreen(people.id, index)
          ),
        );
      },
          child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        height: 70,
        child: Row(
          children: [
            Container(
                alignment: Alignment.center,
                width: 60,
                child: CircleAvatar(
          child: Text(people.name[0].toUpperCase()),
        ),),
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(people.name.toUpperCase(), overflow: TextOverflow.clip, style: TextStyle(fontSize: 16, color: Colors.blueGrey[700], fontWeight: FontWeight.bold),),
                    Text(people.address, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
     }
}