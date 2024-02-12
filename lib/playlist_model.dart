class PlaylistModel {
  final String id;
  final String name;
  final String url;
  final int createAt;
  final int updateAt;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.url,
    required this.createAt,
    required this.updateAt,
  });

  static const String fieldId = 'id';
  static const String fieldName = 'name';
  static const String fieldUrl = 'url';
  static const String fieldCreateAt = 'createAt';
  static const String fieldUpdateAt = 'updateAt';

  PlaylistModel.fromJson(Map<String, dynamic> json)
      : name = json[fieldName],
        id = json[fieldId],
        createAt = json[fieldCreateAt],
        updateAt = json[fieldUpdateAt],
        url = json[fieldUrl];

  Map<String, dynamic> toJson() {
    return {
      fieldId: id,
      fieldName: name,
      fieldUrl: url,
      fieldCreateAt: createAt,
      fieldUpdateAt: updateAt,
    };
  }
}
