import connectdb from "@/lib/connectdb";
import User from "@/models/user";
import mongoose from "mongoose";

export default async function handler(req, res) {
  const { username } = await req.body;

  try {
    await connectdb();

    const userExists = await User.findOne({ username });
    if (userExists) {
      res.status(400).json({
        message: "user already exists",
      });
    } else {
      const user = await User.create({ username });
      res.status(200).json({
        message: `user has been successfully created`,
        user_id: user._id,
      });
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
