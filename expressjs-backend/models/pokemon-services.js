const axios = require("axios");
const mongoose = require("mongoose");
const userModel = require("./pokemon");
const dotenv = require('dotenv')
mongoose.set("debug", true);
dotenv.config()

mongoose
  .connect("mongodb+srv://"+process.env.MONGO_USR+":"+process.env.MONGO_PWD+"@"+
    process.env.MONGO_CLUSTER+".tmxpxx4.mongodb.net/"+process.env.MONGO_DB, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
  })
  .catch((error) => console.log(error));

async function getPokemon(_id, name) 
{
  let result;
  if (_id === undefined && name === undefined) 
  {
    result = await userModel.find();
  }
  else if(_id && !name)
  {
    result = await findPokemonById(_id);
  } 
  else if (!_id && name) 
  {
    result = await findPokemonByName(name);
  } 
  else {
    result = await findPokemonByIdAndName(_id, name);
  }
  return result;
}

async function findPokemonById(id) {
  try {
    return await userModel.findById(id);
  } catch (error) {
    console.log(error);
    return false;
  }
}

async function deletePokemonById(id) 
{
  try 
  {
    return await userModel.findByIdAndDelete(id);
  } 
  catch (error) 
  {
    console.log(error);
    return undefined;
  }
}

async function findPokemonByName(name) {
  try {
    return await userModel.find({ name: name });
  } catch (error) {
    console.log(error);
    return false;
  }
}

async function findPokemonByIdAndName(id, name) {
  try {
    return await userModel.find({ _id: id, name: name });
  } catch(error) {
    console.log(error);
    return false;
  }
}


async function addPokemon(pokemon) {
  var pokemonToAdd = new userModel(pokemon);
  /* handle error 404 */
  if(pokemonToAdd._id && (typeof(pokemonToAdd._id) != typeof(int) && (pokemonToAdd._id < 1 || pokemonToAdd._id > 807))) {
    return { code: 404, msg: "The API used only supports Generations 1-7. Please input any number between 1 and 807."};
  }
  pokemonToAdd = await initializePokeData(pokemonToAdd);
  resetGlobals();
  if(pokemonToAdd._id) {       /* if pokemon (successfully pulled from API) already in db */
    if(await ifPokemonExists(pokemonToAdd._id)) {
      return { code: 409, msg: "Pokémon already exists!"};
    }
    else {      /* Success */
      return pokemonToAdd.save(); 
    }
  } else {        /* invalid input */
    return { code: pokemonToAdd.code, msg: pokemonToAdd.msg};
  }
}

async function ifPokemonExists(id) {
  try {
    temp = await userModel.findById(id)
    if(temp) {
      // console.log("Pokemon exists") //-----
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

var dex_number;
var name;
var description;
var types = [];
var height;
var weight;
var abilities = [];
var evolutionStage;
var evolutionLine = [];
var entry;
async function getDataFromWeb(url) { 
    return await axios.get(url).then(res => {
      dex_number = res.data[0]['number'];
      name = res.data[0]['name'];
      description = res.data[0]['species'];
      // set types
      if(res.data[0]['types'].length == 1) {
        types[0] = res.data[0]['types'][0];
        types[1] = 'None';
      }
      else {
        types[0] = res.data[0]['types'][0];
        types[1] = res.data[0]['types'][1];
      }
      // set height & weight
      height = res.data[0]['height'];
      weight = res.data[0]['weight'];
      // set abilities - normal and hidden
      for(i = 0; i < res.data[0]['abilities']['normal'].length; i++) {
        abilities[i] = res.data[0]['abilities']['normal'][i];
      }
      for(i = 0; i < res.data[0]['abilities']['hidden'].length; i++) {
        abilities[abilities.length + i] = res.data[0]['abilities']['hidden'][i];
      }
      evolutionStage = res.data[0]['family']['evolutionStage'];
      evolutionLine = res.data[0]['family']['evolutionLine'];
      entry = res.data[0]['description'];
    })
    .catch(function(err) {
      console.log(err);
    });
  };

async function initializePokeData(pokemonToAdd) {
  let baseURL = `https://pokeapi.glitch.me/v1/pokemon/`;
  pokeURL = '';
  if(pokemonToAdd._id) {
    pokeURL = baseURL + pokemonToAdd._id.toString();
  } else if (pokemonToAdd.name){
    pokeURL = baseURL + pokemonToAdd.name.toLowerCase();
  }
  /* when user inputs neither number nor name */
  else if (!pokemonToAdd._id && !pokemonToAdd.name) {
    return { code: 409, msg: "No Name or Number given! Please input at least one of them to add a Pokémon."};
  }
  await getDataFromWeb(pokeURL);
  /* when user inputs both number and name, but given number matches to different pokemon */
  if((pokemonToAdd._id && pokemonToAdd.name) && pokemonToAdd.name !== name) {
    return { code: 409, msg: "Given name does not match the given number. Please check again."};
  }
  /* when user inputs only name */
  if(!pokemonToAdd._id && pokemonToAdd.name) {
    pokemonToAdd._id = dex_number;
  }
  pokemonToAdd.name = name;     // force set name
  pokemonToAdd.desc = "The " + description + " Pokémon";
  pokemonToAdd.types = types;
  pokemonToAdd.height = height;
  pokemonToAdd.weight = weight;
  pokemonToAdd.entry = entry;
  pokemonToAdd.abilities = abilities;
  if(evolutionLine.length == 1) {
    pokemonToAdd.preEvo = null;
    pokemonToAdd.postEvo = null;
  }
  else if(evolutionLine.length == 2) {
    if(evolutionStage == 1) {
      pokemonToAdd.preEvo = null;
      pokemonToAdd.postEvo = pokemonToAdd._id+1;
    }
    else if(evolutionStage == 2) {
      pokemonToAdd.preEvo = pokemonToAdd._id-1;
      pokemonToAdd.postEvo = null;
    }
  }
  else if(evolutionLine.length == 3) {
    if(evolutionStage == 1) {
      pokemonToAdd.preEvo = null;
      pokemonToAdd.postEvo = pokemonToAdd._id+1;;
    }
    else if(evolutionStage == 2) {
      pokemonToAdd.preEvo = pokemonToAdd._id-1;
      pokemonToAdd.postEvo = pokemonToAdd._id+1;
    }
    else if(evolutionStage == 3) {
      pokemonToAdd.preEvo = pokemonToAdd._id-1;
      pokemonToAdd.postEvo = null;
    }    
  }
  else {
    return { code: 404, msg: "Something went wrong adding this Pokémon. Please verify input is correct."};
  }

  pokemonToAdd.entry = entry;
  return pokemonToAdd;
}

function resetGlobals() {
  name = null;
  dex_number = null;
  description = null;
  types = [];
  height = null;
  weight = null;
  abilities = [];
  evolutionStage = null;
  evolutionLine = [];
  entry = null;
}

exports.getPokemon = getPokemon;
exports.findPokemonById = findPokemonById;
exports.findPokemonByName= findPokemonByName;
exports.findPokemonByIdAndName = findPokemonByIdAndName;
exports.addPokemon = addPokemon;
exports.deletePokemonById = deletePokemonById;