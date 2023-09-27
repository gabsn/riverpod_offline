abstract class Serializable {
  Map<String, dynamic> toJson();
  factory Serializable.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();
}
