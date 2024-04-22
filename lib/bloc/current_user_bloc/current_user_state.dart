part of 'current_user_bloc.dart';

enum CurrentUserStatus { unAuthorized, authorized, newEnvelopeReceived }

class CurrentUserState extends Equatable {
  final CurrentUserStatus status;
  final UserModel? currentUser;
  final ChatUser? chatUser;
  final Envelope? envelope;
  final ChatRepo? chatRepo;
  final UploadBox? uploadBox;

  const CurrentUserState._({
    required this.status,
    this.currentUser = UserModel.empty,
    this.chatUser = ChatUser.empty,
    this.envelope = null,
    this.chatRepo = null,
    this.uploadBox = UploadBox.empty,
  });

  CurrentUserState.authenticated(UserModel currentUser)
      : this._(
          status: CurrentUserStatus.authorized,
          currentUser: currentUser,
          chatUser: ChatUser(
            userId: currentUser.id.toString(),
            username: currentUser.name.toString(),
            userImage: currentUser.profileImage.toString(),
            roleTypeId: currentUser.roleId.toString(),
          ),
          chatRepo: currentUser.id.toString() != '0'
              ? ChatRepo(currentUser: currentUser)
              : null,
          uploadBox: UploadBox.empty,
        );

  const CurrentUserState.unauthenticated()
      : this._(
          status: CurrentUserStatus.unAuthorized,
          currentUser: UserModel.empty,
          chatUser: ChatUser.empty,
          envelope: null,
          chatRepo: null,
          uploadBox: UploadBox.empty,
        );

  factory CurrentUserState.copyWith(
      {required CurrentUserStatus status,
      UserModel? currentUser,
      Envelope? envelope,
      ChatRepo? chatRepo,
      UploadBox? uploadBox}) {
    return CurrentUserState._(
      status: status,
      currentUser: currentUser,
      chatUser: ChatUser(
        userId: currentUser!.id.toString(),
        username: currentUser.name.toString(),
        userImage: currentUser.profileImage.toString(),
        roleTypeId: currentUser.roleId.toString(),
      ),
      envelope: envelope,
      chatRepo: currentUser.id.toString() != '0'
          ? ChatRepo(currentUser: currentUser)
          : null,
      uploadBox: uploadBox,
    );
  }

  @override
  List<dynamic> get props => [
        status,
        currentUser,
        envelope,
        chatRepo,
        uploadBox,
      ];
}
