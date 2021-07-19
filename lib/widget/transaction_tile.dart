import 'package:flutter/material.dart';
import 'package:len_den/model/user_data.dart';

class TTile extends StatelessWidget {
  final Transaction trx;
  const TTile(this.trx, {this.isFirst = false, this.data = const []});
  final bool isFirst;
  final List data;

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
    final String date = trx.dateTime.toString().substring(0,10);
    final monthS = months[int.parse(date.substring(5,7))-1];

    final colorI = (trx.isForInterest)?Colors.blue:Colors.blueGrey[600];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          if(isFirst) SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Row(
                    children: [                    
                      FittedBox(child: Text('₹',style: TextStyle(fontSize: 22, color:Colors.red, fontWeight: FontWeight.bold), )),
                      FittedBox(child: Text('${data[0]}',style: TextStyle(fontSize: 22, color: Colors.blueGrey[700], fontWeight: FontWeight.bold), )),
                    ],
                  ),
                ),
                FittedBox(child: Text('$monthS, ${data[1]}',textAlign: TextAlign.center,  style: TextStyle(fontSize: 16, color: Colors.blueGrey[500], fontWeight: FontWeight.bold),)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [                    
                      FittedBox(child: Text('₹',style: TextStyle(fontSize: 22, color:Colors.green, fontWeight: FontWeight.bold), )),
                      FittedBox(child: Text('${data[2]}',style: TextStyle(fontSize: 22, color: Colors.blueGrey[700], fontWeight: FontWeight.bold), )),
                    ],
                  ),
                ),
              ]
            ),
          ),
          if(isFirst)
          Container(height: 2, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blueGrey[800]),),
          SizedBox(
            height: 70,
            child: Row(
              children: [
                Container(
                    alignment: Alignment.center,
                    width: 60,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 2, color: Colors.blueGrey[700]!),
                        ),
                        height: 40,
                        width: 38,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsets.all(0),
                              height: 15,
                              alignment: Alignment.center,
                              color: Colors.blueGrey[700],
                              child: FittedBox(child: Text(monthS, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold ,fontSize: 12),)),
                            ),
                            Expanded(child: FittedBox(child: Text(date.substring(8,10), style: TextStyle(fontSize: 18, color: Colors.blueGrey[700]),))),
                          ],
                        ),
                      ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(trx.toOrFromName, overflow: TextOverflow.clip, style: TextStyle(fontSize: 16, color: Colors.blueGrey[700], fontWeight: FontWeight.bold),),
                        Text(trx.note, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container( width: 5, height: 5, decoration: BoxDecoration(color: trx.isCredit?Colors.green:Colors.red,borderRadius: BorderRadius.circular(5))),
                      FittedBox(child: Text('₹${trx.amount}', style: TextStyle(fontSize: 14, color: colorI, fontWeight: FontWeight.bold),)),
                      Text(trx.method, style: TextStyle(fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
