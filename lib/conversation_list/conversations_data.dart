class ConversationsData {
  List<Conversations>? conversations;
  Meta? meta;

  ConversationsData({this.conversations, this.meta});

  ConversationsData.fromJson(Map<String, dynamic> json) {
    if (json['conversations'] != null) {
      conversations = <Conversations>[];
      json['conversations'].forEach((v) {
        conversations!.add(Conversations.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (conversations != null) {
      data['conversations'] = conversations!.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class Conversations {
  Null? uniqueName;
  String? dateUpdated;
  String? friendlyName;
  Timers? timers;
  String? accountSid;
  String? url;
  String? state;
  String? dateCreated;
  String? messagingServiceSid;
  String? sid;
  String? attributes;
  Null? bindings;
  String? chatServiceSid;
  Links? links;

  Conversations(
      {this.uniqueName,
      this.dateUpdated,
      this.friendlyName,
      this.timers,
      this.accountSid,
      this.url,
      this.state,
      this.dateCreated,
      this.messagingServiceSid,
      this.sid,
      this.attributes,
      this.bindings,
      this.chatServiceSid,
      this.links});

  Conversations.fromJson(Map<String, dynamic> json) {
    uniqueName = json['unique_name'];
    dateUpdated = json['date_updated'];
    friendlyName = json['friendly_name'];
    timers = json['timers'] != null ? Timers.fromJson(json['timers']) : null;
    accountSid = json['account_sid'];
    url = json['url'];
    state = json['state'];
    dateCreated = json['date_created'];
    messagingServiceSid = json['messaging_service_sid'];
    sid = json['sid'];
    attributes = json['attributes'];
    bindings = json['bindings'];
    chatServiceSid = json['chat_service_sid'];
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unique_name'] = uniqueName;
    data['date_updated'] = dateUpdated;
    data['friendly_name'] = friendlyName;
    if (timers != null) {
      data['timers'] = timers!.toJson();
    }
    data['account_sid'] = accountSid;
    data['url'] = url;
    data['state'] = state;
    data['date_created'] = dateCreated;
    data['messaging_service_sid'] = messagingServiceSid;
    data['sid'] = sid;
    data['attributes'] = attributes;
    data['bindings'] = bindings;
    data['chat_service_sid'] = chatServiceSid;
    if (links != null) {
      data['links'] = links!.toJson();
    }
    return data;
  }
}

class Timers {
  Timers();

  Timers.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class Links {
  String? participants;
  String? messages;
  String? webhooks;

  Links({this.participants, this.messages, this.webhooks});

  Links.fromJson(Map<String, dynamic> json) {
    participants = json['participants'];
    messages = json['messages'];
    webhooks = json['webhooks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['participants'] = participants;
    data['messages'] = messages;
    data['webhooks'] = webhooks;
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

  Meta({this.page, this.pageSize, this.firstPageUrl, this.previousPageUrl, this.url, this.nextPageUrl, this.key});

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
