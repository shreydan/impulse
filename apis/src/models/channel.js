import { Schema } from "mongoose";
import mongoose from "mongoose";

const ChannelSchema = new Schema({
  name: {
    type: String,
    unique: true,
    lowercase: true,
    required: [true, "channel name can't be blank"],
    match: [/^[a-z]*$/, "is invalid"],
    minLength: [3, "min characters: 3"],
    maxLength: [18, "max characters: 18"],
    index: true,
  },
  postCount: {
    type: Number,
    default: 0,
    min: 0,
  },
  posts: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Post",
    },
  ],
  followers: {
    type: Number,
    default: 0,
    min: 0,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

const Channel =
  mongoose.models.Channel || mongoose.model("Channel", ChannelSchema);
export default Channel;
