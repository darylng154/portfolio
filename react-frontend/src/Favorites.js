import React, {useState} from 'react'
import { Link } from 'react-router-dom';
import SearchBar from './SearchBar.js';
import { useParams } from 'react-router-dom';
import Button from '@mui/material/Button';
import MultipleSelectChip from './ChipMenu.js';

const images = require('./images.js');





function TableHeader()  {
  return (
    <thead>
      <tr>
        <th>No.</th>
        <th>Sprite</th>
        <th>Shiny Sprite</th>
        <th>Name</th>
        <th>Type 1</th>
        <th>Type 2</th>
        <th>Description</th>
        <th>Remove</th>
      </tr>
    </thead>
  );
}
function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}
function matchTypes(type1, type2, poke) {
  
  
  if (type1 === undefined && type2 === undefined) {
    return true;
  }
  if (!(type1 === undefined) && (!(type1.trim().length === 0))) {
    if (!(poke.types.includes(capitalizeFirstLetter(type1)))) {
      return false;
    }
  }
  if ((!(type2 === undefined)) && !(type2.trim().length === 0)) {
    
    if (!(poke.types.includes(capitalizeFirstLetter(type2)))) {
      return false;
    }
  }
  return true;
}

function compareByID(a, b) {
  return (a._id-b._id);
}
function TableBody(props) {
  props.characterData.sort(compareByID);
  const rows = props.characterData.map((row, index) => {
  
    if (row.name.toLowerCase().includes(props.search.toLowerCase()) && matchTypes(props.types[0], props.types[1], row)) {
    return (
      <tr key={index}>
        <td>{row._id}</td>
        <td>{
          <Link to={"/pokemon/"+row._id}>
            <img src={images.getPokemonSprite(row.name)} alt=""/>
          </Link>
        }</td>      
        <td>{
          <Link to={"/pokemon/"+row._id}>
            <img src={images.getPokemonShinySprite(row.name)} alt=""/>
          </Link>
        }</td>
        <td>{<Link to={"/pokemon/"+row._id}>{row.name}</Link>}</td>
        <td>{
          <Link to = {"/users-table/"+row.types[0]}>
          <img id = "type1" src={images.getPokemonType(row.types[0])}  onClick = {() =>props.setTypes(row.types[0])} alt=""/>
          </Link>
        }</td>
        <td>{
          <Link to = {"/users-table/"+row.types[1]}>
          <img id = "type 2" src={images.getPokemonType(row.types[1])}  onClick = {() =>props.setTypes(row.types[1])}alt=""/>
          </Link>
        }
        </td>
        <td>{row.desc}</td>
        <td>
          <Button variant = 'contained' onClick={() => props.removeCharacter(index)}>Delete</Button>
        </td>
      </tr>
    );
   }
   return null;
  }
  );
  return (
      <tbody>
        {rows}
       </tbody>
   );
}

function Favorites (props) {
  let {type1, type2} = useParams();
  let typeArr = [];
  
  if (!(type1===undefined)) {
    type1 = capitalizeFirstLetter(type1);
    typeArr.push(type1);
  }
  if (!(type2===undefined)) {
    type1 = capitalizeFirstLetter(type2);
    typeArr.push(type2);
  }
  function updateTypes(newType) {
    if (types.includes(newType)) {
      return;
    }

    if (types[0] === undefined || types[0].trim().length === 0) {
      setTypes([newType, types[1]]);
      return;
    }
    if (types[1] === undefined || types[1].trim().length === 0) {
      setTypes([types[0], newType]);
      return;
    }
  }

  const [search, updateSearch] = useState("");
  const [types, setTypes] = useState(typeArr);
  return (
    <div>
    <SearchBar setSearchVal = {updateSearch} searchVal = {search}/>
    <MultipleSelectChip setTypes = {setTypes} types = {types}></MultipleSelectChip>
    <table>
      <TableHeader />
      <TableBody characterData={props.characterData} removeCharacter={props.removeCharacter} search = {search} types = {types} setTypes = {updateTypes}/>
    </table>
    </div>
  );
}

export default Favorites;