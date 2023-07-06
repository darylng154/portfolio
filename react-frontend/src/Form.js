import React, {useState} from 'react';
import Button from '@mui/material/Button'

function Form(props) {
  const [pokemon, setPokemon] = useState(
     {
        _id: "",
        name: "",
        types: ["", ""],
        desc: "",
        preEvo: "",
        postEvo: "",
     }
  );

    function handleChange(event) {
        const { name, value } = event.target;
        if (name === "desc")
        setPokemon(
            {_id: pokemon['_id'], name: pokemon['name'], types: [pokemon.types[0], pokemon.types[1]],
            desc: value, preEvo: pokemon['preEvo'], postEvo: pokemon['postEvo']}
        );
        else if(name === '_id')
        setPokemon(
            {_id: value, name: pokemon['name'], types: [pokemon.types[0], pokemon.types[1]],
            desc: pokemon['desc'], preEvo: pokemon['preEvo'], postEvo: pokemon['postEvo']}
        );
        else if(name === 'name')    
        setPokemon(
            {_id: pokemon['_id'], name: value, types: [pokemon.types[0], pokemon.types[1]],
            desc: pokemon['desc'], preEvo: pokemon['preEvo'], postEvo: pokemon['postEvo']}   
        );
        else if(name === 'types[0]')    
        setPokemon(
            {_id: pokemon['_id'], name: pokemon['name'], types: [value, pokemon.types[1]],
            desc: pokemon['desc'], preEvo: pokemon['preEvo'], postEvo: pokemon['postEvo']}   
        );
        else if(name === 'types[1]')    
        setPokemon(
            {_id: pokemon['_id'], name: pokemon['name'], types: [pokemon.types[0], value],
            desc: pokemon['desc'], preEvo: pokemon['preEvo'], postEvo: pokemon['postEvo']}   
        );
        else if(name === 'prevEvo')    
        setPokemon(
            {_id: pokemon['_id'], name: pokemon['name'], types: [pokemon.types[0], pokemon.types[1]],
            desc: pokemon['desc'], preEvo: value, postEvo: pokemon['postEvo']}   
        );
        else if(name === 'postEvo')    
        setPokemon(
            {_id: pokemon['_id'], name: pokemon['name'], types: [pokemon.types[0], pokemon.types[1]],
            desc: pokemon['desc'], preEvo: pokemon['preEvo'], postEvo: value}   
        );
    }



    function submitForm() {
        props.handleSubmit(pokemon);

        setPokemon({
            _id: '', 
            name: '',         
            types: ['', ''],
            desc: '',
            preEvo: '',
            postEvo: '',
        });
    }

     function addFirstGen() {
        for (var i = 1; i <= 151; i++) {
            props.handleSubmit(
                {_id: i, name: '', types: ['', ''],
                desc: '', preEvo: '', postEvo: ''});
            setPokemon({
                _id: '', 
                name: '',         
                types: ['', ''],
                desc: '',
                preEvo: '',
                postEvo: '',
            });
        }
    }


    return (
        

        <div>
            <Button onClick={addFirstGen}>CLICK ME</Button>
        <form>
			<label htmlFor="_id">Number</label>
            <input
                type="number"
                name="_id"
                _id="_id"
                value={pokemon._id}
                onChange={handleChange} />
            <label htmlFor="name">Name</label>
            
            <input
                type="text"
                name="name"
                id="name"
                value={pokemon.name}
                onChange={handleChange} />
            <br></br>
            <input type="button" value="Submit" onClick={submitForm} />
        </form>
        </div>
    );
}

export default Form;