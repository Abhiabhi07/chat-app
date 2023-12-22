class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final dynamic timeSent;
  final String lastMessage;
  final String bio;

  ChatContact({
    required this.name,
    required this.bio,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bio': bio,
      'profilePic': profilePic,
      'contactId': contactId,
      'timeSent': timeSent,
      'lastMessage': lastMessage
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
        name: map['name'],
        bio: map['bio'],
        profilePic: map['profilePic'],
        contactId: map['contactId'],
        timeSent: map['timeSent'],
        lastMessage: map['lastMessage']);
  }
}
