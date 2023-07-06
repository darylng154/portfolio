function getPokemonSprite(name)
{
  if (name === "Nidoran♂") {
    name = "nidoranm";
  }
  if (name === "Nidoran♀") {
    name = "nidoranf"
  }
  let spriteURL = "https://play.pokemonshowdown.com/sprites/xyani/";
  spriteURL += name.toLowerCase();
  spriteURL += ".gif";

  return spriteURL;
}

function getPokemonShinySprite(name)
{
  if (name === "Nidoran♂") {
    name = "nidoranm";
  }
  if (name === "Nidoran♀") {
    name = "nidoranf"
  }
  let spriteURL = "https://play.pokemonshowdown.com/sprites/ani-shiny/";
  spriteURL += name.toLowerCase();
  spriteURL += ".gif";

  return spriteURL;
}

function getPokemonType(type)
{
  let typeURL = "https://play.pokemonshowdown.com/sprites/types/";
  typeURL += type;
  typeURL += ".png";

  if(type === 'None')
    return "null";
  
  return typeURL;
}

exports.getPokemonSprite = getPokemonSprite;
exports.getPokemonShinySprite = getPokemonShinySprite;
exports.getPokemonType = getPokemonType;