# ====== PokeWiki Project ======

Created by Downward Spiral Development - Andy, Brayden, Daryl, Luke

For CSC 307 Intro SW Dev

Want to view all your favorite pokemons? Come to PokeWiki, to see Pokemon's details from it's number, name, description, types, abilities, height, weight, and background. Select your favorite Pokemons with the heart after logging in. Filter by it's name or types (up to many). Use the "Add Pokemon" Form to add your favorite Pokemons from Numbers 1 to 807! Come join us today at PokeWiki!

UI Prototype: <br/>
https://www.figma.com/file/i8XZuJoseRTDmNSouWl1az/PokeWiki?node-id=0-1&t=wuJl8cf1tR263gr1-0 (03/11/2022) <br/>

Development environment set up: <br/>
#1. Change directory to '.\csc307-wikiProject\expressjs-backend\'. <br/>
#2. Run 'npm run dev' in terminal. <br/>
#3. Change directory to '.\csc307-wikiProject\react-frontend\' on another terminal. <br/>
#4. Run 'npm start' in that terminal. <br/>
#5. Enjoy the Widechus! :D <br/>

<p align = "center">
<img src = "https://github.com/AHuang8693/csc307-wikiProject/blob/main/diagrams/class_diagram.png?raw=true" width=50% height=50%>
  <br>
Figure 1.1: UML Diagram of Pokemons and Users.
</p>
<br>

code linter/formatter used: VSCode extensions "Prettier ESLint" and "ES Lint"

## Packages

### react-frontend
    axios         v1.2.3
    mui           v0.0.1
    react         v18.2.0
    react-dom     v18.2.0
    react-scripts v5.0.1
    web-vitals    v2.1.4

    eslint    v8.7.0
    prettier  v2.5.1
    react-router-dom v6.8.1

### expressjs-backend
    axios    v1.3.4
    cors     v2.8.5
    dotenv   v16.0.3
    express  v4.17.1
    jest     v29.5.0
    mongoose v6.10.2
    
    eslint   v8.7.0
    nodemon  v2.0.13
    prettier v2.5.1
    
## Unit Test Coverage

<img width="958" alt="image" src="https://user-images.githubusercontent.com/77589357/226060576-035537f7-86f6-4f1c-9b80-ea62b878d1f3.png">

Coverage is not 100%, as we skipped try/catch errors due to the complication of disconnecting from mongoose if we wanted to test them.
