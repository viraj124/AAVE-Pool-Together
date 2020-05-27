import React, { Component } from 'react';

import Home from './Home.js';

import { Route ,Switch } from 'react-router-dom';
import Pool from './Pool.js';

class App extends Component {

  render() {
    return (
      <div className="container9">
        <Switch>
         <Route path='/' exact component={Home}/> 
         <Route path='/pool' exact component={Pool}/>
         </Switch>
        
       
      </div>
      
    );
      }
}

export default App;