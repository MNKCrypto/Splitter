require("file-loader?name=../index.html!../index.html");
const Web3 = require("web3");
const Promise = require("bluebird");
const truffleContract = require("truffle-contract");
const $ = require("jquery");
const splitterJson = require("../../build/contracts/Splitter.json");

if (typeof web3 != 'undefined') {
    window.web3 = new Web3(web3.currentProvider);
} else {
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
}
Promise.promisifyAll(web3.eth, {
    suffix: "Promise"
});
Promise.promisifyAll(web3.version, {
    suffix: "Promise"
});

const Splitter = truffleContract(splitterJson);
Splitter.setProvider(web3.currentProvider);
const splitFunds = function() {
    var receiver1 = $("#receiver1").val();
    var receiver2 = $("#receiver2").val();
    var etherValue = $("#split-ether").val();
    var instance;
   $("#status").html("Split funds transaction in progress");
   $("#split-funds").attr("disabled",true);
   $("#withdraw-funds").attr("disabled",true);
    return Splitter.deployed().then(inst => {
            instance = inst;
            return instance.splitFunds.sendTransaction(receiver1, receiver2, {
                from: window.account,
                value: web3.toWei(etherValue, "ether")
            });
        }).then(txHash => {
            const tryAgain = () => web3.eth.getTransactionReceiptPromise(txHash).then(receipt => receipt !== null ?
                receipt : Promise.delay(1000).then(tryAgain));
            return tryAgain();
        }).then(receipt => {
            if (receipt.logs.length == 0) {
                console.error("Empty logs");
                console.error(receipt);
                $("#status").html("There was an error in the tx execution");
            } else {
                // Format the event nicely.
                console.log("asdasdsa");
                $("#status").html("Transfer executed");
            }
            // Make sure we update the UI.
            return web3.eth.getBalancePromise(window.account);
        }).then(balance => {
            balance = web3.fromWei(balance, "ether");
            $("#wallet-balance").html(balance.toString(10));
            return instance.userBalance(window.account);
        }).then(balance => {
            balance = web3.fromWei(balance, "ether");
            $("#contract-balance").html(balance.toString(10));
            $("#split-funds").attr("disabled",false);
            $("#withdraw-funds").attr("disabled",false);
        })
        .catch(e => {
            $("#status").html(e.toString());
            console.error(e);
            $("#split-funds").attr("disabled",false);
            $("#withdraw-funds").attr("disabled",false);
        });

}
const withdrawFunds = function() {
    var etherValue = $("#withdraw-ether").val();
    var instance;
    $("#split-funds").attr("disabled",true);
    $("#withdraw-funds").attr("disabled",true);
    $("#status").html("Withdraw funds transaction in progress");
    return Splitter.deployed().then(inst => {
            instance = inst;
            return instance.withDrawFunds.sendTransaction(web3.toWei(etherValue,"ether"), {
                from: window.account});
        }).then(txHash => {
            console.log("tes", txHash);
            const tryAgain = () => web3.eth.getTransactionReceiptPromise(txHash).then(receipt => receipt !== null ?
                receipt : Promise.delay(1000).then(tryAgain));
            return tryAgain();
        }).then(receipt => {
            if (receipt.logs.length == 0) {
                console.error("Empty logs");
                console.error(receipt);
                $("#status").html("There was an error in the tx execution");
            } else {
                // Format the event nicely
                $("#status").html("Transfer executed");
            }
            // Make sure we update the UI.
            return web3.eth.getBalancePromise(window.account);
        }).then(balance => {
            balance = web3.fromWei(balance, "ether");
            $("#wallet-balance").html(balance.toString(10));
            return instance.userBalance(window.account);
        }).then(balance => {
            balance = web3.fromWei(balance, "ether");
            $("#contract-balance").html(balance.toString(10));
            $("#split-funds").attr("disabled",false);
            $("#withdraw-funds").attr("disabled",false);
        })
        .catch(e => {
            $("#status").html(e.toString());
            console.error(e);
            $("#split-funds").attr("disabled",false);
            $("#withdraw-funds").attr("disabled",false);
        });

}
Splitter.setProvider(web3.currentProvider);
window.addEventListener('load', function() {
    console.log("Onloading");

    return web3.eth.getAccountsPromise().then(accounts => {
        console.log("accounts");
        if (accounts.length == 0) {
            $("#contract-balance").html("N/A");
            throw new Error("No accounts to transact with");
        }
        window.account = accounts[0];
        console.log("window.account", window.account);
        return web3.version.getNetworkPromise();
    }).then(
        network => {
            console.log("Network: ", network.toString(10));
            return Splitter.deployed();
        }).then(deployed => deployed.userBalance(window.account)).
    then(balance => {
        balance = web3.fromWei(balance, "ether");
        $("#contract-balance").html(balance.toString(10));
        return web3.eth.getBalancePromise(window.account);
    }).then(balance => {
        balance = web3.fromWei(balance, "ether");
        $("#wallet-balance").html(balance.toString(10));
    }).then(() => $("#split-funds").click(splitFunds))
      .then(() => $("#withdraw-funds").click(withdrawFunds)).
    catch(console.err);
});
