import 'package:flutter/material.dart';
import 'package:len_den/model/user_data.dart';
import 'package:len_den/widget/transaction_tile.dart';
import 'package:provider/provider.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context); 
    return ListView.builder(
      itemCount: user.transactions.length,
      itemBuilder: (context, index){
        return TTile(user.transactions[index]);
      }
    );
  }
}
