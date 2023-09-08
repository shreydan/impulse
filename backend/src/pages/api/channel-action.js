import connectdb from "@/lib/connectdb";
import User from "@/models/user";
import Channel from "@/models/channel";
import mongoose from "mongoose";

async function createChannel(req, res) {
  const { channelname, user_id } = await req.body;
  const channelExists = await Channel.findOne({ name: channelname });
  if (channelExists) {
    return res.status(400).json({
      message: "channel already exists",
    });
  } else {
    const channel = await Channel.create({ name: channelname });
    await User.findByIdAndUpdate(user_id, {
      $push: {
        channels: channel._id,
      },
    });
    await Channel.findByIdAndUpdate(channel._id, {
      $inc: {
        followers: 1,
      },
    });
    return res.status(200).json({
      message: `channel has been successfully created, and followed`,
      channel_id: channel._id,
    });
  }
}

async function followChannel(req, res) {
  const { user_id, channel_id, followtype } = req.body;
  if (followtype === "follow") {
    await User.findByIdAndUpdate(user_id, {
      $push: {
        channels: channel_id,
      },
    });
    const channel = await Channel.findByIdAndUpdate(channel_id, {
      $inc: {
        followers: 1,
      },
    });
    return res.status(200).json({
      message: `user ${user_id} has followed the channel ${channel_id}`,
      followerCount: channel.followers,
    });
  } else if (followtype === "unfollow") {
    await User.findByIdAndUpdate(user_id, {
      $pull: {
        channels: channel_id,
      },
    });
    const channel = await Channel.findByIdAndUpdate(channel_id, {
      $inc: {
        followers: -1,
      },
    });
    return res.status(200).json({
      message: `user ${user_id} has unfollowed the channel ${channel_id}`,
      followerCount: channel.followers,
    });
  }
}

export default async function handler(req, res) {
  try {
    await connectdb();
    if (req.method === "POST") {
      return await createChannel(req, res);
    }
    if (req.method === "PUT") {
      return await followChannel(req, res);
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
