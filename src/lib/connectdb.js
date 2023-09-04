import mongoose from "mongoose";

const connectdb = async () => {
  try {
    if (mongoose.connection.readyState === 0) {
      await mongoose.connect(process.env.MONGO_URL);
      console.log("connected to the cluster");
    }
  } catch (error) {
    console.error(error);
  }
};

export default connectdb;
