// import * as React from 'react';
import React, {useState} from 'react';
import Avatar from '@mui/material/Avatar';
import Button from '@mui/material/Button';
import CssBaseline from '@mui/material/CssBaseline';
import TextField from '@mui/material/TextField';
import FormControlLabel from '@mui/material/FormControlLabel';
import Checkbox from '@mui/material/Checkbox';
import Link from '@mui/material/Link';
import Grid from '@mui/material/Grid';
import Box from '@mui/material/Box';
import PersonAddOutlinedIcon from '@mui/icons-material/PersonAddOutlined';
import Typography from '@mui/material/Typography';
import Container from '@mui/material/Container';
import { createTheme, ThemeProvider } from '@mui/material/styles';
import { useNavigate } from 'react-router-dom'; //-----


const theme = createTheme();

export default function SignIn(props) {
  const navigate = useNavigate();
  const [person, setPerson] = useState(
       {
          _id: "",   //init values for const person
          password: "",
          favorites: []
       }
    );


  const submitForm = (event) => {
    event.preventDefault();
    const data = new FormData(event.currentTarget);
    console.log({
      username: data.get('_id'),
      password: data.get('password'),
    });
    
    //Put data from TextFields into const person
    person._id = data.get('_id');
    person.password = data.get('password');
    person.favorites = data.get('favorites');
    setPerson(person);
    let result = props.handleSubmit(person);
    if (result && result !== undefined) {
      navigate("/login");
    };
  };

  return (
    <ThemeProvider theme={theme}>
      <Container component="main" maxWidth="xs">
        <CssBaseline />
        <Box
          sx={{
            marginTop: 5,
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
          }}
        >
          <Avatar sx={{ m: 1, bgcolor: 'secondary.main' }}>
            <PersonAddOutlinedIcon />
          </Avatar>
          <Typography component="h1" variant="h5">
            Create a New Account
          </Typography>
          <Box component="form" onSubmit={submitForm} noValidate sx={{ mt: 1 }}>
            <TextField
              margin="normal"
              required
              fullWidth
              id="_id"
              label="Username"
              name="_id"
              autoComplete="username"
              autoFocus
              InputLabelProps={{ sx: {top: "-2.0vh", "&.MuiInputLabel-shrink": { top: -2 } } }}   
            />
            <TextField
              margin="normal"
              required
              fullWidth
              name="password"
              label="Password"
              type="password"
              id="password"
              autoComplete="current-password"
              InputLabelProps={{ sx: {top: "-2.0vh", "&.MuiInputLabel-shrink": { top: -2 } } }} 
            />
            <Button
              type="submit"
              fullWidth
              variant="contained"
              sx={{ mt: 3, mb: 2 }}
            >
              Sign Up
            </Button>
          </Box>
        </Box>
      </Container>
    </ThemeProvider>
  );
}