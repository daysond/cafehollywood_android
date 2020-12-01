// import 'package:cafe_hollywood/models/meal_info.dart';
// import 'package:cafe_hollywood/models/table_order.dart';
// import 'package:decimal/decimal.dart';

// class EnumHandler {
//   static int orderStatusRawValue(OrderStatus status) {
//     switch (status) {
//       case OrderStatus.cancelled:
//         return 0;
//       case OrderStatus.unconfirmed:
//         return 1;
//       case OrderStatus.confirmed:
//         return 2;
//       case OrderStatus.ready:
//         return 3;
//       case OrderStatus.completed:
//         return 4;
//       case OrderStatus.scheduled:
//         return 6;
//       case OrderStatus.scheduledConfirmed:
//         return 7;
//     }
//   }

//   static OrderStatus rawValueToOrderStatus(int rawValue) {
//     switch (rawValue) {
//       case 0:
//         return OrderStatus.cancelled;
//       case 1:
//         return OrderStatus.unconfirmed;
//       case 2:
//         return OrderStatus.confirmed;
//       case 3:
//         return OrderStatus.ready;
//       case 4:
//         return OrderStatus.completed;
//       case 6:
//         return OrderStatus.scheduled;
//       case 7:
//         return OrderStatus.scheduledConfirmed;
//     }
//   }

//   static Decimal comboTypeDeductionAmout(ComboType type) {
//     switch (type) {
//       case ComboType.drink:
//         return Decimal.parse('1.5');
//       case ComboType.wing:
//         return Decimal.parse('9.96');
//     }
//   }
// }
