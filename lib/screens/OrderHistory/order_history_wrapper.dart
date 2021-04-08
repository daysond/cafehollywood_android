import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafe_hollywood/services/fs_service.dart';
import 'package:cafe_hollywood/screens/OrderHistory/order_page.dart';

// class OrderHistoryWrapper extends StatefulWidget {
//   @override
//   _OrderHistoryWrapperState createState() => _OrderHistoryWrapperState();
// }

// class _OrderHistoryWrapperState extends State<OrderHistoryWrapper>
//     with AutomaticKeepAliveClientMixin<OrderHistoryWrapper> {
//   @override
//   bool get wantKeepAlive => true;
//   FSService fsService = FSService();

//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<QuerySnapshot>.value(
//       initialData: null,
//         value: fsService.activeOrderSnapshots, child: OrderHistoryPage());
//   }
// }
