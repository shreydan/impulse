import connectdb from "@/lib/connectdb";

export default async function test(req, res) {
  try {
    await connectdb();
    res.status(200).json({
      message: `mongodb database has been connected :)`,
    });
  } catch (error) {
    res.status(400).json({
      message: "cannot connect to the database",
      error: error,
    });
  }
}
