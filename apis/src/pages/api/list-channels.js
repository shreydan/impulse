import connectdb from "@/lib/connectdb";
import User from "@/models/user";
import Channel from "@/models/channel";
import mongoose from "mongoose";

export default async function handler(req, res) {
  try {
    await connectdb();

    if (req.method === "GET") {
      const { listtype } = req.query;
      if (listtype === "all") {
        const channelList = [];
        const channels = await Channel.find()
          .sort({ createdAt: -1 })
          .then((channels) => {
            channels.forEach((channel) => {
              channelList.push({
                channel_id: channel._id,
                channel_name: channel.name,
              });
            });
          });
        console.log(channels);
        res.status(200).json({
          channels: channelList,
        });
      } else if (listtype === "user") {
        const { user_id } = req.query;
        const user = User.findById(user_id);
        let following = await user.populate({
          path: "channels",
          model: Channel,
        });
        following = following.channels.map((channel) => ({
          channel_id: channel._id,
          name: channel.name,
        }));
        res.status(200).json({
          channels: following,
        });
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
