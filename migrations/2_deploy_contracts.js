var Splitter = artifacts.require("./Splitter.sol");
module.exports = function(deployer,network,accounts) {
console.log("Using Receivers from : " + accounts);
console.log("Deploying Splitter Contract");
deployer.deploy(Splitter);
};


