const mongoose = require("mongoose");

const PokemonSchema = new mongoose.Schema(
  {
    _id: {
      type: Number,
      required: false,
    },
    name: {
      type: String,
      required: false,
      trim: true,
    },
    desc: {
      type: String,
      required: false,
      trim: true,
    },
    image: {
      type: String,
      required: false,
      trim: true,
    },
    types: [
      {
      type: String,
      required: false,
      trim: true,
      },
    ],
    height: {
      type: String,
      required: false,
      trim: true,
    },
    weight: {
      type: String,
      required: false,
      trim: true,
    },
    entry: {
      type: String,
      required: false,
      trim: true,
    },
    abilities: [
      {
        type: String,
        required: false,
        trim: true,
      },
    ],
    preEvo: {
      type: Number,
      required: false,
    },
    postEvo: {
      type: Number,
      required: false,
    },
  },
  { collection: "poke_list" }
);

const Pokemon = mongoose.model("Pokemon", PokemonSchema);

module.exports = Pokemon;