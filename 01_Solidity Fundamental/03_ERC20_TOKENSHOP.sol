// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.6.0/access/AccessControl.sol";

contract Token is ERC20, AccessControl{
    bytes32 public constant Minter_Role = keccak256("MINTER_ROLE");

    constructor() ERC20("ZAID TOKEN", "ZZZ") {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(Minter_Role, _msgSender());
    }   

    function mint(address to, uint256 amount) public onlyRole(Minter_Role){
        _mint(to, amount);
    }

    function decimals() public pure virtual override returns (uint8){
        return 2;
    }

}


import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface TokenInterface{
    function mint(address account, uint256 amount) external;
}

contract TokenShop{
    AggregatorV3Interface internal priceFeed;
    TokenInterface public minter;
    address public owner;
    uint256 public tokenPrice; 

    constructor(address tokenAddress){
        minter = TokenInterface((tokenAddress));
        
        // Network: Sepolia
        // Aggregator: ETH/USD
        // Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        owner = msg.sender;
        tokenPrice = 200;  // 1 token = 2.00 usd, with 2 decimal places
    }

    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return answer;
    }

    function tokenAmount(uint256 amountETH) public view returns(uint256){
        uint256 ethUsd = uint256(getChainlinkDataFeedLatestAnswer());
        uint256 amountUSD = amountETH * ethUsd / 10**18;
        uint256 amountToken = amountUSD / tokenPrice / 10**(8/2);
        return amountToken;

    } 

    receive() external payable { 
        uint256 amountToken = tokenAmount(msg.value);
        minter.mint(msg.sender, amountToken);
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "only owner");
        _;
    }

    function widthdraw() external onlyOwner{
        payable(owner).transfer(address(this).balance);
    }
}



