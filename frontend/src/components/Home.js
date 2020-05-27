import React, { Component } from 'react';
import './Home.css';


import { Link } from 'react-router-dom';
import sitting from '../sitting-2@2x.png';
import standing from '../standing-9.png';



class Home extends Component {

  render() {
    

    return (
      <div>
        <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
        <a
          className="navbar-brand col-sm-3 col-md-2 mr-0"
          target="_blank"
          rel="noopener noreferrer"
        >
        Pool
        </a>
      </nav>


      <h1 className='h1'>Pool</h1>
      <h3 className='h3'>PoolTogether is a no-loss, audited savings</h3>
      <h3 className='h4'>game powered by blockchain technology</h3>
<img src={sitting} className="App-logo3" alt="logo" />
<img src={standing} className="App-logo4" alt="logo" />
<Link to='/pool'><button type="submit" className="button">Go to Pool</button></Link>

</div>
    );
  }
}

export default Home;
