class FaqsResponse {
  final bool? success;
  final List<FaqModel>? faqs;

  FaqsResponse({this.success, this.faqs});

  factory FaqsResponse.fromJson(Map<String, dynamic> json) {
    return FaqsResponse(
      success: json['success'],
      faqs: json['faqs'] != null
          ? List<FaqModel>.from(json['faqs'].map((x) => FaqModel.fromJson(x)))
          : null,
    );
  }
}

class FaqModel {
  final String? id;
  final String? category;
  final String? title;
  final String? body;
  final List<String>? tags;
  final int? order;

  FaqModel({
    this.id,
    this.category,
    this.title,
    this.body,
    this.tags,
    this.order,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'],
      category: json['category'],
      title: json['title'],
      body: json['body'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      order: json['order'],
    );
  }
}
