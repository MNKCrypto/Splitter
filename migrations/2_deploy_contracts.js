var Splitter = artifacts.require("./Splitter.sol");
module.exports = function(deployer) {
var recCount = 2;
console.log("Deploying Splitter Contract");
deployer.deploy(Splitter,recCount);
};


