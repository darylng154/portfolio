const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema(
  {
    _id: {
      type: String,
      required: true,
      trim: true,
    },
    password: {
      type: String,
      required: true,
      trim: true,
    },

    favorites: [
      {
      type: Number,
      required: false,
      trim: true,
      },
    ]
  },
  { collection: "users_list" }
);

const User = mongoose.model("User", UserSchema);

module.exports = User;
