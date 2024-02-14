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

  PlaylistModel copy({
    String? id,
    String? name,
    String? url,
    int? createAt,
    int? updateAt,
  }) =>
      PlaylistModel(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        createAt: createAt ?? this.createAt,
        updateAt: updateAt ?? this.updateAt,
      );
}
