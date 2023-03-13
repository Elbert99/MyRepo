import mongoose from 'mongoose';

const connectDB = async (DATABASE_URL) => {
 try {
  const DB_OPTIONS = {
   dbName: 'Usersdata',
  }
  await mongoose.connect(DATABASE_URL, DB_OPTIONS);
  console.log('Connected Successfully to Database..');
 } catch (err) {
  console.log(err);
 }
}

export default connectDB