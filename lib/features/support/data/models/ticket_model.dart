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

  TicketModel({
    this.id,
    this.title,
    this.description,
    this.status,
    this.category,
    this.priority,
    this.attachments,
    this.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      category: json['category'],
      priority: json['priority'],
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : null,
      createdAt: json['createdAt'],
    );
  }
}
