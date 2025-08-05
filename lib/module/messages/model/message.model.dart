class ChatUsersResponse {
  final List<Customer> customers;
  final List<UserSetting> userSettings;

  ChatUsersResponse({required this.customers, required this.userSettings});

  factory ChatUsersResponse.fromJson(Map<String, dynamic> json) {
    // Parse customers list from "data"
    final customersJson = json['data'] as List<dynamic>? ?? [];
    final customers = customersJson.map((e) => Customer.fromJson(e)).toList();

    // Parse included user settings
    final includedJson = json['included'] as List<dynamic>? ?? [];
    final userSettings = includedJson
        .where((e) => e['type'] == 'user_settings')
        .map((e) => UserSetting.fromJson(e))
        .toList();

    return ChatUsersResponse(customers: customers, userSettings: userSettings);
  }
}

class Customer {
  final String id;
  final Attributes attributes;
  final Relationships relationships;

  Customer({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      attributes: Attributes.fromJson(json['attributes'] ?? {}),
      relationships: Relationships.fromJson(json['relationships'] ?? {}),
    );
  }
}

class Attributes {
  final String? name;
  final String? phone;
  final String? email;
  final bool? isActive;
  final String? profilePhotoUrl;
  final int? age;
  final String? lastActiveAt;
  final bool? isChatInitiated;
  // Add more fields as needed

  Attributes({
    this.name,
    this.phone,
    this.email,
    this.isActive,
    this.profilePhotoUrl,
    this.age,
    this.lastActiveAt,
    this.isChatInitiated,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      isActive: json['is_active'],
      profilePhotoUrl: json['profile_photo_url'],
      age: json['age'],
      lastActiveAt: json['last_active_at'],
      isChatInitiated: json['is_chat_initiated'],
    );
  }
}

class Relationships {
  final List<dynamic>
  blockedContacts; // Can be parsed to proper model if needed
  final UserSettingsReference? userSettings;

  Relationships({required this.blockedContacts, this.userSettings});

  factory Relationships.fromJson(Map<String, dynamic> json) {
    final blocked = json['blockedContacts']?['data'] as List<dynamic>? ?? [];
    final userSettingsData = json['userSettings']?['data'];

    return Relationships(
      blockedContacts: blocked,
      userSettings: userSettingsData != null
          ? UserSettingsReference.fromJson(userSettingsData)
          : null,
    );
  }
}

class UserSettingsReference {
  final String type;
  final String id;

  UserSettingsReference({required this.type, required this.id});

  factory UserSettingsReference.fromJson(Map<String, dynamic> json) {
    return UserSettingsReference(type: json['type'], id: json['id']);
  }
}

class UserSetting {
  final String id;
  final UserSettingAttributes attributes;

  UserSetting({required this.id, required this.attributes});

  factory UserSetting.fromJson(Map<String, dynamic> json) {
    return UserSetting(
      id: json['id'],
      attributes: UserSettingAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class UserSettingAttributes {
  final int? userId;
  final bool? isRealGiftsAccepted;
  final bool? isReceivingPushNotifications;
  final bool? isOnlineStatusEnabled;
  final bool? isReadReceiptsEnabled;
  // Add other settings fields you need

  UserSettingAttributes({
    this.userId,
    this.isRealGiftsAccepted,
    this.isReceivingPushNotifications,
    this.isOnlineStatusEnabled,
    this.isReadReceiptsEnabled,
  });

  factory UserSettingAttributes.fromJson(Map<String, dynamic> json) {
    return UserSettingAttributes(
      userId: json['user_id'],
      isRealGiftsAccepted: json['is_real_gifts_accepted'],
      isReceivingPushNotifications: json['is_receiving_push_notifications'],
      isOnlineStatusEnabled: json['is_online_status_enabled'],
      isReadReceiptsEnabled: json['is_read_receipts_enabled'],
    );
  }
}
