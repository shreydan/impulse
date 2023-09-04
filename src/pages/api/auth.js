import connectdb from "@/lib/connectdb";
import User from "@/models/user";
import mongoose from "mongoose";
import bcrypt from "bcrypt";

export default async function handler(req, res) {
  try {
    await connectdb();
    if (req.method === "POST") {
      const { username, password } = req.body;
      const user = await User.findOne({ username });
      console.log(user);
      if (!user) {
        // creating new user if username doesnt exist
        console.log("im here", username, password);
        const salt = await bcrypt.genSalt(10);
        const hashedpswd = await bcrypt.hash(password.toString(), salt);
        const user = await User.create({
          username: username,
          password: hashedpswd,
        });
        res.status(200).json({
          message: "new user has been created",
          username: username,
          user_id: user._id,
        });
      } else {
        const validpswd = await bcrypt.compare(
          password.toString(),
          user.password
        );
        if (!validpswd) {
          res.status(400).json({
            AuthError: "invalid password!",
          });
        } else {
          res.status(200).json({
            message: "User login successful",
            user_id: user._id,
          });
        }
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
