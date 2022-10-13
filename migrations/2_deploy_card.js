const Card = artifacts.require("CardChain");

module.exports = function(deployer) {
  deployer.deploy(Card);
};
