class BeritaModel {
  final int id;
  final String judul;
  final String isi;
  final String createdAt;
  final String? authorName; 

  BeritaModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.createdAt,
    this.authorName,
  });

  factory BeritaModel.fromJson(Map<String, dynamic> json) {
    return BeritaModel(
      id: json['id'],
      judul: json['judul'],
      isi: json['isi'],
      createdAt: json['created_at'],
      authorName: json['author_name'], 
    );
  }
}