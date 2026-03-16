class CreateTicketResponse {
  final bool? success;
  final String? message;
  final TicketModel? ticket;

  CreateTicketResponse({this.success, this.message, this.ticket});

  factory CreateTicketResponse.fromJson(Map<String, dynamic> json) {
    return CreateTicketResponse(
      success: json['success'],
      message: json['message'],
      ticket: json['ticket'] != null
          ? TicketModel.fromJson(json['ticket'])
          : null,
    );
  }
}

class TicketModel {
  final String? id;
  final String? title;
  final String? description;
  final String? status;
  final String? category;
  final String? priority;
  final List<String>? attachments;
  final String? createdAt;
  final String? lastActivityAt;
  final String? updatedAt;

  TicketModel({
    this.id,
    this.title,
    this.description,
    this.status,
    this.category,
    this.priority,
    this.attachments,
    this.createdAt,
    this.lastActivityAt,
    this.updatedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    List<String>? parsedAttachments;
    if (json['attachments'] != null && json['attachments'] is List) {
      parsedAttachments = (json['attachments'] as List)
          .map((attachment) {
            if (attachment is String) return attachment;
            if (attachment is Map && attachment['url'] != null) {
              return attachment['url'].toString();
            }
            return '';
          })
          .where((url) => url.isNotEmpty)
          .toList();
    }

    return TicketModel(
      id: json['_id'] ?? json['id'],
      title: json['subject'] ?? json['title'],
      description: json['description'],
      status: json['status'],
      category: json['category'],
      priority: json['priority'],
      attachments: parsedAttachments,
      createdAt: json['createdAt'],
      lastActivityAt: json['lastActivityAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
