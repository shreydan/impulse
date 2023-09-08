import connectdb from "@/lib/connectdb";
import User from "@/models/user";
import Channel from "@/models/channel";
import Post from "@/models/post";
import mongoose from "mongoose";

async function getchannelposts(req, res) {
  const { channel_id } = req.query;
  const channel = await Channel.findById(channel_id);
  const posts = await channel.populate({ path: "posts", model: Post });
  const fullposts = [];
  for (const post of posts.posts) {
    const user = await User.findById(post.user);
    fullposts.push({
      user_id: post.user,
      username: user.username,
      content: post.content,
      createdAt: post.createdAt,
      popularity: post.popularity,
    });
  }
  return res.status(200).json({
    channel_name: channel.name,
    channel_id: channel_id,
    post_count: channel.postCount,
    followers: channel.followers,
    createdAt: channel.createdAt,
    posts: fullposts,
  });
}

async function gethomeposts(req, res) {
  const { user_id } = req.query;
  const user = await User.findById(user_id);
  const channels = await user.populate({ path: "channels", model: Channel });
  let posts = [];
  for (const channel of channels.channels) {
    for (const post_id of channel.posts) {
      const post = await Post.findById(post_id);
      const postchannel = await Channel.findById(post.channel);
      const postauthor = await User.findById(post.user);
      posts.push({
        id: post._id,
        user_id: post.user,
        username: postauthor.username,
        channel_id: post.channel,
        channel_name: postchannel.name,
        content: post.content,
        popularity: post.popularity,
        createdAt: post.createdAt,
      });
    }
  }
  return res.status(200).json({
    posts: posts,
  });
}

async function getprofileposts(req, res) {
  const { user_id } = req.query;
  const user = await User.findById(user_id);
  let posts = await user.populate({ path: "posts", model: Post });
  posts = posts.posts.map((post) => ({
    post_id: post._id,
    user_id: user_id,
    channel_id: post.channel,
    content: post.content,
    popularity: post.popularity,
    createdAt: post.createdAt,
  }));
  let following = await user.populate({ path: "channels", model: Channel });
  following = following.channels.map((channel) => ({
    channel_id: channel._id,
    name: channel.name,
  }));
  return res.status(200).json({
    username: user.username,
    postCount: user.postCount,
    createdAt: user.createdAt,
    posts: posts,
    following: following,
  });
}

export default async function handler(req, res) {
  try {
    await connectdb();
    if (req.method === "GET") {
      const { feedtype } = req.query;
      if (feedtype === "channel") {
        return await getchannelposts(req, res);
      } else if (feedtype === "profile") {
        return await getprofileposts(req, res);
      } else if (feedtype === "home") {
        return await gethomeposts(req, res);
      }
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
