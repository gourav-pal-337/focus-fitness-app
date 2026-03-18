class CreateTicketResponse {
  final bool? success;
  final String? message;
  final TicketModel? ticket;

  CreateTicketResponse({this.success, this.message, this.ticket});

  factory CreateTicketResponse.fromJson(Map<String, dynamic> json) {
    // Resilience: Check for identifiers in both wrapped and flat formats
    final dynamic ticketJson = json['ticket'];
    final bool isNested = ticketJson != null && ticketJson is Map;
    
    // Check for unique identifier keys that indicate a flat ticket object
    final bool isFlat = json.containsKey('_id') || 
                       json.containsKey('id') || 
                       json.containsKey('ticketId') ||
                       json.containsKey('clientId') ||
                       json.containsKey('subject');

    return CreateTicketResponse(
      success: json['success'] ?? (isNested || isFlat),
      message: json['message']?.toString(),
      ticket: isNested 
          ? TicketModel.fromJson(Map<String, dynamic>.from(ticketJson)) 
          : (isFlat ? TicketModel.fromJson(json) : null),
    );
  }
}

class TicketModel {
  final String? id; // This will hold the primary display ID (ticketId or _id)
  final String? ticketId; // Specific field for human-readable ID
  final String? mongodbId; // Specific field for database _id
  final String? title;
  final String? description;
  final String? status;
  final String? category;
  final String? priority;
  final String? clientId;
  final List<String>? attachments;
  final String? createdAt;
  final String? lastActivityAt;
  final String? updatedAt;

  TicketModel({
    this.id,
    this.ticketId,
    this.mongodbId,
    this.title,
    this.description,
    this.status,
    this.category,
    this.priority,
    this.clientId,
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
            if (attachment is Map) {
              return attachment['url']?.toString() ?? '';
            }
            return '';
          })
          .where((url) => url.isNotEmpty)
          .toList();
    }

    final String? realTicketId = json['ticketId']?.toString();
    final String? mongoId = (json['_id'] ?? json['id'])?.toString();

    return TicketModel(
      id: realTicketId ?? mongoId,
      ticketId: realTicketId,
      mongodbId: mongoId,
      title: (json['subject'] ?? json['title'])?.toString(),
      description: json['description']?.toString(),
      status: json['status']?.toString(),
      category: json['category']?.toString(),
      priority: json['priority']?.toString(),
      clientId: json['clientId']?.toString(),
      attachments: parsedAttachments,
      createdAt: json['createdAt']?.toString(),
      lastActivityAt: json['lastActivityAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}
