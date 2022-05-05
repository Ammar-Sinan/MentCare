class SessionData {
  String id;
  String duration;
  DateTime time;
  String patientName;
  String location; // might use boolean for this

  SessionData({
    required this.id,
    required this.duration,
    required this.time,
    required this.patientName,
    required this.location,
  });
}
