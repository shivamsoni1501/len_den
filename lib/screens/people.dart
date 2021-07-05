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
        return UTile(user.people[index], index);
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
      child: ListTile(
        title: Text(people.name.toUpperCase()),
        leading: CircleAvatar(
          child: Text(people.name[0].toUpperCase()),
        ),
        contentPadding: const EdgeInsets.all(5),
        horizontalTitleGap: 10,
        minLeadingWidth: 70,
        minVerticalPadding: 10,
        subtitle: Text(people.address),
      ),
    );
  }
}