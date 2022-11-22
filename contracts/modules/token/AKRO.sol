pragma solidity ^0.5.12;

import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Mintable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol";

contract AKRO is ERC20Detailed, ERC20Mintable {
    string constant NAME    = 'Akropolis token';
    string constant SYMBOL  = 'AKRO';
    uint8 constant DECIMALS = 18;

    function initialize() public initializer {
        ERC20Detailed.initialize(NAME, SYMBOL, DECIMALS);
        ERC20Mintable.initialize(_msgSender());
    }

    function burn(uint256 amount) public onlyMinter {
        _burn(_msgSender(), amount);
    }
}