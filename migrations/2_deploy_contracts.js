var Splitter = artifacts.require("./Splitter.sol");
module.exports = function(deployer) {
accounts = web3.eth.accounts;
console.log("Using Receivers from : " + accounts);
console.log("Deploying Splitter Contract");
deployer.deploy(Splitter,accounts[1],accounts[2]);
};


