const express = require("express");
const cors = require("cors");

const pokeServices = require("./models/pokemon-services");
const userServices = require("./models/user-services");
const { count } = require("./models/pokemon");

const app = express();
const port = 5001;

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Hello World!");
});

// POKE related functions

app.get("/poke", async (req, res) => 
{
  const id = req.query["_id"];
  const name = req.query["name"];
  const job = req.query["job"];
  try 
  {
    const result = await pokeServices.getPokemon(id, name, job);
    res.send({ poke_list: result });
  } catch (error) {
    console.log(error);
    res.status(500).send("An error ocurred in the server.");
  }
});

app.get("/poke/:id", async (req, res) => {
  const id = req.params["id"];
  const result = await pokeServices.findPokemonById(id);
  if (result === undefined || result === null)
    res.status(404).send("Pokémon not found.");
  else {
    res.send({ poke_list: result });
  }
});

app.post("/poke", async (req, res) => {
  const poke = req.body;
  const savedPoke = await pokeServices.addPokemon(poke);
  if (savedPoke.code === 409) {
    res.status(409).send(savedPoke);    // 409 is conflict response
  } else if (savedPoke.code === 404) {
    res.status(404).send(savedPoke);    // 404 is not found
  }
  else {
    res.status(201).send(savedPoke);         // 201 is success
  }
});

app.delete("/poke/:id", async (req, res) => {
  const id = req.params["id"]; //or req.params.id
  let result = await pokeServices.deletePokemonById(id);
  console.log(`delete result: ${result}`);     // debugging results

  if (result === undefined || result == -1)
    res.status(404).end('Pokémon cannot be deleted. Please verify that the Pokémon is in the database and that input is correct.');
  else res.status(204).end();
});

// USERS related functions

app.get("/users", async (req, res) => {
  const username = req.query["username"];
  try {
    const result = await userServices.getUsers(username);
    res.send({ users_list: result });
  } catch (error) {
    console.log(error);
    res.status(500).send("An error ocurred in the server.");
  }
});

app.get("/users/:id", async (req, res) => {
  const id = req.params["id"];
  const result = await userServices.findUserById(id);
  if (result === undefined || result === null)
    res.status(404).send("User not found.");
  else {
    res.send({ users_list: result });
  }
});

app.post("/logIn", async (req, res) => {
  const user = req.body;
  const savedUser = await userServices.logInUser(user);
  if (typeof savedUser !== typeof 5) { //if it's not an integer/error code
    // console.log("On backend.");
    // console.log(savedUser);
    res.status(200).send(savedUser);
      //User exists, send data as string to avoid HTTP error shutdown
  }
  else if (savedUser === 401) {
    res.status(401).send(savedUser);              //Denied Access
  }
  else res.status(500).end();     //Error
});

app.post("/signUp", async (req, res) => {
  const user = req.body;
  const savedUser = await userServices.addUser(user);
  if (savedUser === 403) {
    res.send('403');  //User exists, send data as string to avoid HTTP error shutdown
  }
  else if (savedUser) res.status(201).send(savedUser);  //Valid user
  else res.status(500).end();                           //Error
});

app.put("/users", async (req, res) => {
  const user = req.body;
  const savedUser = await userServices.updateUser(user);

  if (savedUser) res.status(201).send(savedUser);  //Valid user
  else res.status(500).end();                           //Error
});

app.delete("/user/:id", async (req, res) => {
  const id = req.params["id"]; //or req.params.id
  let result = await userServices.deleteUserById(id);
  // console.log(`delete result: ${result}`);     // debugging results

  if (result === undefined || result == -1)
    res.status(404).send("User not found.");
  else res.status(204).end();
});

app.listen(process.env.PORT || port, () => {
  console.log("REST API is listening.");
});
