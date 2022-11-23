class Messages {
  Meta? meta;
  List<Message>? messages;

  Messages({this.meta, this.messages});

  Messages.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['messages'] != null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (this.messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  String? sid;
  String? accountSid;
  String? conversationSid;
  String? body;
  Null? media;
  String? author;
  String? participantSid;
  Attributes? attributes;
  String? dateCreated;
  String? dateUpdated;
  int? index;
  Delivery? delivery;
  String? url;
  Links? links;
  Message(
      {this.sid,
        this.accountSid,
        this.conversationSid,
        this.body,
        this.media,
        this.author,
        this.participantSid,
        this.attributes,
        this.dateCreated,
        this.dateUpdated,
        this.index,
        this.delivery,
        this.url,
        this.links});

  Message.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    accountSid = json['account_sid'];
    conversationSid = json['conversation_sid'];
    body = json['body'];
    media = json['media'];
    author = json['author'];
    participantSid = json['participant_sid'];
    attributes = json['attributes'] != null
        ? Attributes.fromJson(json['attributes'])
        : null;
    dateCreated = json['date_created'];
    dateUpdated = json['date_updated'];
    index = json['index'];
    delivery = json['delivery'] != null
        ? Delivery.fromJson(json['delivery'])
        : null;
    url = json['url'];
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sid'] = sid;
    data['account_sid'] = accountSid;
    data['conversation_sid'] = conversationSid;
    data['body'] = body;
    data['media'] = media;
    data['author'] = author;
    data['participant_sid'] = participantSid;
    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }
    data['date_created'] = dateCreated;
    data['date_updated'] = dateUpdated;
    data['index'] = index;
    if (delivery != null) {
      data['delivery'] = delivery!.toJson();
    }
    data['url'] = url;
    if (links != null) {
      data['links'] = links!.toJson();
    }
    return data;
  }
}

class Attributes {
  String? importance;

  Attributes({this.importance});

  Attributes.fromJson(Map<String, dynamic> json) {
    importance = json['importance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['importance'] = this.importance;
    return data;
  }
}

class Delivery {
  int? total;
  String? sent;
  String? delivered;
  String? read;
  String? failed;
  String? undelivered;

  Delivery(
      {this.total,
        this.sent,
        this.delivered,
        this.read,
        this.failed,
        this.undelivered});

  Delivery.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    sent = json['sent'];
    delivered = json['delivered'];
    read = json['read'];
    failed = json['failed'];
    undelivered = json['undelivered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['sent'] = this.sent;
    data['delivered'] = this.delivered;
    data['read'] = this.read;
    data['failed'] = this.failed;
    data['undelivered'] = this.undelivered;
    return data;
  }
}

class Links {
  String? deliveryReceipts;

  Links({this.deliveryReceipts});

  Links.fromJson(Map<String, dynamic> json) {
    deliveryReceipts = json['delivery_receipts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivery_receipts'] = this.deliveryReceipts;
    return data;
  }
}

class Meta {
  int? page;
  int? pageSize;
  String? firstPageUrl;
  Null? previousPageUrl;
  String? url;
  Null? nextPageUrl;
  String? key;

  Meta(
      {this.page,
        this.pageSize,
        this.firstPageUrl,
        this.previousPageUrl,
        this.url,
        this.nextPageUrl,
        this.key});

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    pageSize = json['page_size'];
    firstPageUrl = json['first_page_url'];
    previousPageUrl = json['previous_page_url'];
    url = json['url'];
    nextPageUrl = json['next_page_url'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['page_size'] = pageSize;
    data['first_page_url'] = firstPageUrl;
    data['previous_page_url'] = previousPageUrl;
    data['url'] = url;
    data['next_page_url'] = nextPageUrl;
    data['key'] = key;
    return data;
  }
}