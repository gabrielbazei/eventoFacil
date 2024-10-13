class Event {
  final int ID;
  final String title;
  final String description;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAdmin; //Indica se o usuario é admin no evento
  final bool isSubscribed; // Indica se o usuário está inscrito no evento
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
