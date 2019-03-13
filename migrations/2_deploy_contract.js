var BananeToken=artifacts.require('./BananeToken.sol');
module.exports = function(deployer) {
      deployer.deploy(BananeToken);
}