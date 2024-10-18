class Event {
  int ID;
  String title;
  String description;
  String location;
  DateTime startDate;
  DateTime endDate;
  bool isAdmin; //Indica se o usuario é admin no evento
  bool isSubscribed; // Indica se o usuário está inscrito no evento
  Event({
    this.ID = 0,
    this.title = "",
    this.description = "",
    this.location = "",
    this.isAdmin = false,
    this.isSubscribed = false,
    DateTime? startDate,
    DateTime? endDate,
  })  : startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now();
}
