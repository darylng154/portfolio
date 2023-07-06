const axios = require("axios");
const pokemonFunctions = require('./models/pokemon-services.js');
const userFunctions = require('./models/user-services.js');
const mongoose = require("mongoose");
const dotenv = require("dotenv");
mongoose.set("debug", true);
dotenv.config();

mongoose
  .connect("mongodb+srv://"+process.env.MONGO_USR+":"+process.env.MONGO_PWD+"@"+
    process.env.MONGO_CLUSTER+".tmxpxx4.mongodb.net/"+process.env.MONGO_DB, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
  })
  .catch((error) => console.log(error));

// [POKEMON-SERVICES] Tests

test('test addPokemon: id & name given and match', async () => {
  const initial_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  const pokeToAdd = 
  {
    _id: 807,
    name: 'Zeraora'
  };
  const added = await pokemonFunctions.addPokemon(pokeToAdd);
  const result = await pokemonFunctions.getPokemon(807, undefined);
  const new_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  expect(result['_id']).toBe(807);
  expect(result['name']).toBe('Zeraora');
  expect(result['desc']).toBe('The Thunderclap Pokémon');
  expect(initial_length + 1).toBe(new_length);

  await pokemonFunctions.deletePokemonById(807);
});

test('test addPokemon: only id given', async () => {
  const initial_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  const pokeToAdd = 
  {
    _id: 807,
    name: undefined
  };
  const added = await pokemonFunctions.addPokemon(pokeToAdd);
  const result = await pokemonFunctions.getPokemon(807, undefined);
  const new_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  expect(result['_id']).toBe(807);
  expect(result['name']).toBe('Zeraora');
  expect(result['desc']).toBe('The Thunderclap Pokémon');
  expect(initial_length + 1).toBe(new_length);
  
  await pokemonFunctions.deletePokemonById(807);
});

test('test addPokemon: only name given', async () => {
  const initial_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  const pokeToAdd = 
  {
    _id: undefined,
    name: 'Zeraora'
  };
  const added = await pokemonFunctions.addPokemon(pokeToAdd);
  const result = await pokemonFunctions.getPokemon(807, undefined);
  const new_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  expect(result['_id']).toBe(807);
  expect(result['name']).toBe('Zeraora');
  expect(result['desc']).toBe('The Thunderclap Pokémon');
  expect(initial_length + 1).toBe(new_length);
  
  await pokemonFunctions.deletePokemonById(807);
}); 

test('test addPokemon: only lowercase name given ', async () => {
  const initial_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  const pokeToAdd = 
  {
    _id: undefined,
    name: 'zeraora'
  };
  const added = await pokemonFunctions.addPokemon(pokeToAdd);
  const result = await pokemonFunctions.getPokemon(807, undefined);
  const new_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  expect(result['_id']).toBe(807);
  expect(result['name']).toBe('Zeraora');
  expect(result['desc']).toBe('The Thunderclap Pokémon');
  expect(initial_length + 1).toBe(new_length);
  
  await pokemonFunctions.deletePokemonById(807);
});

test('test addPokemon: id & name given and do not match', async () => {
  const initial_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  const pokeToAdd = 
  {
    _id: 806,
    name: 'Zeraora'
  };
  const result = await pokemonFunctions.addPokemon(pokeToAdd);
  const new_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  expect(result.code).toBe(409);
  expect(result.msg).toBe("Given name does not match the given number. Please check again.");
  expect(initial_length).toBe(new_length);
}); 

test('test addPokemon: neither name nor id given', async () => {
  const initial_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  const pokeToAdd = 
  {
    _id: undefined,
    name: undefined
  };
  const result = await pokemonFunctions.addPokemon(pokeToAdd);
  const new_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  expect(result.code).toBe(409);
  expect(result.msg).toBe("No Name or Number given! Please input at least one of them to add a Pokémon.");
  expect(initial_length).toBe(new_length);
}); 

test('test addPokemon: negative id', async () => {        // id takes priority when checking pokemon, so no test cases with different combinations of negative id and name need to exist
  const initial_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  const pokeToAdd = 
  {
    _id: -1,
    name: undefined
  };
  const result = await pokemonFunctions.addPokemon(pokeToAdd);
  const new_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  expect(result.code).toBe(404);
  expect(result.msg).toBe("The API used only supports Generations 1-7. Please input any number between 1 and 807.");
  expect(initial_length).toBe(new_length);
}); 

test('test addPokemon: greater than maximum id', async () => {
  const initial_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  const pokeToAdd = 
  {
    _id: 808,
    name: undefined
  };
  const result = await pokemonFunctions.addPokemon(pokeToAdd);
  const new_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  expect(result.code).toBe(404);
  expect(result.msg).toBe("The API used only supports Generations 1-7. Please input any number between 1 and 807.");
  expect(initial_length).toBe(new_length);
});

test('test addPokemon: misspelled name', async () => {
  const initial_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  const pokeToAdd = 
  {
    _id: undefined,
    name: 'Zerora'
  };
  const result = await pokemonFunctions.addPokemon(pokeToAdd);
  const new_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  expect(result.code).toBe(404);
  expect(result.msg).toBe("Something went wrong adding this Pokémon. Please verify input is correct.");
  expect(initial_length).toBe(new_length);
});

test('test addPokemon: id & name given, duplicate post', async () => {
  await pokemonFunctions.addPokemon({ _id: 807,name: 'Zeraora' });    // guarantee it is in the database

  const initial_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  const pokeToAdd = 
  {
    _id: 807,
    name: 'Zeraora'
  };
  const result = await pokemonFunctions.addPokemon(pokeToAdd);
  const new_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  expect(result.code).toBe(409);
  expect(result.msg).toBe("Pokémon already exists!");
  expect(initial_length).toBe(new_length);
  
  await pokemonFunctions.deletePokemonById(807);  
});

test('test addPokemon: satisfy evolutionLine = 1', async () => {
  const pokeToAdd = 
  {
    _id: 807,
    name: undefined
  };
  const added = await pokemonFunctions.addPokemon(pokeToAdd);
  const result = await pokemonFunctions.getPokemon(807, undefined);
  expect(result['_id']).toBe(807);
  expect(result['name']).toBe('Zeraora');
  expect(result['desc']).toBe('The Thunderclap Pokémon');
  
  await pokemonFunctions.deletePokemonById(807);
});

test('test addPokemon: satisfy evolutionLine = 2, evolutionStage = 1', async () => {
  const pokeToAdd = 
  {
    _id: 285,
    name: undefined
  };
  const added = await pokemonFunctions.addPokemon(pokeToAdd);
  const result = await pokemonFunctions.getPokemon(285, undefined);
  expect(result['_id']).toBe(285);
  expect(result['name']).toBe('Shroomish');
  expect(result['desc']).toBe('The Mushroom Pokémon');
  
  await pokemonFunctions.deletePokemonById(285);
});

test('test addPokemon: satisfy evolutionLine = 2, evolutionStage = 2', async () => {
  const pokeToAdd = 
  {
    _id: 286,
    name: undefined
  };
  const added = await pokemonFunctions.addPokemon(pokeToAdd);
  const result = await pokemonFunctions.getPokemon(286, undefined);
  expect(result['_id']).toBe(286);
  expect(result['name']).toBe('Breloom');
  expect(result['desc']).toBe('The Mushroom Pokémon');
  
  await pokemonFunctions.deletePokemonById(286);
});

test('test addPokemon: satisfy evolutionLine = 3, evolutionStage = 1', async () => {
  const pokeToAdd = 
  {
    _id: 551,
    name: undefined
  };
  const added = await pokemonFunctions.addPokemon(pokeToAdd);
  const result = await pokemonFunctions.getPokemon(551, undefined);
  expect(result['_id']).toBe(551);
  expect(result['name']).toBe('Sandile');
  expect(result['desc']).toBe('The Desert Croc Pokémon');
  
  await pokemonFunctions.deletePokemonById(551);
});

test('test addPokemon: satisfy evolutionLine = 3, evolutionStage = 2', async () => {
  const pokeToAdd = 
  {
    _id: 552,
    name: undefined
  };
  const added = await pokemonFunctions.addPokemon(pokeToAdd);
  const result = await pokemonFunctions.getPokemon(552, undefined);
  expect(result['_id']).toBe(552);
  expect(result['name']).toBe('Krokorok');
  expect(result['desc']).toBe('The Desert Croc Pokémon');
  
  await pokemonFunctions.deletePokemonById(552);
});

test('test addPokemon: satisfy evolutionLine = 3, evolutionStage = 3', async () => {
  const pokeToAdd = 
  {
    _id: 553,
    name: undefined
  };
  const added = await pokemonFunctions.addPokemon(pokeToAdd);
  const result = await pokemonFunctions.getPokemon(553, undefined);
  expect(result['_id']).toBe(553);
  expect(result['name']).toBe('Krookodile');
  expect(result['desc']).toBe('The Intimidation Pokémon');
  
  await pokemonFunctions.deletePokemonById(553);
});

test('test getPokemon, findPokemonById', async () => {
  const pokeToAdd = { _id: 807, name: 'Zeraora' };
  const added = await pokemonFunctions.addPokemon(pokeToAdd);

  const target = 'Zeraora';
  const id = 807;   // Zeraora
  const result = await pokemonFunctions.getPokemon(id, undefined);
  expect(result['_id']).toBe(id);
  expect(result['name']).toBe(target);
  expect(result['desc']).toBe('The Thunderclap Pokémon');

  await pokemonFunctions.deletePokemonById(807);
});

test('test getPokemon, findPokemonByName', async () => {
  const pokeToAdd = { _id: 807, name: 'Zeraora' };
  const added = await pokemonFunctions.addPokemon(pokeToAdd);

  const target = 807;   // Zeraora
  const name = "Zeraora";
  const result = await pokemonFunctions.getPokemon(undefined, name);
  expect(result[0]['_id']).toBe(target);
  expect(result[0]['name']).toBe(name);
  expect(result[0]['desc']).toBe('The Thunderclap Pokémon');

  await pokemonFunctions.deletePokemonById(807);
});

test('test getPokemon, findPokemonByIdAndName', async () => {
  const pokeToAdd = { _id: 807, name: 'Zeraora' };
  const added = await pokemonFunctions.addPokemon(pokeToAdd);

  const name = "Zeraora";
  const id = 807;   // Zeraora
  const result = await pokemonFunctions.getPokemon(id, name);
  expect(result[0]['_id']).toBe(id);
  expect(result[0]['name']).toBe(name);
  expect(result[0]['desc']).toBe('The Thunderclap Pokémon');

  await pokemonFunctions.deletePokemonById(807);
});

test('test deletePokemonById', async () => {
  const initial_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  const pokeToAdd = { _id: 807, name: 'Zeraora' };
  await pokemonFunctions.addPokemon(pokeToAdd);
  const added_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  expect(initial_length + 1).toBe(added_length);

  await pokemonFunctions.deletePokemonById(807);
  const new_length = Object.keys(await pokemonFunctions.getPokemon()).length;
  expect(added_length - 1).toBe(new_length);
  const none = await pokemonFunctions.getPokemon(807, undefined);
  expect(none).toBe(null);
});


test("test addUser - hi, bye", async () => {
  user = { _id: "hi", password: "bye" };
  const add = await userFunctions.addUser(user);
  const result = await userFunctions.findUserById("hi");

  expect(result._id).toBe("hi");
  expect(result.password).toBe("bye");
});

test("test addUser - already exists", async () => {
  user = { _id: "hi", password: "bye" };
  const add = await userFunctions.addUser(user);

  expect(add).toBe(403);
});

test("test getUsers - all", async () => {
  const result = await userFunctions.getUsers();
  len = result.length
  expect(result[len-1]._id).toBe("hi");
  expect(result[len-1].password).toBe("bye");
});

test("test getUsers - specific", async () => {
  const result = await userFunctions.getUsers('hi');
  expect(result._id).toBe("hi");
  expect(result.password).toBe("bye");
});

test("test findUserById - hi", async () => {
  const result = await userFunctions.findUserById("hi");
  expect(result._id).toBe("hi");
  expect(result.password).toBe("bye");
});

test("test logInUser - success", async () => {
  user = { _id: 'hi', password: 'bye', favorites: [], __v: 0 }
  const result = await userFunctions.logInUser(user); //requires user object
  expect(result._id).toBe("hi");
});

test("test logInUser - Denied", async () => {
  user = { _id: 'hi', password: 'wrong', favorites: [], __v: 0 }
  const result = await userFunctions.logInUser(user); //requires user object
  expect(result).toBe(401);
});

test("test updateUser - add favorite", async () => {
  user = { _id: 'hi', password: 'bye', favorites: [1], __v: 0 }
  const result = await userFunctions.updateUser(user);
  expect(result.favorites[0]).toBe(1);
});

test("test updateUser - remove favorite", async () => {
  user = { _id: 'hi', password: 'bye', favorites: [], __v: 0 }
  const result = await userFunctions.updateUser(user);
  expect(result.favorites).toStrictEqual([]);
});

test("test updateUser - 404 error", async () => {
  user = { _id: 'nonexistanttest', password: 'bye', favorites: [], __v: 0 }
  const result = await userFunctions.updateUser(user);
  expect(result).toBe(404);
});

test("test deleteUser - hi", async () => {
  const result = await userFunctions.findUserById("hi");
  console.log("deleteUser result:" + result);
  const del = await userFunctions.deleteUserById(result._id);

  const after_result = await userFunctions.findUserById("hi");

  expect(after_result).toEqual(null);
});
