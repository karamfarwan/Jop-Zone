abstract class SocialStates {}
class GetFriendProfileLoadingState extends SocialStates {}

class GetFriendProfileSuccessState extends SocialStates {}

class GetFriendProfileErrorState extends SocialStates {}
class CheckFriendState extends SocialStates {}
class GetUserPostSuccessState extends SocialStates {}
class GetFriendSuccessState extends SocialStates {}
class UserLoadingState extends SocialStates {}

class UserSuccessState extends SocialStates {}

class UserErrorState extends SocialStates {}
class GetFriendLoadingState extends SocialStates {}
class FriendRequestLoadingState extends SocialStates {}

class FriendRequestSuccessState extends SocialStates {}

class FriendRequestErrorState extends SocialStates {}
class SendNotificationSuccessState extends SocialStates {}

class SendAppNotificationLoadingState extends SocialStates {}

class SendAppNotificationSuccessState extends SocialStates {}

class SendAppNotificationErrorState extends SocialStates {}

class SetNotificationIdSuccessState extends SocialStates {}

class GetNotificationIdSuccessState extends SocialStates {}

class GetNotificationIdLoadingState extends SocialStates {}

class ReadNotificationSuccessState extends SocialStates {}

class UnReadNotificationSuccessState extends SocialStates {}
class AddFriendLoadingState extends SocialStates {}

class AddFriendSuccessState extends SocialStates {}

class AddFriendErrorState extends SocialStates {}
class UnFriendLoadingState extends SocialStates {}

class UnFriendSuccessState extends SocialStates {}

class UnFriendErrorState extends SocialStates {}
class SocialChatImageSuccess extends SocialStates {}

class SocialChatImageError extends SocialStates {}
// chats
class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {}

class SocialGetMessageSuccessState extends SocialStates {}

class SocialGetMessageErrorState extends SocialStates {}
class CreateChatImageLoadingState extends SocialStates {}

class CreateChatImageSuccessState extends SocialStates {}

class CreateChatImageErrorState extends SocialStates {}
class RemoveImageChatState extends SocialStates {}

class SocialRemovePostImage extends SocialStates {}
class deleteForMeSuccess extends SocialStates {}

class deleteForeveryOneSuccess extends SocialStates {}
class SocialSearchUserLoadingState extends SocialStates {}

class SocialSearchUserSuccessState extends SocialStates {}

class SocialSearchUserErrorState extends SocialStates {}
// class SendNotificationSuccessState extends SocialStates {}
//
// class SendAppNotificationLoadingState extends SocialStates {}
//
// class SendAppNotificationSuccessState extends SocialStates {}
//
// class SendAppNotificationErrorState extends SocialStates {}
//
// class SetNotificationIdSuccessState extends SocialStates {}
//
// class GetNotificationIdSuccessState extends SocialStates {}
//
// class GetNotificationIdLoadingState extends SocialStates {}
//
// class ReadNotificationSuccessState extends SocialStates {}
//
// class UnReadNotificationSuccessState extends SocialStates {}

class DeleteNotificationSuccessState extends SocialStates {}








///////////////////////////////////////////////////////////////////////
class SocialInitialState extends SocialStates {}


class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates {
  final String error;

  SocialGetUserErrorState(this.error);
}

class SocialGetAllUserLoadingState extends SocialStates {}

class SocialGetAllUserSuccessState extends SocialStates {}

class SocialGetAllUserErrorState extends SocialStates {
  final String error;

  SocialGetAllUserErrorState(this.error);
}

class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates {
  final String error;

  SocialGetPostsErrorState(this.error);
}


class SocialLikePostSuccessState extends SocialStates {}
class SocialLikePostErrorState extends SocialStates {
  final String error;

  SocialLikePostErrorState(this.error);
}

class SocialDisLikePostSuccessState extends SocialStates {}
class SocialDisLikePostErrorState extends SocialStates {
  final String error;

  SocialDisLikePostErrorState(this.error);
}

class SocialGetCommentLoadingState extends SocialStates {}
class SocialGetCommentSuccessState extends SocialStates {}
class SocialGetCommentErrorState extends SocialStates {
  final String error;

  SocialGetCommentErrorState(this.error);
}

class SocialPostCommentSuccessState extends SocialStates {}
class SocialPostCommentErrorState extends SocialStates {
  final String error;

  SocialPostCommentErrorState(this.error);
}

class SocialGetSinglePostSuccessState extends SocialStates {}
class SocialGetSinglePostErrorState extends SocialStates {
  final String error;

  SocialGetSinglePostErrorState(this.error);
}

class SocialChangeBottomNavStates extends SocialStates {}
class SocialNewPostStates extends SocialStates {}

class SocialProfileImagePickedSuccessStates extends SocialStates {}
class SocialProfileImagePickedErrorStates extends SocialStates {}

class SocialCoverImagePickedSuccessStates extends SocialStates {}
class SocialCoverImagePickedErrorStates extends SocialStates {}

class SocialUploadProfileImageSuccessStates extends SocialStates {}
class SocialUploadProfileImageErrorStates extends SocialStates {}

class SocialUploadCoverImageSuccessStates extends SocialStates {}
class SocialUploadCoverImageErrorStates extends SocialStates {}

class SocialUserUpdateLoadingStates extends SocialStates {}
class SocialUserUpdateErrorStates extends SocialStates {}


class SocialCreatePostLoadingStates extends SocialStates {}
class SocialCreatePostSuccessStates extends SocialStates {}
class SocialCreatePostErrorStates extends SocialStates {}

class SocialPostImagePickedSuccessStates extends SocialStates {}
class SocialPostImagePickedErrorStates extends SocialStates {}

class SocialRemovePostImageStates extends SocialStates {}

//Chat

class SocialSendMessageSuccessStates extends SocialStates {}
class SocialSendMessageErrorStates extends SocialStates {}

class SocialGetMessageSuccessStates extends SocialStates {}
class SocialGetMessageErrorStates extends SocialStates {}

class SocialSingOutSuccessStates extends SocialStates {}
class SocialSingOutErrorStates extends SocialStates {}

class SocialGetUserTokenLoadingStates extends SocialStates {}
class SocialGetUserTokenSuccessStates extends SocialStates {}


class DeleteFriendRequestLoadingState extends SocialStates {}
class DeleteFriendRequestSuccessState extends SocialStates {}
class DeleteFriendRequestErrorState extends SocialStates {}

class CheckFriendRequestState extends SocialStates {}
class DeletePostSuccessState extends SocialStates {}

class GetSinglePostLoadingState extends SocialStates {}
class GetSinglePostSuccessState extends SocialStates {}
class GetSinglePostErrorState extends SocialStates {}

class SocialChangeColorHeartState extends SocialStates {}

class ChangeModeState extends SocialStates {}