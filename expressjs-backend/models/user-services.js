const mongoose = require("mongoose");
const userModel = require("./user");
const dotenv = require("dotenv");
mongoose.set("debug", true);
dotenv.config();

mongoose
  .connect(
    "mongodb+srv://" +
      process.env.MONGO_USR +
      ":" +
      process.env.MONGO_PWD +
      "@" +
      process.env.MONGO_CLUSTER +
      ".tmxpxx4.mongodb.net/" +
      process.env.MONGO_DB,
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    }
  )
  .catch((error) => console.log(error));

async function getUsers(username) {
  let result;
  if (username === undefined) {
    result = await userModel.find();
  } else {
    result = await findUserById(username);
  }
  return result;
}

async function findUserById(id) {
  try {
    return await userModel.findById(id);
  } catch (error) {
    console.log(error);
    return undefined;
  }
}

async function ifUserExists(id) {
  try {
    temp = await userModel.findById(id)
    if(temp) {
      // console.log("User exists") //-----
      return true
    }
    else {
      // console.log('Not here') //-----
      return false
    }
  } 
  catch (error) {
    console.log(error);
    return undefined;
  }
}

async function logInUser(user) {
  try {
    if(await findUserByUsernameAndPassword(user._id, user.password)) { //if username and password are found exists
      // console.log(userModel.findById(user._id));
      // console.log('in here')
      return await userModel.findById(user._id); //succesful login
    }
    else {
      return 401; //Denied Access
    }
  } 
  catch (error) {
    console.log(error);
    return false;
  }
}

async function addUser(user) {
  try {
    if(await ifUserExists(user._id)) { //if user already exists
      return 403
    }
    // else
    const userToAdd = new userModel(user);
    userToAdd.favorites = [];
    const savedUser = await userToAdd.save();
    return savedUser;
  } 
  catch (error) {
    console.log(error);
    return false;
  }
}

async function updateUser(user) {
  try {
    if (await ifUserExists(user._id)) {
      // console.log("Looking for: " + user._id);
      await userModel.updateOne({_id: user._id}, { $set: {"favorites": user.favorites}});
      // console.log("Replaced user " + user._id);
      return user;
    } else {
      return 404;
    }
  }catch(error) {
      console.log(error);
      return false;

  }
}

async function deleteUserById(id) {
  try {
    return await userModel.findByIdAndDelete(id);
  } catch (error) {
    console.log(error);
    return undefined;
  }
}

async function findUserByUsernameAndPassword(id, pass) {
  return await userModel.findOne({ '_id': id, 'password': pass });
}

exports.getUsers = getUsers;
exports.findUserById = findUserById;
exports.addUser = addUser;
exports.deleteUserById = deleteUserById;
exports.logInUser = logInUser;
exports.updateUser = updateUser;
