import * as React from 'react';
import {useTheme } from '@mui/material/styles';
import Box from '@mui/material/Box';
import OutlinedInput from '@mui/material/OutlinedInput';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import Chip from '@mui/material/Chip';

const ITEM_HEIGHT = 48;
const ITEM_PADDING_TOP = 8;
const MenuProps = {
  PaperProps: {
    style: {
      maxHeight: ITEM_HEIGHT * 4.5 + ITEM_PADDING_TOP,
      width: 250,
    },
  },
};

const allTypes = [
  'Fire',
  'Water',
  'Grass',
  'Fighting',
  'Normal',
  'Flying',
  'Rock',
  'Ground',
  'Electric',
  'Ghost',
  'Psychic',
  'Bug',
  'Poison',
  'Ice',
  'Dragon',
  'Dark',
  'Steel',
  'Fairy',
  'None'
  
];

function getStyles(name, personName, theme) {
  return {
    fontWeight:
      personName.indexOf(name) === -1
        ? theme.typography.fontWeightRegular
        : theme.typography.fontWeightMedium,
  };
}
function hasDuplicates(array) {
    var valuesSoFar = Object.create(null);
    for (var i = 0; i < array.length; ++i) {
        var value = array[i];
        if (value in valuesSoFar) {
            return true;
        }
        valuesSoFar[value] = true;
    }
    return false;
}

export default function MultipleSelectChip(props) {
    let typeArr = [];
    for (let i = 0; i < props.types.length; i++) {
        if (props.types[i] !== undefined) {
            typeArr.push(props.types[i]);
        }
    }
  const theme = useTheme();
  //const [personName, setPersonName] = React.useState(props.types);

  const handleChange = (event) => {
    
    const {
      target: { value },
    } = event;
    let newVal = (typeof value === 'string' ? value.split(',') : value);
    if (newVal.length <= 2 && (!hasDuplicates(newVal))) {
    props.setTypes(
      // On autofill we get a stringified value.
      newVal
    );
    }
    

  };

  return (
    <div>
      <FormControl sx={{ m: 1, width: 300 }}>
        <InputLabel id="demo-multiple-chip-label">Select Type</InputLabel>
        <Select
          labelId="demo-multiple-chip-label"
          id="demo-multiple-chip"
          multiple
          value={typeArr}
          onChange={handleChange}
          input={<OutlinedInput id="select-multiple-chip" label="Types" />}
          renderValue={(selected) => (
            <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
              {selected.map((value) => (
                
                <Chip key={value} label={value} />
                
              ))}
            </Box>
          )}
          MenuProps={MenuProps}
        >
          {allTypes.map((name) => (
            <MenuItem
              key={name}
              value={name}
              style={getStyles(name, typeArr, theme)}
            >
              {name}
            </MenuItem>
          ))}
        </Select>
      </FormControl>
    </div>
  );
}