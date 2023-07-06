import axios from 'axios';

import React, {useState, useEffect} from 'react'
import Table from './Table'
import Form from './Form';
import Box from '@mui/material/Box';
import Grid from '@mui/material/Unstable_Grid2';
import NavBar from "./NavBar";
import Home from "./Home";
import WikiPage from "./WikiPage";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import SignIn from './SignIn';
import SignUp from './SignUp';
// characters is the array for people/person [names + jobs] defined in Form.js
function MyApp() { 
const [characters, setCharacters] = useState([/*empty Table*/]);

const [featured, setFeatured] = useState({});
const [currentUser, setCurrent] = useState({});
const [errNum, setErr] = useState(false);

useEffect(() => {
  fetchAll().then( result => {
     if (result) {
        setCharacters(result);
        setFeatured(result[Math.floor(Math.random() * result.length)]);
     }
   });
}, [] );

// const navigate = useNavigate();
// characters & removeOneCharacter = props we are passing to Table
// updatePokeList = prop passing to Form
return (  // return for MyApp()
  <div className="container">
      <h1>Welcome to PokeWiki!</h1>
      <BrowserRouter basename="/">
        <NavBar currentUser = {currentUser} logOut = {logOut}/>
        <Routes>
        <Route
            path="/"
            element={
              <Home featured = {featured} setFeatured = {getRandomFeatured} pokemon = {characters}/>
            }
          />
          <Route
            path="/users-table"
            element={
              <Table
                characterData={characters}
                removeCharacter={removeOneCharacter}
                favesList = {undefined}
                removeFavorite = {removeFaveMon}
              />
            }
            >
              
              <Route path = "/users-table/:type1"
              >
                <Route path = "/users-table/:type1/:type2">

                </Route>
              </Route>
          </Route>
          <Route path="/favorites" element={<Table characterData={characters}
                removeCharacter={removeOneCharacter}
                favesList = {currentUser.favorites}
                removeFavorite = {removeFaveMon}/>} />
          <Route path="/form" element={<Form handleSubmit={updatePokeList} />} />
          <Route path="/login" element={<SignIn handleSubmit={userLogIn} errNum = {errNum}/>} />
          <Route path = "/pokemon/:id" element = {<WikiPage addFavorite = {addFaveMon} removeFavorite = {removeFaveMon} currentUser = {currentUser}></WikiPage>} />
          <Route path = "/signUp" element = {<SignUp handleSubmit={userSignUp} setUser = {setCurrent}/>} />
        </Routes>
      </BrowserRouter>

      <Box
        component="img"
        sx={{
          height: 250,
          width: 1000,
          maxHeight: { xs: 500, md: 250 },
          maxWidth: { xs: 350, md: 1000 },
        }}
        alt="Widechu"
        src="https://www.pokemoncenter.com/images/DAMRoot/Full-Size/10000/P9191_701-97694_02.jpg"
      />
    </div>
)
function removeItemOnce(arr, value) {
  var index = arr.indexOf(value);
  if (index > -1) {
    arr.splice(index, 1);
  }
  return arr;
}

function logOut() {
  setCurrent({});
}
function addFaveMon(newID) {
  currentUser.favorites.push(newID);
  makeUserPutCall(currentUser).then( result => {
    if (result && result.status === 201) {
      setCurrent(result)
    }
  });
}
function removeFaveMon(newID) {
  removeItemOnce(currentUser.favorites, newID);
  console.log("Removed " + newID + " in MyApp")
  makeUserPutCall(currentUser).then( result => {
    if (result && result.status === 201) {
      setCurrent(result)
    }
  });
}
function removeOneCharacter (index) {
  makeDeleteIdCall(characters.at(index)._id);
  const updated = characters.filter((character, i) => {
    return i !== index
  });
  setCharacters(updated);
}

function getRandomFeatured(pokemon) {
  const randomElement = pokemon[Math.floor(Math.random() * pokemon.length)];
  console.log(currentUser.favorites);
  console.log(randomElement);
  setFeatured(randomElement);
}

function updatePokeList(poke) { 
  makePokePostCall(poke).then( result => {
    if (result && result.status === 201)
      setCharacters([...characters, result.data] );
  });
}

// calls to our API requests endpoints
async function fetchAll(){
  try {
     const response = await axios.get('http://localhost:5001/poke');
     return response.data.poke_list;     
  }
  catch (error){
     //We're not handling errors. Just logging into the console.
     console.log(error); 
     return false;
  }
}

async function makePokePostCall(poke){
  console.log(poke)
  try {
     const response = await axios.post('http://localhost:5001/poke', poke)
        .catch(function(err) {
          alert("Post failed: " + err.response.data.msg);
        });
     if(response.status === 201) {
      alert("Success: " + response.data.name + " successfully added to the Wiki.");
     }
     return response;
  }
  catch (error) {
     console.log(error);
     return false;
  }
}

async function makeUserPutCall(user){
  console.log(user)
  try {
     const response = await axios.put('http://localhost:5001/users', user);
     if(response.data === '409') {
      // alert
     }
     console.log(response.data);
     return response.data;
  }
  catch (error) {
     console.log(error);
     return false;
  }
}

async function userLogIn(person){ //Sign-in for existing user
  try {
    const response = await axios.post('http://localhost:5001/logIn', person)
    .catch(function (error) {if(error.response.status == 401) {
      alert("Invalid Credentials");
      setErr(error.response.status);
      return;
        }})

    if(response.status === 200) {
      setCurrent(response.data);
      alert("You are signed in");
    }
    else if(response.status == 401) {
      console.log(response.status);
      alert("Invalid Credentials")
    }
    else {return response;}
  }
  catch (error) {
    console.log(error);
    return false;
  }
}

async function userSignUp(person){ //Adds new user to backend
  try {
    const response = await axios.post('http://localhost:5001/signUp', person);
    // console.log(response.data)
    if(response.data === 403) {   
      alert("This username is already taken, please use a different one.");
    }

    else {
      //navigate back to home here -----
      
      return response;
    }
  }
  catch (error) {
    console.log(error);
    return false;
  }
}

async function makeDeleteIdCall(id){
  try {
     const response = await axios.delete(`http://localhost:5001/poke/${id}`);
     return response.data.users_list;     
  }
  catch (error){
     console.log(error); 
     return false;         
  }
}

}  

export default MyApp;