import connectdb from "@/lib/connectdb";
import User from "@/models/user";
import Channel from "@/models/channel";
import Post from "@/models/post";
import mongoose from "mongoose";

async function createPost(req, res) {
  const { user_id, channel_id, content } = req.body;
  const post = await Post.create({
    user: user_id,
    channel: channel_id,
    content: content,
  });
  await User.findByIdAndUpdate(
    user_id,
    {
      $push: {
        posts: post._id,
      },
      $inc: {
        postCount: 1,
      },
    },
    { strictQuery: true }
  );
  await Channel.findByIdAndUpdate(
    channel_id,
    {
      $push: {
        posts: post._id,
      },
      $inc: {
        postCount: 1,
      },
    },
    { strictQuery: true }
  );
  return res.status(200).json({
    message: "posted!",
  });
}

async function votePost(req, res) {
  const { post_id, votetype } = req.body;
  const change = votetype === "upvote" ? 1 : -1;
  const post = await Post.findByIdAndUpdate(post_id, {
    $inc: {
      popularity: change,
    },
  });
  return res.status(200).json({
    message: `post has been ${votetype}d!`,
    popularity: post.popularity + change,
  });
}

async function deletePost(req, res) {
  const { user_id, post_id } = req.body;
  const post = await Post.findById(post_id);
  let channel_id = post.channel;
  let post_user_id = post.user;
  if (post_user_id.toString() !== user_id) {
    return res.status(400).json({
      PermissionError: "you can't delete someone else's post",
    });
  } else {
    await post.deleteOne();
    await User.findByIdAndUpdate(user_id, {
      $pull: {
        posts: post_id,
      },
      $inc: {
        postCount: -1,
      },
    });
    await Channel.findByIdAndUpdate(channel_id, {
      $pull: {
        posts: post_id,
      },
      $inc: {
        postCount: -1,
      },
    });
    return res.status(200).json({
      message: "post has been deleted",
    });
  }
}

export default async function handler(req, res) {
  try {
    await connectdb();

    if (req.method === "POST") {
      return await createPost(req, res);
    } else if (req.method === "PUT") {
      return await votePost(req, res);
    } else if (req.method === "DELETE") {
      return await deletePost(req, res);
    }
  } catch (error) {
    if (error instanceof mongoose.Error.ValidationError) {
      let errors = [];
      for (let e in error.errors) {
        errors.push(error.errors[e].message);
      }
      res.status(400).json({ validationError: errors });
    } else {
      res.status(400).json({ serverOrDatabaseError: error.message });
    }
  }
}
