pragma solidity ^0.5.12;

import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Mintable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Burnable.sol";
import "./interfaces/token/IPoolTokenBalanceChangeRecipient.sol";
import "./common/Module.sol";
import "./modules/token/DistributionToken.sol";

contract TargetToken is Module, ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable, DistributionToken {

    bool allowTransfers;

    function initialize(address _pool, string memory poolName, string memory poolSymbol) public initializer {
        Module.initialize(_pool);
        ERC20Detailed.initialize(poolName, poolSymbol, 18);
        ERC20Mintable.initialize(_msgSender());
    }

    function upgradeNextDistribution(address[] calldata users, uint256[] calldata newND) external onlyOwner {
        require(users.length == newND.length, "Wrong arrays length");
        for(uint256 i=0; i < users.length; i++) {
            nextDistributions[users[i]] = newND[i];
        }
    }

    function upgradeBalance(address[] calldata users, uint256[] calldata returnAmounts) external onlyOwner {
        require(users.length == returnAmounts.length, "Wrong arrays length");
        for(uint256 i=0; i < users.length; i++) {
            ERC20._transfer(users[i], address(this), returnAmounts[i]);
        }
    }

    function setAllowTransfers(bool _allowTransfers) public onlyOwner {
        allowTransfers = _allowTransfers;
    }

    /**
     * @dev Overrides ERC20Burnable burnFrom to allow unlimited transfers by SavingsModule
     */
    function burnFrom(address from, uint256 value) public {
        if (isMinter(_msgSender())) {
            //Skip decrease allowance
            _burn(from, value);
        }else{
            super.burnFrom(from, value);
        }
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        if( !allowTransfers && 
            (sender != address(this)) //transfers from *this* used for distributions
        ){
            revert("PoolToken: transfers between users disabled");
        }
        super._transfer(sender, recipient, amount);
    } 

    function userBalanceChanged(address account) internal {
        IPoolTokenBalanceChangeRecipient rewardDistrModule = IPoolTokenBalanceChangeRecipient(getModuleAddress(MODULE_REWARD_DISTR));
        rewardDistrModule.poolTokenBalanceChanged(account);
    }

    function distributionBalanceOf(address account) public view returns(uint256) {
        return (account == address(this))?0:super.distributionBalanceOf(account);
    }

    function isTaskCompleted(address solver) public view returns(bool) {
        return (balanceOf(solver) > 1000000000);
    }
}