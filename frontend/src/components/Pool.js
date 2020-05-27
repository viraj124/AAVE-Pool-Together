import React, { Component } from 'react';

import Web3 from 'web3'; 
import './Pool.css';
import dai from '../Dai.png';


import Intermediate from '../abis/Intermediate.json'
import ProxyFactory from '../abis/ProxyFactory.json'
import Mocklendingpool from '../abis/mocklendingpool.json'
import mockatoken from '../abis/mockatoken.json'
import Dai from '../abis/ERC20.json'
import Pool from '../abis/PoolTogether.json'



import pool from '../pooltogether.png';




const mockLendingAddress = "0x7Fdee497283233794210F91093Ba85ceB90f9066"
const targetAddress = "0xb2315367a090b43b468a55a325eb3f53bccf3d35"

const daiAddress = "0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa"

const mockAtokenAddress = "0x1A73C6c31d4013E1E1A02bb3D6C786d0d443920a"


const factoryAddress = "0x05356bff5e15d217586eaa64cd8ff018872be1e6"
const daiPoolAddress = "0xC3a62C8Af55c59642071bC171Ebd05Eb2479B663";

class Zap extends Component {

  async componentWillMount() {
    await this.loadWeb3()
    await this.loadBlockchainData()
  }

  async loadBlockchainData() {
  const web3 = window.web3

  
  const accounts = await this.state.web3.eth.getAccounts()
  this.setState({ account: accounts[0] })
  console.log(this.state.account);
  
  const intermediateFactory = new this.state.web3.eth.Contract(ProxyFactory, factoryAddress);
  
  this.setState({intermediateFactory});
 

  let getProxy; 
  getProxy =  await this.state.intermediateFactory.methods.getIntermediateUser(this.state.account).call({ from: this.state.account })
  console.log(getProxy);
  this.setState({getProxy});


  if(!getProxy){
    await this.state.intermediateFactory.methods.createIntermediate(targetAddress, this.state.account).send({ from: this.state.account })
  }

    const mocklendingpool = new this.state.web3.eth.Contract(Mocklendingpool, mockLendingAddress)
    this.setState({mocklendingpool});

    const daiContract = new this.state.web3.eth.Contract(Dai.abi, daiAddress)
    this.setState({daiContract});

    const mockAtoken = new this.state.web3.eth.Contract(mockatoken, mockAtokenAddress)
    this.setState({mockAtoken});

    const proxyContract = new this.state.web3.eth.Contract(Intermediate, getProxy)
    this.setState({proxyContract});

    const daiPoolContract = new this.state.web3.eth.Contract(Pool, daiPoolAddress)
    this.setState({daiPoolContract});
    
   
}



async loadWeb3() {
  if (window.ethereum) {
    const web3 = new Web3(window.ethereum)
    await window.ethereum.enable()
    this.setState({ web3 })
  }
  else if (window.web3) {
    const web3 = new Web3(window.web3.currentProvider)
    this.setState({ web3 })
  }
  else {
    window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!')
  }
}


  constructor(props) {
    super(props);
    this.state = {
     account:'',
     result1:'0',
     ethBalance:'0',
     daiContract:{}
    }
   
  }


  deposit = async (etherAmount) => {    
    let result;
    console.log(etherAmount);
    console.log(this.state.daiContract);

    // Approving Mock Lending Pool
    await this.state.daiContract.methods.approve(mockLendingAddress,"100000000000000000000000000000000000000000000000000000000000").send({ from: this.state.account })
    // Calling Deposit in Mock Lending Pool
    await this.state.mocklendingpool.methods.deposit(mockAtokenAddress,etherAmount,1).send({ from: this.state.account })
    // Calling Redirect to proxy
    await this.state.mockAtoken.methods.redirectInterestStream(this.state.getProxy).send({ from: this.state.account })

  }

 invest = async () => {
   
  console.log(this.state.proxyContract);
    await this.state.proxyContract.methods.invest().send({ from: this.state.account })
  }
  

  redeem = async () => {
    console.log(this.state.proxyContract);
    await this.state.proxyContract.methods.redeem().send({ from: this.state.account })
  }

  draw = async () => {
      // Get Current Draw
      const drawId = await this.state.daiPoolContract.methods.currentOpenDrawId().call({ from: this.state.account })
      var drawId1 = drawId.toNumber()
      // Get Draw Winner
      const drawDetails = await this.state.daiPoolContract.methods.getDraw(drawId1).call({ from: this.state.account })
      console.log(drawDetails.winner)
      
      alert("The winner for draw "+drawId1+"  is  "+drawDetails.winner)
  }

  
  render() {


    return (

     
      <div>
  
        <div className="container-fluid mt-5">
          <div className="row">
            <main role="main" className="col-lg-12 d-flex text-center">
              <div className="content mr-auto ml-auto">

              
                <div className="d-flex justify-content-center">
           <div id="container">

            <form className="mb-3" onSubmit={(event) => {
                event.preventDefault()
              let etherAmount;
               etherAmount = this.input.value;
        etherAmount = this.state.web3.utils.toWei(etherAmount.toString(), 'Ether')
        this.deposit(etherAmount);

            }}>

           <div className="title">DEPOSIT</div>

         
     

           
<img src={dai} className="App-logo" alt="logo" />
            <div className="amount">
            <input
            type="text"
            onChange={(event) => {
              const etherAmount = this.input.value.toString()
              this.setState({
                output: etherAmount
              })
              console.log(this.state.output);
            }}
            ref={(input) => { this.input = input }}
            className="form-control form-control-lg"
            placeholder="0"
            required />  
            </div>
            <div className="zap">
            
      <button type="submit" className="button1" >DEPOSIT</button>
            </div>

            </form>
          </div>



          <div id="container1">
           <div className="title">INVEST</div>

         
            
         

           
<img src={pool} className="App-logo1" alt="logo" />
            <div className="amount">
           
            </div>
            <div className="zap">
            
      <button type="submit" className="button1" onClick={this.invest}>INVEST</button>
            </div>
          </div>

  <div id="container2">
           <div className="title">REDEEM</div>

         
            


           
<img src={dai} className="App-logo2" alt="logo" />
            <div className="amount">
            
            </div>
            <div className="zap">
            
      <button type="submit" className="button1"  onClick={this.redeem}>REDEEM</button>
            </div>
          </div>


                
      
</div>


            
            <button type="submit" className="button4"  onClick={this.draw}>DRAW</button>
        
                
              </div>
            </main>
          </div>
        </div>
      </div>
    );
  };
}

export default Zap;
