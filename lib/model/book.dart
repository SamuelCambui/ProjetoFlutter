class Book {
  String isbn;
  String title;
  List<String> authors;
  String publisher;
  String? synopsis;
  String coverUrl;
  int? pageCount;
  String? notes;

  Book({
    required this.isbn,
    required this.title,
    required this.authors,
    required this.publisher,
    this.synopsis,
    required this.coverUrl,
    this.pageCount,
    this.notes,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      isbn: json['isbn'],
      title: json['title'],
      authors: List<String>.from(json['authors']),
      publisher: json['publisher'],
      synopsis: json['synopsis'],
      coverUrl: json['coverUrl'],
      pageCount: json['page_count'],
      notes: '',
    );
  }
}
