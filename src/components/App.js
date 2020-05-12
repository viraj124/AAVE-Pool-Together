import React, { Component } from 'react';
import logo from '../logo.png';
import Web3 from 'web3';
import AavePool from '../abis/AavePool'

class App extends Component {

  constructor(props) {
    super(props);
    this.state = {
      account: ''
    }
  }

  async componentWillMount() {
    await this.loadBlockchainData()
  }
  async loadBlockchainData() {
    const web3 = new Web3("http://localhost:8545")
    const address = '0x55bc528685195cb0d85adcb22f29a9edab2ce4e5'
    const unlockAddress = '0x2a1530c4c41db0b0b2bb646cb5eb1a67b7158667'
    const daiAddress = '0x6b175474e89094c44da98b954eedeac495271d0f'
    
    const contract = new web3.eth.Contract(AavePool.abi, address)
    await contract.methods.addPool(daiAddress, "1000000000000").send({ from: unlockAddress}).once('receipt', reciept => {
             console.log(reciept)
         })
  }

  render() {
    return (
      <div>
      </div>
    );
  }
}

export default App;