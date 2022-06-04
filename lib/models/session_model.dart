class SessionData {
  String id;
  final DateTime dateAndTime;
  bool? isBooked;

  SessionData({required this.id, required this.dateAndTime, this.isBooked});
}
