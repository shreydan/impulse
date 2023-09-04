import { Schema } from "mongoose";
import mongoose from "mongoose";

const UserSchema = new Schema({
  username: {
    type: String,
    unique: true,
    lowercase: true,
    required: [true, "can't be blank"],
    match: [/^[a-z][a-z0-9]*$/, "is invalid"],
    minLength: [5, "min characters: 5"],
    maxLength: [12, "max characters: 12"],
    index: true,
  },
  password: {
    type: String,
    required: true,
  },
  postCount: {
    type: Number,
    default: 0,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  posts: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Post",
    },
  ],
  channels: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Channel",
    },
  ],
});

const User = mongoose.models.User || mongoose.model("User", UserSchema);
export default User;
