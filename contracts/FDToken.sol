//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FDToken is ERC20 {

    constructor() ERC20("Fumigation drone token", "FDTK")  {
      super._mint(msg.sender, 500000 * (10 ** decimals()));
    }

    function decimals() public pure override returns (uint8){
        return 6;
    }

    function mint(address to, uint256 amount) public  {
        super._mint(to, amount);
    }
}