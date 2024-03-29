enum OrderStatus {
  cancelled,
  unconfirmed,
  confirmed,
  ready,
  completed,
  scheduled,
  scheduledConfirmed
}
//     case cancelled = 0
//     case unconfirmed = 1
//     case confirmed = 2
//     case ready = 3
//     case completed = 4
// //    case sent = 5
//     case scheduled = 6
//     case scheduledConfirmed = 7

extension OrderStatusExt on OrderStatus {
  static OrderStatus? statusFromRawValue(int rawValue) {
    switch (rawValue) {
      case 1:
        return OrderStatus.unconfirmed;
      case 2:
        return OrderStatus.confirmed;
      case 3:
        return OrderStatus.ready;
      case 4:
        return OrderStatus.completed;
      case 0:
        return OrderStatus.cancelled;
//        case .sent:
//            return "Sent"
      case 6:
        return OrderStatus.scheduled;

      case 7:
        return OrderStatus.scheduledConfirmed;
      default:
        return null;
    }
  }

  int get rawValue {
    switch (this) {
      case OrderStatus.unconfirmed:
        return 1;
      case OrderStatus.confirmed:
        return 2;
      case OrderStatus.ready:
        return 3;
      case OrderStatus.completed:
        return 4;
      case OrderStatus.cancelled:
        return 0;
//        case .sent:
//            return "Sent"
      case OrderStatus.scheduled:
        return 6;

      case OrderStatus.scheduledConfirmed:
        return 7;
    }
  }

  String get status {
    switch (this) {
      case OrderStatus.unconfirmed:
        return "Unconfirmed";
      case OrderStatus.confirmed:
        return "Comfirmed";
      case OrderStatus.ready:
        return "Ready for pick up";
      case OrderStatus.completed:
        return "Completed";
      case OrderStatus.cancelled:
        return "Cancelled";
//        case .sent:
//            return "Sent"
      case OrderStatus.scheduled:
        return "Scheduled";

      case OrderStatus.scheduledConfirmed:
        return "Scheduled Confirmed";
    }
  }

  String get image {
    switch (this) {
      case OrderStatus.unconfirmed:
        return 'unconfirmed';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.ready:
        return 'ready';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.cancelled:
        return 'cancel';
//        case .sent:
//            return UIImage(named: "comfirmed")!
      case OrderStatus.scheduled:
        return 'unconfirmed';
      case OrderStatus.scheduledConfirmed:
        return 'confirmed';
    }
  }
}
