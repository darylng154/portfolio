import { useNavigate } from 'react-router-dom';

function NavBar (props) {
    const navigate = useNavigate();
    function logOuttaHere() {
        props.logOut(); 
        navigate('/')
    }
 return (
 <nav>
       <ul>
          <button className="btn" onClick={() => navigate('/')}> Home</button>
          <t>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;</t>
          <button className="btn" onClick={() => navigate('/users-table')}> Show Pokemon</button>
          <t>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;</t>
          <button className="btn" onClick={() => navigate('/form')}> Add Pokemon</button>
          <t>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;</t>
          {props.currentUser.favorites === undefined ?<button className="btn" onClick={() => navigate('/login')}> Login</button> : 
            <button className="btn" onClick={() => navigate('/favorites')}> Favorites</button>}
        <t>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;</t>
          {props.currentUser.favorites === undefined ?<></> : 
            <button className="btn" onClick={logOuttaHere}>Log Out</button>}

       </ul>
 </nav>
 );
};

export default NavBar;