class CommentModel {
  String image;
  String name;
  String textComment;
  String imageComment;
  String uId;
  // String postId;

  CommentModel({
    this.image,
    this.name,
    this.textComment,
    this.imageComment,
    this.uId,
    // this.postId,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    textComment = json['textComment'];
    imageComment = json['imageComment'];
    uId = json['uId'];
    // postId = json['postId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'textComment': textComment,
      'imageComment': imageComment,
      'uId': uId,
      // 'postId': postId,
    };
  }
}
