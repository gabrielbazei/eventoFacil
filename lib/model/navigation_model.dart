class Event {
  final String title;
  final String description;
  final bool isAdmin;
  final bool isSubscribed; // Indica se o usuário está inscrito no evento

  Event({
    required this.title,
    required this.description,
    this.isAdmin = false,
    this.isSubscribed = false,
  });
}
