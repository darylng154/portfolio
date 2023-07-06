
import Box from '@mui/material/Box';
import { Link } from 'react-router-dom';

function Home(props) {


  
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
    return (
        <div>
        <h2>Featured Pokemon</h2>
        <button onClick={() => props.setFeatured(props.pokemon)}>Random Featured!</button>
        <h3>{props.featured.name}</h3>
        <h4>{props.featured.desc}</h4>
        <Link to={"/pokemon/"+props.featured._id}>
        <Box
        component="img"
        sx={{
          height: 250,
          width: 250,
          maxHeight: { xs: 500, md: 250 },
          maxWidth: { xs: 350, md: 1000 },
        }}
        alt="Pokemon Image."
        src = {getImageString(props.featured)}
      />
      </Link>
      </div>
        
    )
}


export default Home;