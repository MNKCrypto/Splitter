var Splitter = artifacts.require("./Splitter.sol");

contract("Testing Splitter" , accounts => {
let instance
beforeEach("deploy Splitter", async function() {
instance = await Splitter.new();
})
it("Testing perfect slpit", done => {
var rec1InitialBalance;
var rec2InitialBalance;
var rec1FinaBalance;
var rec2FinalBalance;
var splitFund = web3.toBigNumber(web3.toWei(2,"ether"));
instance.userBalance(accounts[1])
.then(balance => {
rec1InitialBalance = web3.toBigNumber(balance);
return instance.userBalance(accounts[2])
}). 
then (balance => {
rec2InitialBalance = web3.toBigNumber(balance);
return instance.splitFunds(accounts[1],accounts[2],{from:accounts[0],value:web3.toWei(4,"ether")})
}).then (txInfo => {
assert.strictEqual(txInfo.logs.length,1,"Validating Split Transaction");
return instance.userBalance(accounts[1]);
}).then (balance =>{
rec1FinalBalance = web3.toBigNumber(balance);
return instance.userBalance(accounts[2]);
}). then (balance => {
rec2FinalBalance = web3.toBigNumber(balance);
rec1UpdBalance = rec1InitialBalance.plus(splitFund);
rec2UpdBalance = rec2InitialBalance.plus(splitFund);
assert.strictEqual(rec1UpdBalance.toNumber(), rec1FinalBalance.toNumber(),"Validating Receiver 1 fund after split");
assert.strictEqual(rec2UpdBalance.toNumber(), rec2FinalBalance.toNumber(),"Validating Receiver 2 fund after split");
done();
}). catch(done);
});

it("Testing Split with refund to Owner" , async () => {
var rec1InitialBalance = await instance.userBalance(accounts[1]);
rec1InitialBalance = web3.toBigNumber(rec1InitialBalance);
var rec2InitialBalance = await instance.userBalance(accounts[2]);
rec2InitialBalance = web3.toBigNumber(rec2InitialBalance);
var ownerInitialBalance = await instance.userBalance(accounts[0]);
ownerInitialBalance = web3.toBigNumber(ownerInitialBalance);
var splitFund = web3.toBigNumber("100000000000000000000");
var ownerRefund = web3.toBigNumber("000000000000000000001");

let txInfo = await instance.splitFunds(accounts[1],accounts[2],{from:accounts[0],value:"200000000000000000001"});
assert.strictEqual(txInfo.logs.length,1,"Validating Split Transaction");
var rec1FinalBalance = await instance.userBalance(accounts[1]);
var rec2FinalBalance = await instance.userBalance(accounts[2]);
var ownerFinalBalance = await instance.userBalance(accounts[0]);
rec1FinalBalance = web3.toBigNumber(rec1FinalBalance);
rec2FinalBalance = web3.toBigNumber(rec2FinalBalance);
ownerFinalBalance = web3.toBigNumber(ownerFinalBalance);
var updatedRec1Balance = rec1InitialBalance.plus(splitFund);
var updatedRec2Balance = rec2InitialBalance.plus(splitFund);
var updatedOwnerBalance = ownerInitialBalance.plus(ownerRefund);


assert.equal(updatedRec1Balance.toNumber(),rec1FinalBalance.toNumber(),"Validating Receiver 1 Balance after Split");
assert.equal(updatedRec2Balance.toNumber(),rec2FinalBalance.toNumber(),"Validating Receiver 2 Balance after Split");
assert.equal(updatedOwnerBalance.toNumber(),ownerFinalBalance.toNumber(),"Validating Owner Balance after Split");

});

it("Testing withdrawal", function() {
var initialBalance;
return instance.splitFunds(accounts[1],accounts[2],{from:accounts[0],value:web3.toWei(4,"ether")}).
then (txInfo => {
assert.strictEqual(txInfo.logs.length,1,"Validating Split Transaction");
return new Promise((resolve,reject) => {
web3.eth.getBalance(accounts[1],function(error, balance) {
if(error) return error;
else resolve (balance);
})
})
}). then (balance =>{
initialBalance = web3.toBigNumber(balance);
return instance.withDrawFunds(web3.toWei(1, "ether"),{from:accounts[1]});
}).
then (txInfo => {
assert.strictEqual(txInfo.logs.length,1,"Validating WithDrawal Transaction");
return new Promise((resolve,reject) => {
web3.eth.getBalance(accounts[1],function(error, balance) {
if(error) return error;
else resolve (balance);
})
})
}).then(balance => {
finalBalance = web3.toBigNumber(balance);
isBalUpdate = false;
updBalance = initialBalance.plus(web3.toBigNumber(web3.toWei(2, "ether")));
if(initialBalance<finalBalance && finalBalance < updBalance) 
	isBalUpdate= true;
assert.isTrue(isBalUpdate, "Validating receiever Balance after withdrawal");
});

});
});


