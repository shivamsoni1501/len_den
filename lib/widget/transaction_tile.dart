import 'package:flutter/material.dart';
import 'package:len_den/model/user_data.dart';

class TTile extends StatelessWidget {
  final Transaction trx;
  const TTile(this.trx);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(trx.note),
      leading: CircleAvatar(
        child: FittedBox(
          alignment: Alignment.center, 
          child: Text(
            trx.amount.toString(),
          ),
        ),
      ),
      contentPadding: const EdgeInsets.all(5),
      horizontalTitleGap: 10,
      minLeadingWidth: 70,
      minVerticalPadding: 10,
      subtitle: Text((trx.isCredit)?'From ${trx.toOrFromName}': 'To ${trx.toOrFromName}'),
      trailing: Text(trx.dateTime.toString().substring(0, 10)),
      tileColor: (!trx.isCredit)?Colors.red:Colors.green,
    );
  }
}