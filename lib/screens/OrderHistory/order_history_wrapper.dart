import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafe_hollywood/services/fs_service.dart';
import 'package:cafe_hollywood/screens/OrderHistory/order_page.dart';

class OrderHistoryWrapper extends StatefulWidget {
  @override
  _OrderHistoryWrapperState createState() => _OrderHistoryWrapperState();
}

class _OrderHistoryWrapperState extends State<OrderHistoryWrapper>
    with AutomaticKeepAliveClientMixin<OrderHistoryWrapper> {
  @override
  bool get wantKeepAlive => true; 
  @override
  void initState() {
    print('~~~~~~~~~~~~~~~~~~~~~~~~');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('???????????????????');
    return StreamProvider<QuerySnapshot>.value(
        value: FSService().activeOrderSnapshots, child: OrderHistoryPage());
  }
}

// class OrderHistoryWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     print('being build %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
//     return StreamProvider<QuerySnapshot>.value(
//         value: FSService().activeOrderSnapshots, child: OrderHistoryPage());
//   }
// }
