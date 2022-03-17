import 'package:flutter/material.dart';
import 'package:len_den/model/user_data.dart';
import 'package:len_den/widget/transaction_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

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
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    List<Transaction> tList = user.transactions;
    tList.sort((b, a) => a.dateTime.compareTo(b.dateTime));
    bool empty = false;
    Map<int, List> totalMap = {};
    try {
      var last = tList[0].dateTime.toString().substring(0, 7);
      int lastI = 0;
      int count = 0;
      int countI = 0;
      for (int i = 0; i < tList.length; i += 1) {
        var dateS = tList[i].dateTime.toString().substring(0, 7);
        if (dateS != last) {
          totalMap[lastI] = [count, last.substring(0, 4), countI];
          count = 0;
          countI = 0;
          last = dateS;
          lastI = i;
        }
        if (!tList[i].isForInterest) {
          if (!tList[i].isCredit) {
            count += tList[i].amount;
          } else {
            countI += tList[i].amount;
          }
        }
      }
      totalMap[lastI] = [count, last.substring(0, 4), countI];
    } catch (e) {
      empty = true;
    }
    print(totalMap);
    return (empty)
        ? Text(
            'No Transactions Yet!!\nTry Add Some.',
            style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[400],
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        : ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: tList.length,
            itemBuilder: (context, index) {
              return TTile(tList[index],
                  isFirst: totalMap.containsKey(index),
                  data: totalMap[index] ?? []);
            });
  }
}
