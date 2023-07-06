import { Button } from '@mui/material';
import axios from 'axios';
import React, {useState} from 'react'
import { Link } from 'react-router-dom';

import { useParams } from 'react-router-dom';
import "./WikiPage.css";

const images = require('./images.js');

function WikiPage(props) {
    const[wikiMon, setWikiMon] = useState({});
    const [wikiTypes, setTypes] = useState({});
    const [wikiAbilities, setAbilities] = useState({});
    let pokeID = parseInt(useParams().id);

    getPokemonById(pokeID).then( result => {
        if (result) {
           setWikiMon(result);
           setTypes(result.types);
           setAbilities(result.abilities);
        }
        });
    //console.log(wikiMon);
    async function getPokemonById(id) {
        try {
          const response = await axios.get(`http://localhost:5001/poke/${id}`);
        //   console.log(response.data.poke_list);
          let returnObj = response.data.poke_list;
          return returnObj;
       }
       catch (error){
          console.log(error); 
          return false;         
       }
      }
    function getImageString(poke) {
        let imgString = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/";
        let pokeNum = String(poke._id);
        while (pokeNum.length < 3) {
            pokeNum = "0".concat(pokeNum);
        }

        imgString = imgString.concat(pokeNum);
        imgString = imgString.concat(".png");
        return imgString;
    }

    function getImageStringById(pokeId) {
        let imgString = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/";
        let pokeNum = String(pokeId);
        while (pokeNum.length < 3) {
            pokeNum = "0".concat(pokeNum);
        }

        imgString = imgString.concat(pokeNum);
        imgString = imgString.concat(".png");
        return imgString;
    }

    function getAbilityString() {

        let pokeAbility = wikiAbilities;
        let string = "";
        // console.log(`abilities: ${wikiAbilities} | len: ${wikiAbilities.length}| str: `);

        for (var i = 0; i < pokeAbility.length-1; i++) 
        {
            string += `${pokeAbility[i]}`;
            string += ', ';
        }
        string += `${pokeAbility[i]}`;

        return String(string);
    }
    return (
       
        <div className="Pokedex">
            <t>&emsp;</t>            {props.currentUser.favorites === undefined ? <text></text> : 
            props.currentUser.favorites.includes(wikiMon._id) ? <img onClick = {() =>props.removeFavorite(wikiMon._id)} src="/heart pixel.jpeg" alt = "" width={40} height ={40}/> : 
            <img onClick = {() =>props.addFavorite(wikiMon._id)} src="/heart pixel unfilled.png" alt = "" width={40} height = {40}/>}

        <br></br>
        
        <div className="component-5">
          <img className="background-icon" alt="" src="/background@2x.png" />
          <img className="image-icon" alt="" src={getImageString(wikiMon)} />
          {/* <div className="pre-image-icon">{wikiMon.preEvo ? <img alt="" src={getImageStringById(wikiPre)} /> : ""}</div> */}
          <img className="sprite-icon" alt="" src={images.getPokemonShinySprite(String(wikiMon.name))} />
          <div className="weight">{wikiMon.weight}</div>
          <div className="height">{wikiMon.height}</div>
          <div className="ability-text">{getAbilityString(wikiMon)}</div>
          <div className="no">{wikiMon._id}</div>
          <div className="name">{wikiMon.name}</div>
          <div><Link to={"/users-table/"+wikiTypes[0]}>{<img className="type1-icon" alt="" src={images.getPokemonType(wikiTypes[0])} />}</Link></div>
          <div>{wikiTypes[1] === 'None' ? '' : <Link to={"/users-table/"+wikiTypes[1]}>{<img className="type2-icon" alt="" src={images.getPokemonType(wikiTypes[1])} />}</Link>}</div> 
          <div className="description">{wikiMon.desc}</div>
          <div className="abilities">Abilities:</div>
          {/* <div className="prename">{wikiMon.preEvo ? "Pre Evo" : ""}</div>
          <div className="postname">{wikiMon.postEvo ? "Post Evo" : "" }</div> */}
          <div className="entry">{wikiMon.entry}</div>
          {/* <div className="post-image-icon">{wikiMon.postEvo ? <img alt="" src={getImageStringById(wikiMon.postEvo)} /> : ""}</div> */}
        </div>
      </div>
    )
}

export default WikiPage;