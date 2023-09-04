import { Schema } from "mongoose";
import mongoose from "mongoose";

const PostSchema = new Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  channel: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Channel",
    required: true,
  },
  content: {
    required: [true, "the post cannot be empty"],
    type: String,
    maxLength: 280,
    minLength: 1,
  },
  popularity: {
    type: Number,
    default: 0,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

PostSchema.methods = {
  votePost(voteType) {
    if (voteType === "upvote") {
      this.popularity++;
    } else if (voteType === "downvote") {
      this.popularity--;
    }
    this.save();
  },
};

const Post = mongoose.models.Post || mongoose.model("Post", PostSchema);
export default Post;
